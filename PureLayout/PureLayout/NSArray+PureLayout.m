//
//  NSArray+PureLayout.m
//  https://github.com/PureLayout/PureLayout
//
//  Copyright (c) 2012 Richard Turton
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

#import "NSArray+PureLayout.h"
#import "ALView+PureLayout.h"
#import "NSLayoutConstraint+PureLayout.h"
#import "PureLayout+Internal.h"


#pragma mark - NSArray+PureLayout

@implementation NSArray (PureLayout)


#pragma mark Array of Constraints

/**
 Activates the constraints in this array.
 */
- (void)autoInstallConstraints
{
#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10
    if ([NSLayoutConstraint respondsToSelector:@selector(activateConstraints:)]) {
        for (id object in self) {
            if ([object isKindOfClass:[NSLayoutConstraint class]]) {
                [NSLayoutConstraint al_applyGlobalStateToConstraint:object];
            }
        }
        if ([NSLayoutConstraint al_preventAutomaticConstraintInstallation]) {
            [[NSLayoutConstraint al_currentArrayOfCreatedConstraints] addObjectsFromArray:self];
        } else {
            [NSLayoutConstraint activateConstraints:self];
        }
        return;
    }
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */
    
    for (id object in self) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [((NSLayoutConstraint *)object) autoInstall];
        }
    }
}

/**
 Deactivates the constraints in this array.
 */
- (void)autoRemoveConstraints
{
#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10
    if ([NSLayoutConstraint respondsToSelector:@selector(deactivateConstraints:)]) {
        [NSLayoutConstraint deactivateConstraints:self];
        return;
    }
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */
    
    for (id object in self) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [((NSLayoutConstraint *)object) autoRemove];
        }
    }
}

#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10

/**
 Sets the string as the identifier for the constraints in this array. Available in iOS 7.0 and OS X 10.9 and later.
 The identifier will be printed along with each constraint's description.
 This is helpful to document the constraints' purpose and aid in debugging.
 
 @param identifier A string used to identify the constraints in this array.
 @return This array.
 */
- (instancetype)autoIdentifyConstraints:(NSString *)identifier
{
    for (id object in self) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [((NSLayoutConstraint *)object) autoIdentify:identifier];
        }
    }
    return self;
}

#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */


#pragma mark Array of Views

