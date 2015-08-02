//
//  NSLayoutConstraint+PureLayout.m
//  https://github.com/smileyborg/PureLayout
//
//  Copyright (c) 2013-2015 Tyler Fox
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "NSLayoutConstraint+PureLayout.h"
#import "ALView+PureLayout.h"
#import "PureLayout+Internal.h"


#pragma mark - NSLayoutConstraint+PureLayout

@implementation NSLayoutConstraint (PureLayout)


#pragma mark Installing & Removing Constraints

/**
 Activates the constraint.
 */
- (void)autoInstall
{
#if __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10
    if ([self respondsToSelector:@selector(setActive:)]) {
        [ALView al_applyGlobalStateToConstraint:self];
        if ([ALView al_preventAutomaticConstraintInstallation]) {
            [[ALView al_currentArrayOfCreatedConstraints] addObject:self];
        } else {
            self.active = YES;
        }
        return;
    }
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10 */
    
    NSAssert(self.firstItem || self.secondItem, @"Can't install a constraint with nil firstItem and secondItem.");
    if (self.firstItem) {
        if (self.secondItem) {
            NSAssert([self.firstItem isKindOfClass:[ALView class]] && [self.secondItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if both items are views.");
            ALView *commonSuperview = [self.firstItem al_commonSuperviewWithView:self.secondItem];
            [commonSuperview al_addConstraint:self];
        } else {
            NSAssert([self.firstItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if the item is a view.");
            [self.firstItem al_addConstraint:self];
        }
    } else {
        NSAssert([self.secondItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if the item is a view.");
        [self.secondItem al_addConstraint:self];
    }
}

/**
 Deactivates the constraint.
 */
- (void)autoRemove
{
#if __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10
    if ([self respondsToSelector:@selector(setActive:)]) {
        self.active = NO;
        return;
    }
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10 */
    
    if (self.secondItem) {
        ALView *commonSuperview = [self.firstItem al_commonSuperviewWithView:self.secondItem];
        while (commonSuperview) {
            if ([commonSuperview.constraints containsObject:self]) {
                [commonSuperview removeConstraint:self];
                return;
            }
            commonSuperview = commonSuperview.superview;
        }
    }
    else {
        [self.firstItem removeConstraint:self];
        return;
    }
    NSAssert(nil, @"Failed to remove constraint: %@", self);
}


#pragma mark Identify Constraints

#if __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10

/**
 Sets the string as the identifier for this constraint. Available in iOS 7.0 and OS X 10.9 and later.
 The identifier will be printed along with the constraint's description.
 This is helpful to document a constraint's purpose and aid in debugging.
 
 @param identifier A string used to identify this constraint.
 @return This constraint.
 */
- (instancetype)autoIdentify:(NSString *)identifier
{
    if ([self respondsToSelector:@selector(setIdentifier:)]) {
        self.identifier = identifier;
    }
    return self;
}

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10 */


#pragma mark Internal Methods

/**
 Returns the corresponding NSLayoutAttribute for the given ALAttribute.
 
 @return The layout attribute for the given ALAttribute.
 */
+ (NSLayoutAttribute)al_layoutAttributeForAttribute:(ALAttribute)attribute
{
    NSLayoutAttribute layoutAttribute = NSLayoutAttributeNotAnAttribute;
    switch (attribute) {
        case ALEdgeLeft:
            layoutAttribute = NSLayoutAttributeLeft;
            break;
        case ALEdgeRight:
            layoutAttribute = NSLayoutAttributeRight;
            break;
        case ALEdgeTop:
            layoutAttribute = NSLayoutAttributeTop;
            break;
        case ALEdgeBottom:
            layoutAttribute = NSLayoutAttributeBottom;
            break;
        case ALEdgeLeading:
            layoutAttribute = NSLayoutAttributeLeading;
            break;
        case ALEdgeTrailing:
            layoutAttribute = NSLayoutAttributeTrailing;
            break;
        case ALDimensionWidth:
            layoutAttribute = NSLayoutAttributeWidth;
            break;
        case ALDimensionHeight:
            layoutAttribute = NSLayoutAttributeHeight;
            break;
        case ALAxisVertical:
            layoutAttribute = NSLayoutAttributeCenterX;
            break;
        case ALAxisHorizontal:
            layoutAttribute = NSLayoutAttributeCenterY;
            break;
        case ALAxisBaseline: // same value as ALAxisLastBaseline
            layoutAttribute = NSLayoutAttributeBaseline;
            break;
#if __PureLayout_MinBaseSDK_iOS_8_0
        case ALAxisFirstBaseline:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALAxisFirstBaseline is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeFirstBaseline;
            break;
        case ALMarginLeft:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeLeftMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeLeftMargin;
            break;
        case ALMarginRight:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeRightMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeRightMargin;
            break;
        case ALMarginTop:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeTopMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeTopMargin;
            break;
        case ALMarginBottom:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeBottomMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeBottomMargin;
            break;
        case ALMarginLeading:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeLeadingMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeLeadingMargin;
            break;
        case ALMarginTrailing:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeTrailingMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeTrailingMargin;
            break;
        case ALMarginAxisVertical:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALAxisVerticalMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeCenterXWithinMargins;
            break;
        case ALMarginAxisHorizontal:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALAxisHorizontalMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeCenterYWithinMargins;
            break;
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
        default:
            NSAssert(nil, @"Not a valid ALAttribute.");
            break;
    }
    return layoutAttribute;
}

/**
 Returns the corresponding ALLayoutConstraintAxis for the given ALAxis.
 
 @return The constraint axis for the given axis.
 */
+ (ALLayoutConstraintAxis)al_constraintAxisForAxis:(ALAxis)axis
{
    ALLayoutConstraintAxis constraintAxis;
    switch (axis) {
        case ALAxisVertical:
            constraintAxis = ALLayoutConstraintAxisVertical;
            break;
        case ALAxisHorizontal:
        case ALAxisBaseline: // same value as ALAxisLastBaseline
#if __PureLayout_MinBaseSDK_iOS_8_0
        case ALAxisFirstBaseline:
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
            constraintAxis = ALLayoutConstraintAxisHorizontal;
            break;
        default:
            NSAssert(nil, @"Not a valid ALAxis.");
            constraintAxis = ALLayoutConstraintAxisHorizontal; // default to an arbitrary value to satisfy the compiler
            break;
    }
    return constraintAxis;
}

#if __PureLayout_MinBaseSDK_iOS_8_0

/**
 Returns the corresponding margin for the given edge.
 
 @param edge The edge to convert to the corresponding margin.
 @return The margin for the given edge.
 */
+ (ALMargin)al_marginForEdge:(ALEdge)edge
{
    NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"Margin attributes are only supported on iOS 8.0 or higher.");
    ALMargin margin;
    switch (edge) {
        case ALEdgeLeft:
            margin = ALMarginLeft;
            break;
        case ALEdgeRight:
            margin = ALMarginRight;
            break;
        case ALEdgeTop:
            margin = ALMarginTop;
            break;
        case ALEdgeBottom:
            margin = ALMarginBottom;
            break;
        case ALEdgeLeading:
            margin = ALMarginLeading;
            break;
        case ALEdgeTrailing:
            margin = ALMarginTrailing;
            break;
        default:
            NSAssert(nil, @"Not a valid ALEdge.");
            margin = ALMarginLeft; // default to an arbitrary value to satisfy the compiler
            break;
    }
    return margin;
}

/**
 Returns the corresponding margin axis for the given axis.
 
 @param axis The axis to convert to the corresponding margin axis.
 @return The margin axis for the given axis.
 */
+ (ALMarginAxis)al_marginAxisForAxis:(ALAxis)axis
{
    NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"Margin attributes are only supported on iOS 8.0 or higher.");
    ALMarginAxis marginAxis;
    switch (axis) {
        case ALAxisVertical:
            marginAxis = ALMarginAxisVertical;
            break;
        case ALAxisHorizontal:
            marginAxis = ALMarginAxisHorizontal;
            break;
        case ALAxisBaseline:
        case ALAxisFirstBaseline:
            NSAssert(nil, @"The baseline axis attributes do not have corresponding margin axis attributes.");
            marginAxis = ALMarginAxisVertical; // default to an arbitrary value to satisfy the compiler
            break;
        default:
            NSAssert(nil, @"Not a valid ALAxis.");
            marginAxis = ALMarginAxisVertical; // default to an arbitrary value to satisfy the compiler
            break;
    }
    return marginAxis;
}

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */

@end
