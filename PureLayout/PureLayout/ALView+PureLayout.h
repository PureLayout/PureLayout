//
//  ALView+PureLayout.h
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

#import "PureLayoutDefines.h"


PL__ASSUME_NONNULL_BEGIN

#pragma mark ALView+PureLayout

/**
 A category on UIView/NSView that provides a simple yet powerful interface for creating Auto Layout constraints.
 */
@interface ALView (PureLayout)


#pragma mark Factory & Initializer Methods

/** Creates and returns a new view that does not convert the autoresizing mask into constraints. */
+ (instancetype)newAutoLayoutView;

/** Initializes and returns a new view that does not convert the autoresizing mask into constraints. */
- (instancetype)initForAutoLayout;

/** Configures an existing view to not convert the autoresizing mask into constraints and returns the view. */
- (instancetype)configureForAutoLayout;


#pragma mark Center & Align in Superview

/** Centers the view in its superview. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoCenterInSuperview;

/** Aligns the view to the same axis of its superview. */
- (NSLayoutConstraint *)autoAlignAxisToSuperviewAxis:(ALAxis)axis;

#if PL__PureLayout_MinBaseSDK_iOS_8_0

/** Centers the view in its superview's margins. Available in iOS 8.0 and later. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoCenterInSuperviewMargins;

/** Aligns the view to the corresponding margin axis of its superview. Available in iOS 8.0 and later. */
- (NSLayoutConstraint *)autoAlignAxisToSuperviewMarginAxis:(ALAxis)axis;

#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */


#pragma mark Pin Edges to Superview

/** Pins the given edge of the view to the same edge of its superview. */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(ALEdge)edge;

/** Pins the given edge of the view to the same edge of its superview with an inset. */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(ALEdge)edge withInset:(CGFloat)inset;

/** Pins the given edge of the view to the same edge of its superview with an inset as a maximum or minimum. */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(ALEdge)edge withInset:(CGFloat)inset relation:(NSLayoutRelation)relation;

/** Pins the edges of the view to the edges of its superview. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewEdges;

/** Pins the edges of the view to the edges of its superview with the given edge insets. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewEdgesWithInsets:(ALEdgeInsets)insets;

/** Pins 3 of the 4 edges of the view to the edges of its superview with the given edge insets, excluding one edge. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewEdgesWithInsets:(ALEdgeInsets)insets excludingEdge:(ALEdge)edge;

#if PL__PureLayout_MinBaseSDK_iOS_8_0

/** Pins the given edge of the view to the corresponding margin of its superview. Available in iOS 8.0 and later. */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewMargin:(ALEdge)edge;

/** Pins the given edge of the view to the corresponding margin of its superview as a maximum or minimum. Available in iOS 8.0 and later. */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewMargin:(ALEdge)edge relation:(NSLayoutRelation)relation;

/** Pins the edges of the view to the margins of its superview. Available in iOS 8.0 and later. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewMargins;

/** Pins 3 of the 4 edges of the view to the margins of its superview excluding one edge. Available in iOS 8.0 and later. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewMarginsExcludingEdge:(ALEdge)edge;

#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */


#pragma mark Pin Edges

/** Pins an edge of the view to a given edge of another view. */
- (NSLayoutConstraint *)autoPinEdge:(ALEdge)edge toEdge:(ALEdge)toEdge ofView:(ALView *)otherView;

/** Pins an edge of the view to a given edge of another view with an offset. */
- (NSLayoutConstraint *)autoPinEdge:(ALEdge)edge toEdge:(ALEdge)toEdge ofView:(ALView *)otherView withOffset:(CGFloat)offset;