/**
 Aligns views in this array to one another along a given edge.
 Note: This array must contain at least 2 views, and all views must share a common superview.
 
 @param edge The edge to which the views will be aligned.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoAlignViewsToEdge:(ALEdge)edge
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views.");
    PL__NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    ALView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            if (previousView) {
                [constraints addObject:[view autoPinEdge:edge toEdge:edge ofView:previousView]];
            }
            previousView = view;
        }
    }
    return constraints;
}

/**
 Aligns views in this array to one another along a given axis.
 Note: This array must contain at least 2 views, and all views must share a common superview.
 
 @param axis The axis to which the views will be aligned.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoAlignViewsToAxis:(ALAxis)axis
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views.");
    PL__NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    ALView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            if (previousView) {
                [constraints addObject:[view autoAlignAxis:axis toSameAxisOfView:previousView]];
            }
            previousView = view;
        }
    }
    return constraints;
}

/**
 Matches a given dimension of all the views in this array.
 Note: This array must contain at least 2 views, and all views must share a common superview.
 
 @param dimension The dimension to match for all of the views.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoMatchViewsDimension:(ALDimension)dimension
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views.");
    PL__NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    ALView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            if (previousView) {
                [constraints addObject:[view autoMatchDimension:dimension toDimension:dimension ofView:previousView]];
            }
            previousView = view;
        }
    }
    return constraints;
}

/**
 Sets the given dimension of all the views in this array to a given size.
 Note: This array must contain at least 1 view.
 
 @param dimension The dimension of each of the views to set.
 @param size The size to set the given dimension of each view to.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoSetViewsDimension:(ALDimension)dimension toSize:(CGFloat)size
{
    NSAssert([self al_containsMinimumNumberOfViews:1], @"This array must contain at least 1 view.");
    PL__NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [constraints addObject:[view autoSetDimension:dimension toSize:size]];
        }
    }
    return constraints;
}

/**
 Sets all of the views in this array to a given size.
 Note: This array must contain at least 1 view.
 
 @param size The size to set each view's dimensions to.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoSetViewsDimensionsToSize:(CGSize)size
{
    PL__NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    [constraints addObjectsFromArray:[self autoSetViewsDimension:ALDimensionWidth toSize:size.width]];
    [constraints addObjectsFromArray:[self autoSetViewsDimension:ALDimensionHeight toSize:size.height]];
    return constraints;
}


/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will be the same size (variable) in the dimension along the axis and will have spacing (fixed) between them,
 including from the first and last views to their superview.
 
 @param axis The axis along which to distribute the views.
 @param alignment The attribute to use to align all the views to one another.
 @param spacing The fixed amount of spacing between each view.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoDistributeViewsAlongAxis:(ALAxis)axis
                                                           alignedTo:(ALAttribute)alignment
                                                    withFixedSpacing:(CGFloat)spacing
{
    return [self autoDistributeViewsAlongAxis:axis
                                    alignedTo:alignment
                             withFixedSpacing:spacing
                                 insetSpacing:YES];
}

/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will be the same size (variable) in the dimension along the axis and will have spacing (fixed) between them.
 The first and last views can optionally be inset from their superview by the same amount of spacing as between views.
 
 @param axis The axis along which to distribute the views.
 @param alignment The attribute to use to align all the views to one another.
 @param spacing The fixed amount of spacing between each view.
 @param shouldSpaceInsets Whether the first and last views should be equally inset from their superview.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoDistributeViewsAlongAxis:(ALAxis)axis
                                                           alignedTo:(ALAttribute)alignment
                                                    withFixedSpacing:(CGFloat)spacing
                                                        insetSpacing:(BOOL)shouldSpaceInsets
{
    return [self autoDistributeViewsAlongAxis:axis
                                    alignedTo:alignment
                             withFixedSpacing:spacing
                                 insetSpacing:shouldSpaceInsets
                                 matchedSizes:YES];
}

/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will have fixed spacing between them, and can optionally be constrained to the same size in the dimension along the axis.
 The first and last views can optionally be inset from their superview by the same amount of spacing as between views.
 
 @param axis The axis along which to distribute the views.
 @param alignment The attribute to use to align all the views to one another.
 @param spacing The fixed amount of spacing between each view.
 @param shouldSpaceInsets Whether the first and last views should be equally inset from their superview.
 @param shouldMatchSizes Whether all views will be constrained to be the same size in the dimension along the axis.
                         NOTE: All views must specify an intrinsic content size if passing NO, otherwise the layout will be ambiguous!
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoDistributeViewsAlongAxis:(ALAxis)axis
                                                           alignedTo:(ALAttribute)alignment
                                                    withFixedSpacing:(CGFloat)spacing
                                                        insetSpacing:(BOOL)shouldSpaceInsets
                                                        matchedSizes:(BOOL)shouldMatchSizes
{
    NSAssert([self al_containsMinimumNumberOfViews:1], @"This array must contain at least 1 view to distribute.");
    ALDimension matchedDimension;
    ALEdge firstEdge, lastEdge;
    switch (axis) {
        case ALAxisHorizontal:
        case ALAxisBaseline: // same value as ALAxisLastBaseline
#if PL__PureLayout_MinBaseSDK_iOS_8_0
        case ALAxisFirstBaseline:
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */
            matchedDimension = ALDimensionWidth;
            firstEdge = ALEdgeLeading;
            lastEdge = ALEdgeTrailing;
            break;
        case ALAxisVertical:
            matchedDimension = ALDimensionHeight;
            firstEdge = ALEdgeTop;
            lastEdge = ALEdgeBottom;
            break;
        default:
            NSAssert(nil, @"Not a valid ALAxis.");
            return nil;
    }
    CGFloat leadingSpacing = shouldSpaceInsets ? spacing : 0.0;
    CGFloat trailingSpacing = shouldSpaceInsets ? spacing : 0.0;
    
    PL__NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    ALView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            if (previousView) {
                // Second, Third, ... View
                [constraints addObject:[view autoPinEdge:firstEdge toEdge:lastEdge ofView:previousView withOffset:spacing]];
                if (shouldMatchSizes) {
                    [constraints addObject:[view autoMatchDimension:matchedDimension toDimension:matchedDimension ofView:previousView]];
                }
                [constraints addObject:[view al_alignAttribute:alignment toView:previousView forAxis:axis]];
            }
            else {
                // First view
                [constraints addObject:[view autoPinEdgeToSuperviewEdge:firstEdge withInset:leadingSpacing]];
            }
            previousView = view;
        }
    }
    if (previousView) {
        // Last View
        [constraints addObject:[previousView autoPinEdgeToSuperviewEdge:lastEdge withInset:trailingSpacing]];
    }
    return constraints;
}

/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will be the same size (fixed) in the dimension along the axis and will have spacing (variable) between them,
 including from the first and last views to their superview.
 
 @param axis The axis along which to distribute the views.
 @param alignment The attribute to use to align all the views to one another.
 @param size The fixed size of each view in the dimension along the given axis.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoDistributeViewsAlongAxis:(ALAxis)axis
                                                           alignedTo:(ALAttribute)alignment
                                                       withFixedSize:(CGFloat)size
{
    return [self autoDistributeViewsAlongAxis:axis
                                    alignedTo:alignment
                                withFixedSize:size
                                 insetSpacing:YES];
}

