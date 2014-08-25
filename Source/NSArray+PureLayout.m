//
//  NSArray+PureLayout.m
//  v1.0.1
//  https://github.com/smileyborg/PureLayout
//
//  Copyright (c) 2012 Richard Turton
//  Copyright (c) 2013-2014 Tyler Fox
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


#pragma mark Constrain Multiple Views

/**
 Aligns views in this array to one another along a given edge.
 Note: This array must contain at least 2 views, and all views must share a common superview.
 
 @param edge The edge to which the subviews will be aligned.
 @return An array of constraints added.
 */
- (NSArray *)autoAlignViewsToEdge:(ALEdge)edge
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views.");
    NSMutableArray *constraints = [NSMutableArray new];
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
 
 @param axis The axis to which to subviews will be aligned.
 @return An array of constraints added.
 */
- (NSArray *)autoAlignViewsToAxis:(ALAxis)axis
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views.");
    NSMutableArray *constraints = [NSMutableArray new];
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
 
 @param dimension The dimension to match for all of the subviews.
 @return An array of constraints added.
 */
- (NSArray *)autoMatchViewsDimension:(ALDimension)dimension
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views.");
    NSMutableArray *constraints = [NSMutableArray new];
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
 
 @param dimension The dimension of each of the subviews to set.
 @param size The size to set the given dimension of each subview to.
 @return An array of constraints added.
 */
- (NSArray *)autoSetViewsDimension:(ALDimension)dimension toSize:(CGFloat)size
{
    NSAssert([self al_containsMinimumNumberOfViews:1], @"This array must contain at least 1 view.");
    NSMutableArray *constraints = [NSMutableArray new];
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [constraints addObject:[view autoSetDimension:dimension toSize:size]];
        }
    }
    return constraints;
}


#pragma mark Distribute Multiple Views

/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will be the same size (variable) in the dimension along the axis and will have spacing (fixed) between them,
 including from the first and last views to their superview.
 
 @param axis The axis along which to distribute the subviews.
 @param spacing The fixed amount of spacing between each subview, before the first subview and after the last subview.
 @param alignment The way in which the subviews will be aligned.
 @return An array of constraints added.
 */
- (NSArray *)autoDistributeViewsAlongAxis:(ALAxis)axis withFixedSpacing:(CGFloat)spacing alignment:(NSLayoutFormatOptions)alignment
{
    return [self autoDistributeViewsAlongAxis:axis withFixedSpacing:spacing insetSpacing:YES alignment:alignment];
}

/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will be the same size (variable) in the dimension along the axis and will have spacing (fixed) between them.
 The first and last views can optionally be inset from their superview by the same amount of spacing as between views.
 
 @param axis The axis along which to distribute the subviews.
 @param spacing The fixed amount of spacing between each subview.
 @param shouldSpaceInsets Whether the first and last views should be equally inset from their superview.
 @param alignment The way in which the subviews will be aligned.
 @return An array of constraints added.
 */
- (NSArray *)autoDistributeViewsAlongAxis:(ALAxis)axis withFixedSpacing:(CGFloat)spacing insetSpacing:(BOOL)shouldSpaceInsets alignment:(NSLayoutFormatOptions)alignment
{
    return [self autoDistributeViewsAlongAxis:axis withFixedSpacing:spacing insetSpacing:shouldSpaceInsets alignment:alignment matchDimensions:YES];
}

/**
 Distributes the views in this array equally along the selected axis in their superview.
 The size of the views in the passed dimension is controlled by the matchDimensions parameter, and will have spacing (fixed) between them.
 The first and last views can optionally be inset from their superview by the same amount of spacing as between views.
 
 @param axis The axis along which to distribute the subviews.
 @param spacing The fixed amount of spacing between each subview.
 @param shouldSpaceInsets Whether the first and last views should be equally inset from their superview.
 @param alignment The way in which the subviews will be aligned.
 @param matchDimensions Whether each view will be constrained to be the same size
 @return An array of constraints added.
 */