/** Pins an edge of the view to a given edge of another view with an offset as a maximum or minimum. */
- (NSLayoutConstraint *)autoPinEdge:(ALEdge)edge toEdge:(ALEdge)toEdge ofView:(ALView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation;


#pragma mark Align Axes

/** Aligns an axis of the view to the same axis of another view. */
- (NSLayoutConstraint *)autoAlignAxis:(ALAxis)axis toSameAxisOfView:(ALView *)otherView;

/** Aligns an axis of the view to the same axis of another view with an offset. */
- (NSLayoutConstraint *)autoAlignAxis:(ALAxis)axis toSameAxisOfView:(ALView *)otherView withOffset:(CGFloat)offset;

/** Aligns an axis of the view to the same axis of another view with a multiplier. */
- (NSLayoutConstraint *)autoAlignAxis:(ALAxis)axis toSameAxisOfView:(ALView *)otherView withMultiplier:(CGFloat)multiplier;


#pragma mark Match Dimensions

/** Matches a dimension of the view to a given dimension of another view. */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView;

/** Matches a dimension of the view to a given dimension of another view with an offset. */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withOffset:(CGFloat)offset;

/** Matches a dimension of the view to a given dimension of another view with an offset as a maximum or minimum. */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation;

/** Matches a dimension of the view to a multiple of a given dimension of another view. */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier;

/** Matches a dimension of the view to a multiple of a given dimension of another view as a maximum or minimum. */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier relation:(NSLayoutRelation)relation;


#pragma mark Set Dimensions

/** Sets the view to a specific size. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoSetDimensionsToSize:(CGSize)size;

/** Sets the given dimension of the view to a specific size. */
- (NSLayoutConstraint *)autoSetDimension:(ALDimension)dimension toSize:(CGFloat)size;

/** Sets the given dimension of the view to a specific size as a maximum or minimum. */
- (NSLayoutConstraint *)autoSetDimension:(ALDimension)dimension toSize:(CGFloat)size relation:(NSLayoutRelation)relation;


#pragma mark Set Content Compression Resistance & Hugging

/** Sets the priority of content compression resistance for an axis.
    NOTE: This method must be called from within the block passed into the method +[NSLayoutConstraint autoSetPriority:forConstraints:] */
- (void)autoSetContentCompressionResistancePriorityForAxis:(ALAxis)axis;

/** Sets the priority of content hugging for an axis.
    NOTE: This method must be called from within the block passed into the method +[NSLayoutConstraint autoSetPriority:forConstraints:] */
- (void)autoSetContentHuggingPriorityForAxis:(ALAxis)axis;


#pragma mark Constrain Any Attributes

/** Constrains an attribute of the view to a given attribute of another view. */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView;

/** Constrains an attribute of the view to a given attribute of another view with an offset. */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withOffset:(CGFloat)offset;

/** Constrains an attribute of the view to a given attribute of another view with an offset as a maximum or minimum. */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation;

/** Constrains an attribute of the view to a given attribute of another view with a multiplier. */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier;

/** Constrains an attribute of the view to a given attribute of another view with a multiplier as a maximum or minimum. */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier relation:(NSLayoutRelation)relation;


#pragma mark Pin to Layout Guides (iOS only)

#if TARGET_OS_IPHONE

/** Pins the top edge of the view to the top layout guide of the given view controller with an inset. Available on iOS only. */
- (NSLayoutConstraint *)autoPinToTopLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset;

/** Pins the top edge of the view to the top layout guide of the given view controller with an inset as a maximum or minimum. Available on iOS only. */
- (NSLayoutConstraint *)autoPinToTopLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset relation:(NSLayoutRelation)relation;

/** Pins the bottom edge of the view to the bottom layout guide of the given view controller with an inset. Available on iOS only. */
- (NSLayoutConstraint *)autoPinToBottomLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset;

/** Pins the bottom edge of the view to the bottom layout guide of the given view controller with an inset as a maximum or minimum. Available on iOS only. */
- (NSLayoutConstraint *)autoPinToBottomLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset relation:(NSLayoutRelation)relation;

#endif /* TARGET_OS_IPHONE */

@end

PL__ASSUME_NONNULL_END