/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will be the same size (fixed) in the dimension along the axis and will have spacing (variable) between them.
 The first and last views can optionally be inset from their superview by the same amount of spacing as between views.
 
 @param axis The axis along which to distribute the views.
 @param alignment The attribute to use to align all the views to one another.
 @param size The fixed size of each view in the dimension along the given axis.
 @param shouldSpaceInsets Whether the first and last views should be equally inset from their superview.
 @return An array of constraints added.
 */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoDistributeViewsAlongAxis:(ALAxis)axis
                                                           alignedTo:(ALAttribute)alignment
                                                       withFixedSize:(CGFloat)size
                                                        insetSpacing:(BOOL)shouldSpaceInsets
{
    NSAssert([self al_containsMinimumNumberOfViews:1], @"This array must contain at least 1 view to distribute.");
    ALDimension fixedDimension;
    NSLayoutAttribute attribute;
    switch (axis) {
        case ALAxisHorizontal:
        case ALAxisBaseline: // same value as ALAxisLastBaseline
#if PL__PureLayout_MinBaseSDK_iOS_8_0
        case ALAxisFirstBaseline:
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */
            fixedDimension = ALDimensionWidth;
            attribute = NSLayoutAttributeCenterX;
            break;
        case ALAxisVertical:
            fixedDimension = ALDimensionHeight;
            attribute = NSLayoutAttributeCenterY;
            break;
        default:
            NSAssert(nil, @"Not a valid ALAxis.");
            return nil;
    }
#if TARGET_OS_IPHONE
#   if !defined(PURELAYOUT_APP_EXTENSIONS)
    BOOL isRightToLeftLayout = [[UIApplication sharedApplication] userInterfaceLayoutDirection] == UIUserInterfaceLayoutDirectionRightToLeft;
#   else
    // App Extensions may not access -[UIApplication sharedApplication]; fall back to checking the bundle's preferred localization character direction
    BOOL isRightToLeftLayout = [NSLocale characterDirectionForLanguage:[[NSBundle mainBundle] preferredLocalizations][0]] == NSLocaleLanguageDirectionRightToLeft;
#   endif /* !defined(PURELAYOUT_APP_EXTENSIONS) */
#else
    BOOL isRightToLeftLayout = [[NSApplication sharedApplication] userInterfaceLayoutDirection] == NSUserInterfaceLayoutDirectionRightToLeft;
#endif /* TARGET_OS_IPHONE */
    BOOL shouldFlipOrder = isRightToLeftLayout && (axis != ALAxisVertical); // imitate the effect of leading/trailing when distributing horizontally
    
    PL__NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    PL__NSArray_of(ALView *) *views = [self al_copyViewsOnly];
    NSUInteger numberOfViews = [views count];
    ALView *commonSuperview = [views al_commonSuperviewOfViews];
    ALView *previousView = nil;
    for (NSUInteger i = 0; i < numberOfViews; i++) {
        ALView *view = shouldFlipOrder ? views[numberOfViews - i - 1] : views[i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [constraints addObject:[view autoSetDimension:fixedDimension toSize:size]];
        CGFloat multiplier, constant;
        if (shouldSpaceInsets) {
            multiplier = (i * 2.0 + 2.0) / (numberOfViews + 1.0);
            constant = (multiplier - 1.0) * size / 2.0;
        } else {
            multiplier = (i * 2.0) / (numberOfViews - 1.0);
            constant = (-multiplier + 1.0) * size / 2.0;
        }
        // If the multiplier is very close to 0, set it to the minimum value to prevent the second item in the constraint from being lost. Filed as rdar://19168380
        if (fabs(multiplier) < kMULTIPLIER_MIN_VALUE) {
            multiplier = kMULTIPLIER_MIN_VALUE;
        }
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:commonSuperview attribute:attribute multiplier:multiplier constant:constant];
        [constraint autoInstall];
        [constraints addObject:constraint];
        if (previousView) {
            [constraints addObject:[view al_alignAttribute:alignment toView:previousView forAxis:axis]];
        }
        previousView = view;
    }
    return constraints;
}

#pragma mark Internal Helper Methods

/**
 Returns the common superview for the views in this array. If there is only one view in the array, its superview will be returned.
 Raises an exception if the views in this array do not share a common superview.
 
 @return The common superview for the views in this array.
 */
- (ALView *)al_commonSuperviewOfViews
{
    ALView *commonSuperview = nil;
    ALView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            if (previousView) {
                commonSuperview = [view al_commonSuperviewWithView:commonSuperview];
            } else {
                commonSuperview = view.superview;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

/**
 Determines whether this array contains a minimum number of views.
 
 @param minimumNumberOfViews The minimum number of views to check for.
 @return YES if this array contains at least the minimum number of views, NO otherwise.
 */
- (BOOL)al_containsMinimumNumberOfViews:(NSUInteger)minimumNumberOfViews
{
    NSUInteger numberOfViews = 0;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            numberOfViews++;
            if (numberOfViews >= minimumNumberOfViews) {
                return YES;
            }
        }
    }
    return numberOfViews >= minimumNumberOfViews;
}

/**
 Creates a copy of this array containing only the view objects in it.
 
 @return A new array containing only the views that are in this array.
 */
- (PL__NSArray_of(ALView *) *)al_copyViewsOnly
{
    PL__NSMutableArray_of(ALView *) *viewsOnlyArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            [viewsOnlyArray addObject:object];
        }
    }
    return viewsOnlyArray;
}

@end