- (NSArray *)autoDistributeViewsAlongAxis:(ALAxis)axis withFixedSpacing:(CGFloat)spacing insetSpacing:(BOOL)shouldSpaceInsets alignment:(NSLayoutFormatOptions)alignment matchDimensions:(BOOL)matchDimensions
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views to distribute.");
    ALDimension matchedDimension;
    ALEdge firstEdge, lastEdge;
    switch (axis) {
        case ALAxisHorizontal:
        case ALAxisBaseline:
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
    
    NSMutableArray *constraints = [NSMutableArray new];
    ALView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            if (previousView) {
                // Second, Third, ... View
                [constraints addObject:[view autoPinEdge:firstEdge toEdge:lastEdge ofView:previousView withOffset:spacing]];
                if (matchDimensions)
                    [constraints addObject:[view autoMatchDimension:matchedDimension toDimension:matchedDimension ofView:previousView]];
                [constraints addObject:[view al_alignToView:previousView withOption:alignment forAxis:axis]];
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
 
 @param axis The axis along which to distribute the subviews.
 @param size The fixed size of each subview in the dimension along the given axis.
 @param alignment The way in which the subviews will be aligned.
 @return An array of constraints added.
 */
- (NSArray *)autoDistributeViewsAlongAxis:(ALAxis)axis withFixedSize:(CGFloat)size alignment:(NSLayoutFormatOptions)alignment
{
    return [self autoDistributeViewsAlongAxis:axis withFixedSize:size insetSpacing:YES alignment:alignment];
}

/**
 Distributes the views in this array equally along the selected axis in their superview.
 Views will be the same size (fixed) in the dimension along the axis and will have spacing (variable) between them.
 The first and last views can optionally be inset from their superview by the same amount of spacing as between views.
 
 @param axis The axis along which to distribute the subviews.
 @param size The fixed size of each subview in the dimension along the given axis.
 @param shouldSpaceInsets Whether the first and last views should be equally inset from their superview.
 @param alignment The way in which the subviews will be aligned.
 @return An array of constraints added.
 */
- (NSArray *)autoDistributeViewsAlongAxis:(ALAxis)axis withFixedSize:(CGFloat)size insetSpacing:(BOOL)shouldSpaceInsets alignment:(NSLayoutFormatOptions)alignment
{
    NSAssert([self al_containsMinimumNumberOfViews:2], @"This array must contain at least 2 views to distribute.");
    ALDimension fixedDimension;
    NSLayoutAttribute attribute;
    switch (axis) {
        case ALAxisHorizontal:
        case ALAxisBaseline:
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
    BOOL isRightToLeftLanguage = [NSLocale characterDirectionForLanguage:[[NSBundle mainBundle] preferredLocalizations][0]] == NSLocaleLanguageDirectionRightToLeft;
    BOOL shouldFlipOrder = isRightToLeftLanguage && (axis != ALAxisVertical); // imitate the effect of leading/trailing when distributing horizontally
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSArray *views = [self al_copyViewsOnly];
    NSUInteger numberOfViews = [views count];
    ALView *commonSuperview = [views al_commonSuperviewOfViews];
    ALView *previousView = nil;
    for (NSUInteger i = 0; i < numberOfViews; i++) {
        ALView *view = shouldFlipOrder ? views[numberOfViews - i - 1] : views[i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [constraints addObject:[view autoSetDimension:fixedDimension toSize:size]];
        CGFloat multiplier, constant;
        if (shouldSpaceInsets) {
            multiplier = (i * 2.0f + 2.0f) / (numberOfViews + 1.0f);
            constant = (multiplier - 1.0f) * size / 2.0f;
        } else {
            multiplier = (i * 2.0f) / (numberOfViews - 1.0f);
            constant = (-multiplier + 1.0f) * size / 2.0f;
        }
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:commonSuperview attribute:attribute multiplier:multiplier constant:constant];
        [commonSuperview al_addConstraintUsingGlobalPriority:constraint];
        [constraints addObject:constraint];
        if (previousView) {
            [constraints addObject:[view al_alignToView:previousView withOption:alignment forAxis:axis]];
        }
        previousView = view;
    }
    return constraints;
}

#pragma mark Internal Helper Methods

/**
 Returns the common superview for the views in this array.
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
                commonSuperview = view;
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
- (NSArray *)al_copyViewsOnly
{
    NSMutableArray *viewsOnlyArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            [viewsOnlyArray addObject:object];
        }
    }
    return viewsOnlyArray;
}

@end
