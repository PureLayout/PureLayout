//
//  ALView+PureLayout.m
//  v2.0.4
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

#import "ALView+PureLayout.h"
#import "NSLayoutConstraint+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "PureLayout+Internal.h"


#pragma mark - ALView+PureLayout

@implementation ALView (PureLayout)


#pragma mark Factory & Initializer Methods

/** 
 Creates and returns a new view that does not convert the autoresizing mask into constraints.
 */
+ (instancetype)newAutoLayoutView
{
    ALView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

/**
 Initializes and returns a new view that does not convert the autoresizing mask into constraints.
 */
- (instancetype)initForAutoLayout
{
    self = [self init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}


#pragma mark Create Constraints Without Installing

/**
 A global variable that stores a stack of arrays of constraints created without being immediately installed.
 When executing a constraints block passed into the +[autoCreateConstraintsWithoutInstalling:] method, a new
 mutable array is pushed onto this stack, and all constraints created with PureLayout in the block are added
 to this array. When the block finishes executing, the array is popped off this stack. Automatic constraint 
 installation is prevented if this stack contains at least 1 array.
 
 NOTE: Access to this variable is not synchronized (and should only be done on the main thread).
 */
static NSMutableArray *_al_arraysOfCreatedConstraints = nil;

/**
 Accessor for the global state that stores arrays of constraints created without being installed.
 */
+ (NSMutableArray *)al_arraysOfCreatedConstraints
{
    if (!_al_arraysOfCreatedConstraints) {
        _al_arraysOfCreatedConstraints = [NSMutableArray new];
    }
    return _al_arraysOfCreatedConstraints;
}

/**
 Accessor for the current mutable array of constraints created without being immediately installed.
 */
+ (NSMutableArray *)al_currentArrayOfCreatedConstraints
{
    return [[self al_arraysOfCreatedConstraints] lastObject];
}

/**
 Accessor for the global state that determines whether automatic constraint installation should be prevented.
 */
+ (BOOL)al_preventAutomaticConstraintInstallation
{
    return [[self al_arraysOfCreatedConstraints] count] > 0;
}

/** 
 Prevents constraints created in the given constraints block from being automatically installed (activated).
 The constraints created from calls to the PureLayout API in the block are returned in a single array.
 
 @param block A block of method calls to the PureLayout API that create constraints.
 @return An array of the constraints that were created from calls to the PureLayout API inside the block.
 */
+ (NSArray *)autoCreateConstraintsWithoutInstalling:(ALConstraintsBlock)block
{
    NSAssert(block, @"The constraints block cannot be nil.");
    NSArray *createdConstraints = nil;
    if (block) {
        [[self al_arraysOfCreatedConstraints] addObject:[NSMutableArray new]];
        block();
        createdConstraints = [self al_currentArrayOfCreatedConstraints];
        [[self al_arraysOfCreatedConstraints] removeLastObject];
    }
    return createdConstraints;
}


#pragma mark Set Priority For Constraints

/** 
 A global variable that stores a stack of layout priorities to set on constraints.
 When executing a constraints block passed into the +[autoSetPriority:forConstraints:] method, the priority for
 that call is pushed onto this stack, and when the block finishes executing, that priority is popped off this
 stack. If this stack contains at least 1 priority, the priority at the top of the stack will be set for all 
 constraints created by this library (even if automatic constraint installation is being prevented).
 NOTE: Access to this variable is not synchronized (and should only be done on the main thread).
 */
static NSMutableArray *_al_globalConstraintPriorities = nil;

/**
 Accessor for the global stack of layout priorities.
 */
+ (NSMutableArray *)al_globalConstraintPriorities
{
    if (!_al_globalConstraintPriorities) {
        _al_globalConstraintPriorities = [NSMutableArray new];
    }
    return _al_globalConstraintPriorities;
}

/**
 Returns the current layout priority to use for constraints.
 When executing a constraints block passed into +[autoSetPriority:forConstraints:], this will return
 the priority for the current block. Otherwise, the default Required priority is returned.
 */
+ (ALLayoutPriority)al_currentGlobalConstraintPriority
{
    NSMutableArray *globalConstraintPriorities = [self al_globalConstraintPriorities];
    if ([globalConstraintPriorities count] == 0) {
        return ALLayoutPriorityRequired;
    }
    return [[globalConstraintPriorities lastObject] floatValue];
}

/**
 Accessor for the global state that determines if we're currently in the scope of a priority constraints block.
 */
+ (BOOL)al_isExecutingPriorityConstraintsBlock
{
    return [[self al_globalConstraintPriorities] count] > 0;
}

/**
 Sets the constraint priority to the given value for all constraints created using the PureLayout
 API within the given constraints block.
 
 NOTE: This method will have no effect (and will NOT set the priority) on constraints created or added 
 without using the PureLayout API!
 
 @param priority The layout priority to be set on all constraints created in the constraints block.
 @param block A block of method calls to the PureLayout API that create and install constraints.
 */
+ (void)autoSetPriority:(ALLayoutPriority)priority forConstraints:(ALConstraintsBlock)block
{
    NSAssert(block, @"The constraints block cannot be nil.");
    if (block) {
        [[self al_globalConstraintPriorities] addObject:@(priority)];
        block();
        [[self al_globalConstraintPriorities] removeLastObject];
    }
}


#pragma mark Set Identifier For Constraints

#if __PureLayout_MinBaseSDK_iOS_8_0

/**
 A global variable that stores a stack of identifier strings to set on constraints.
 When executing a constraints block passed into the +[autoSetIdentifier:forConstraints:] method, the identifier for
 that call is pushed onto this stack, and when the block finishes executing, that identifier is popped off this
 stack. If this stack contains at least 1 identifier, the identifier at the top of the stack will be set for all
 constraints created by this library (even if automatic constraint installation is being prevented).
 NOTE: Access to this variable is not synchronized (and should only be done on the main thread).
 */
static NSMutableArray *_al_globalConstraintIdentifiers = nil;

/**
 Accessor for the global state of constraint identifiers.
 */
+ (NSMutableArray *)al_globalConstraintIdentifiers
{
    if (!_al_globalConstraintIdentifiers) {
        _al_globalConstraintIdentifiers = [NSMutableArray new];
    }
    return _al_globalConstraintIdentifiers;
}

/**
 Returns the current identifier string to use for constraints.
 When executing a constraints block passed into +[autoSetIdentifier:forConstraints:], this will return
 the identifier for the current block. Otherwise, nil is returned.
 */
+ (NSString *)al_currentGlobalConstraintIdentifier
{
    NSMutableArray *globalConstraintIdentifiers = [self al_globalConstraintIdentifiers];
    if ([globalConstraintIdentifiers count] == 0) {
        return nil;
    }
    return [globalConstraintIdentifiers lastObject];
}

/** 
 Sets the identifier for all constraints created using the PureLayout API within the given constraints block.
 
 NOTE: This method will have no effect (and will NOT set the identifier) on constraints created or added
 without using the PureLayout API!
 
 @param identifer A string used to identify all constraints created in the constraints block.
 @param block A block of method calls to the PureLayout API that create and install constraints.
 */
+ (void)autoSetIdentifier:(NSString *)identifer forConstraints:(ALConstraintsBlock)block
{
    NSAssert(block, @"The constraints block cannot be nil.");
    NSAssert(identifer, @"The identifier string cannot be nil.");
    if (block) {
        if (identifer) {
            [[self al_globalConstraintIdentifiers] addObject:identifer];
        }
        block();
        if (identifer) {
            [[self al_globalConstraintIdentifiers] removeLastObject];
        }
    }
}

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */


#pragma mark Center in Superview

/**
 Centers the view in its superview.
 
 @return An array of constraints added.
 */
- (NSArray *)autoCenterInSuperview
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [constraints addObject:[self autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    return constraints;
}

/**
 Aligns the view to the same axis of its superview.
 
 @param axis The axis of this view and of its superview to align.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoAlignAxisToSuperviewAxis:(ALAxis)axis
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    ALView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    return [self autoConstrainAttribute:(ALAttribute)axis toAttribute:(ALAttribute)axis ofView:superview];
}

#if __PureLayout_MinBaseSDK_iOS_8_0

/**
 Centers the view in its superview, taking into account the layout margins of both the view and its superview.
 
 @return An array of constraints added.
 */
- (NSArray *)autoCenterInSuperviewMargins
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal]];
    [constraints addObject:[self autoAlignAxisToSuperviewMarginAxis:ALAxisVertical]];
    return constraints;
}

/**
 Aligns the view to the corresponding margin axis of its superview.
 
 @param axis The axis of this view to align to the corresponding margin axis of its superview.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoAlignAxisToSuperviewMarginAxis:(ALAxis)axis
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    ALView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    ALMarginAxis marginAxis = [NSLayoutConstraint al_marginAxisForAxis:axis];
    return [self autoConstrainAttribute:(ALAttribute)axis toAttribute:(ALAttribute)marginAxis ofView:superview];
}

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */


#pragma mark Pin Edges to Superview

/**
 Pins the given edge of the view to the same edge of its superview.
 
 @param edge The edge of this view and its superview to pin.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(ALEdge)edge
{
    return [self autoPinEdgeToSuperviewEdge:edge withInset:0.0];
}

/**
 Pins the given edge of the view to the same edge of its superview with an inset.
 
 @param edge The edge of this view and its superview to pin.
 @param inset The amount to inset this view's edge from the superview's edge.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(ALEdge)edge withInset:(CGFloat)inset
{
    return [self autoPinEdgeToSuperviewEdge:edge withInset:inset relation:NSLayoutRelationEqual];
}

/**
 Pins the given edge of the view to the same edge of its superview with an inset as a maximum or minimum.
 
 @param edge The edge of this view and its superview to pin.
 @param inset The amount to inset this view's edge from the superview's edge.
 @param relation Whether the inset should be at least, at most, or exactly equal to the given value.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(ALEdge)edge withInset:(CGFloat)inset relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    ALView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    if (edge == ALEdgeBottom || edge == ALEdgeRight || edge == ALEdgeTrailing) {
        // The bottom, right, and trailing insets (and relations, if an inequality) are inverted to become offsets
        inset = -inset;
        if (relation == NSLayoutRelationLessThanOrEqual) {
            relation = NSLayoutRelationGreaterThanOrEqual;
        } else if (relation == NSLayoutRelationGreaterThanOrEqual) {
            relation = NSLayoutRelationLessThanOrEqual;
        }
    }
    return [self autoPinEdge:edge toEdge:edge ofView:superview withOffset:inset relation:relation];
}

/**
 Pins the edges of the view to the edges of its superview with the given edge insets.
 The insets.left corresponds to a leading edge constraint, and insets.right corresponds to a trailing edge constraint.
 
 @param insets The insets for this view's edges from its superview's edges.
 @return An array of constraints added.
 */
- (NSArray *)autoPinEdgesToSuperviewEdgesWithInsets:(ALEdgeInsets)insets
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:insets.top]];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:insets.left]];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:insets.bottom]];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:insets.right]];
    return constraints;
}

/**
 Pins 3 of the 4 edges of the view to the edges of its superview with the given edge insets, excluding one edge.
 The insets.left corresponds to a leading edge constraint, and insets.right corresponds to a trailing edge constraint.
 
 @param insets The insets for this view's edges from its superview's edges. The inset corresponding to the excluded edge
               will be ignored.
 @param edge The edge of this view to exclude in pinning to its superview; this method will not apply any constraint to it.
 @return An array of constraints added.
 */
- (NSArray *)autoPinEdgesToSuperviewEdgesWithInsets:(ALEdgeInsets)insets excludingEdge:(ALEdge)edge
{
    NSMutableArray *constraints = [NSMutableArray new];
    if (edge != ALEdgeTop) {
        [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:insets.top]];
    }
    if (edge != ALEdgeLeading && edge != ALEdgeLeft) {
        [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:insets.left]];
    }
    if (edge != ALEdgeBottom) {
        [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:insets.bottom]];
    }
    if (edge != ALEdgeTrailing && edge != ALEdgeRight) {
        [constraints addObject:[self autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:insets.right]];
    }
    return constraints;
}

#if __PureLayout_MinBaseSDK_iOS_8_0
        
/**
 Pins the given edge of the view to the corresponding margin of its superview.
 
 @param edge The edge of this view to pin to the corresponding margin of its superview.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewMargin:(ALEdge)edge
{
    return [self autoPinEdgeToSuperviewMargin:edge relation:NSLayoutRelationEqual];
}

/**
 Pins the given edge of the view to the corresponding margin of its superview as a maximum or minimum.
 
 @param edge The edge of this view to pin to the corresponding margin of its superview.
 @param relation Whether the edge should be inset by at least, at most, or exactly the superview's margin.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewMargin:(ALEdge)edge relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    ALView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    if (edge == ALEdgeBottom || edge == ALEdgeRight || edge == ALEdgeTrailing) {
        // The bottom, right, and trailing relations are inverted
        if (relation == NSLayoutRelationLessThanOrEqual) {
            relation = NSLayoutRelationGreaterThanOrEqual;
        } else if (relation == NSLayoutRelationGreaterThanOrEqual) {
            relation = NSLayoutRelationLessThanOrEqual;
        }
    }
    ALMargin margin = [NSLayoutConstraint al_marginForEdge:edge];
    return [self autoConstrainAttribute:(ALAttribute)edge toAttribute:(ALAttribute)margin ofView:superview withOffset:0.0 relation:relation];
}
        
/**
 Pins the edges of the view to the margins of its superview.
 
 @return An array of constraints added.
 */
- (NSArray *)autoPinEdgesToSuperviewMargins
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeTop]];
    [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeLeading]];
    [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeBottom]];
    [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeTrailing]];
    return constraints;
}

/**
 Pins 3 of the 4 edges of the view to the margins of its superview, excluding one edge.
 
 @param edge The edge of this view to exclude in pinning to its superview; this method will not apply any constraint to it.
 @return An array of constraints added.
 */
- (NSArray *)autoPinEdgesToSuperviewMarginsExcludingEdge:(ALEdge)edge
{
    NSMutableArray *constraints = [NSMutableArray new];
    if (edge != ALEdgeTop) {
        [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeTop]];
    }
    if (edge != ALEdgeLeading && edge != ALEdgeLeft) {
        [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeLeading]];
    }
    if (edge != ALEdgeBottom) {
        [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeBottom]];
    }
    if (edge != ALEdgeTrailing && edge != ALEdgeRight) {
        [constraints addObject:[self autoPinEdgeToSuperviewMargin:ALEdgeTrailing]];
    }
    return constraints;
}

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */


#pragma mark Pin Edges

/**
 Pins an edge of the view to a given edge of another view.
 
 @param edge The edge of this view to pin.
 @param toEdge The edge of the other view to pin to.
 @param otherView The other view to pin to. Must be in the same view hierarchy as this view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdge:(ALEdge)edge toEdge:(ALEdge)toEdge ofView:(ALView *)otherView
{
    return [self autoPinEdge:edge toEdge:toEdge ofView:otherView withOffset:0.0];
}

/**
 Pins an edge of the view to a given edge of another view with an offset.
 
 @param edge The edge of this view to pin.
 @param toEdge The edge of the other view to pin to.
 @param otherView The other view to pin to. Must be in the same view hierarchy as this view.
 @param offset The offset between the edge of this view and the edge of the other view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdge:(ALEdge)edge toEdge:(ALEdge)toEdge ofView:(ALView *)otherView withOffset:(CGFloat)offset
{
    return [self autoPinEdge:edge toEdge:toEdge ofView:otherView withOffset:offset relation:NSLayoutRelationEqual];
}

/**
 Pins an edge of the view to a given edge of another view with an offset as a maximum or minimum.
 
 @param edge The edge of this view to pin.
 @param toEdge The edge of the other view to pin to.
 @param otherView The other view to pin to. Must be in the same view hierarchy as this view.
 @param offset The offset between the edge of this view and the edge of the other view.
 @param relation Whether the offset should be at least, at most, or exactly equal to the given value.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinEdge:(ALEdge)edge toEdge:(ALEdge)toEdge ofView:(ALView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    return [self autoConstrainAttribute:(ALAttribute)edge toAttribute:(ALAttribute)toEdge ofView:otherView withOffset:offset relation:relation];
}


#pragma mark Align Axes

/**
 Aligns an axis of the view to the same axis of another view.
 
 @param axis The axis of this view and the other view to align.
 @param otherView The other view to align to. Must be in the same view hierarchy as this view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoAlignAxis:(ALAxis)axis toSameAxisOfView:(ALView *)otherView
{
    return [self autoAlignAxis:axis toSameAxisOfView:otherView withOffset:0.0];
}

/**
 Aligns an axis of the view to the same axis of another view with an offset.
 
 @param axis The axis of this view and the other view to align.
 @param otherView The other view to align to. Must be in the same view hierarchy as this view.
 @param offset The offset between the axis of this view and the axis of the other view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoAlignAxis:(ALAxis)axis toSameAxisOfView:(ALView *)otherView withOffset:(CGFloat)offset
{
    return [self autoConstrainAttribute:(ALAttribute)axis toAttribute:(ALAttribute)axis ofView:otherView withOffset:offset];
}


#pragma mark Match Dimensions

/**
 Matches a dimension of the view to a given dimension of another view.
 
 @param dimension The dimension of this view to pin.
 @param toDimension The dimension of the other view to pin to.
 @param otherView The other view to match to. Must be in the same view hierarchy as this view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView
{
    return [self autoMatchDimension:dimension toDimension:toDimension ofView:otherView withOffset:0.0];
}

/**
 Matches a dimension of the view to a given dimension of another view with an offset.
 
 @param dimension The dimension of this view to pin.
 @param toDimension The dimension of the other view to pin to.
 @param otherView The other view to match to. Must be in the same view hierarchy as this view.
 @param offset The offset between the dimension of this view and the dimension of the other view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withOffset:(CGFloat)offset
{
    return [self autoMatchDimension:dimension toDimension:toDimension ofView:otherView withOffset:offset relation:NSLayoutRelationEqual];
}

/**
 Matches a dimension of the view to a given dimension of another view with an offset as a maximum or minimum.
 
 @param dimension The dimension of this view to pin.
 @param toDimension The dimension of the other view to pin to.
 @param otherView The other view to match to. Must be in the same view hierarchy as this view.
 @param offset The offset between the dimension of this view and the dimension of the other view.
 @param relation Whether the offset should be at least, at most, or exactly equal to the given value.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    return [self autoConstrainAttribute:(ALAttribute)dimension toAttribute:(ALAttribute)toDimension ofView:otherView withOffset:offset relation:relation];
}

/**
 Matches a dimension of the view to a multiple of a given dimension of another view.
 
 @param dimension The dimension of this view to pin.
 @param toDimension The dimension of the other view to pin to.
 @param otherView The other view to match to. Must be in the same view hierarchy as this view.
 @param multiplier The multiple of the other view's given dimension that this view's given dimension should be.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier
{
    return [self autoMatchDimension:dimension toDimension:toDimension ofView:otherView withMultiplier:multiplier relation:NSLayoutRelationEqual];
}

/**
 Matches a dimension of the view to a multiple of a given dimension of another view as a maximum or minimum.
 
 @param dimension The dimension of this view to pin.
 @param toDimension The dimension of the other view to pin to.
 @param otherView The other view to match to. Must be in the same view hierarchy as this view.
 @param multiplier The multiple of the other view's given dimension that this view's given dimension should be.
 @param relation Whether the multiple should be at least, at most, or exactly equal to the given value.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier relation:(NSLayoutRelation)relation
{
    return [self autoConstrainAttribute:(ALAttribute)dimension toAttribute:(ALAttribute)toDimension ofView:otherView withMultiplier:multiplier relation:relation];
}


#pragma mark Set Dimensions

/**
 Sets the view to a specific size.
 
 @param size The size to set this view's dimensions to.
 @return An array of constraints added.
 */
- (NSArray *)autoSetDimensionsToSize:(CGSize)size
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self autoSetDimension:ALDimensionWidth toSize:size.width]];
    [constraints addObject:[self autoSetDimension:ALDimensionHeight toSize:size.height]];
    return constraints;
}

/**
 Sets the given dimension of the view to a specific size.
 
 @param dimension The dimension of this view to set.
 @param size The size to set the given dimension to.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoSetDimension:(ALDimension)dimension toSize:(CGFloat)size
{
    return [self autoSetDimension:dimension toSize:size relation:NSLayoutRelationEqual];
}

/**
 Sets the given dimension of the view to a specific size as a maximum or minimum.
 
 @param dimension The dimension of this view to set.
 @param size The size to set the given dimension to.
 @param relation Whether the size should be at least, at most, or exactly equal to the given value.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoSetDimension:(ALDimension)dimension toSize:(CGFloat)size relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutAttribute layoutAttribute = [NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)dimension];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:layoutAttribute relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:size];
    [constraint autoInstall];
    return constraint;
}


#pragma mark Set Content Compression Resistance & Hugging

/**
 Sets the priority of content compression resistance for an axis.
 NOTE: This method must be called from within the block passed into the method +[autoSetPriority:forConstraints:]
 
 @param axis The axis to set the content compression resistance priority for.
 */
- (void)autoSetContentCompressionResistancePriorityForAxis:(ALAxis)axis
{
    NSAssert([ALView al_isExecutingPriorityConstraintsBlock], @"%@ should only be called from within the block passed into the method +[autoSetPriority:forConstraints:]", NSStringFromSelector(_cmd));
    if ([ALView al_isExecutingPriorityConstraintsBlock]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        ALLayoutConstraintAxis constraintAxis = [NSLayoutConstraint al_constraintAxisForAxis:axis];
#if TARGET_OS_IPHONE
        [self setContentCompressionResistancePriority:[ALView al_currentGlobalConstraintPriority] forAxis:constraintAxis];
#else
        [self setContentCompressionResistancePriority:[ALView al_currentGlobalConstraintPriority] forOrientation:constraintAxis];
#endif /* TARGET_OS_IPHONE */
    }
}

/**
 Sets the priority of content hugging for an axis.
 NOTE: This method must be called from within the block passed into the method +[autoSetPriority:forConstraints:]
 
 @param axis The axis to set the content hugging priority for.
 */
- (void)autoSetContentHuggingPriorityForAxis:(ALAxis)axis
{
    NSAssert([ALView al_isExecutingPriorityConstraintsBlock], @"%@ should only be called from within the block passed into the method +[autoSetPriority:forConstraints:]", NSStringFromSelector(_cmd));
    if ([ALView al_isExecutingPriorityConstraintsBlock]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        ALLayoutConstraintAxis constraintAxis = [NSLayoutConstraint al_constraintAxisForAxis:axis];
#if TARGET_OS_IPHONE
        [self setContentHuggingPriority:[ALView al_currentGlobalConstraintPriority] forAxis:constraintAxis];
#else
        [self setContentHuggingPriority:[ALView al_currentGlobalConstraintPriority] forOrientation:constraintAxis];
#endif /* TARGET_OS_IPHONE */
    }
}


#pragma mark Constrain Any Attributes

/**
 Constrains an attribute of the view to a given attribute of another view.
 This method can be used to constrain different types of attributes across two views.
 
 @param attribute Any attribute of this view to constrain.
 @param toAttribute Any attribute of the other view to constrain to.
 @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView
{
    return [self autoConstrainAttribute:attribute toAttribute:toAttribute ofView:otherView withOffset:0.0];
}

/**
 Constrains an attribute of the view to a given attribute of another view with an offset.
 This method can be used to constrain different types of attributes across two views.
 
 @param attribute Any attribute of this view to constrain.
 @param toAttribute Any attribute of the other view to constrain to.
 @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
 @param offset The offset between the attribute of this view and the attribute of the other view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withOffset:(CGFloat)offset
{
    return [self autoConstrainAttribute:attribute toAttribute:toAttribute ofView:otherView withOffset:offset relation:NSLayoutRelationEqual];
}

/**
 Constrains an attribute of the view to a given attribute of another view with an offset as a maximum or minimum.
 This method can be used to constrain different types of attributes across two views.
 
 @param attribute Any attribute of this view to constrain.
 @param toAttribute Any attribute of the other view to constrain to.
 @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
 @param offset The offset between the attribute of this view and the attribute of the other view.
 @param relation Whether the offset should be at least, at most, or exactly equal to the given value.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutAttribute layoutAttribute = [NSLayoutConstraint al_layoutAttributeForAttribute:attribute];
    NSLayoutAttribute toLayoutAttribute = [NSLayoutConstraint al_layoutAttributeForAttribute:toAttribute];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:layoutAttribute relatedBy:relation toItem:otherView attribute:toLayoutAttribute multiplier:1.0 constant:offset];
    [constraint autoInstall];
    return constraint;
}

/**
 Constrains an attribute of the view to a given attribute of another view with a multiplier.
 This method can be used to constrain different types of attributes across two views.
 
 @param attribute Any attribute of this view to constrain.
 @param toAttribute Any attribute of the other view to constrain to.
 @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
 @param multiplier The multiplier between the attribute of this view and the attribute of the other view.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier
{
    return [self autoConstrainAttribute:attribute toAttribute:toAttribute ofView:otherView withMultiplier:multiplier relation:NSLayoutRelationEqual];
}

/**
 Constrains an attribute of the view to a given attribute of another view with a multiplier as a maximum or minimum.
 This method can be used to constrain different types of attributes across two views.
 
 @param attribute Any attribute of this view to constrain.
 @param toAttribute Any attribute of the other view to constrain to.
 @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
 @param multiplier The multiplier between the attribute of this view and the attribute of the other view.
 @param relation Whether the multiplier should be at least, at most, or exactly equal to the given value.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoConstrainAttribute:(ALAttribute)attribute toAttribute:(ALAttribute)toAttribute ofView:(ALView *)otherView withMultiplier:(CGFloat)multiplier relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutAttribute layoutAttribute = [NSLayoutConstraint al_layoutAttributeForAttribute:attribute];
    NSLayoutAttribute toLayoutAttribute = [NSLayoutConstraint al_layoutAttributeForAttribute:toAttribute];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:layoutAttribute relatedBy:relation toItem:otherView attribute:toLayoutAttribute multiplier:multiplier constant:0.0];
    [constraint autoInstall];
    return constraint;
}


#pragma mark Pin to Layout Guides

#if TARGET_OS_IPHONE

/**
 Pins the top edge of the view to the top layout guide of the given view controller with an inset.
 For compatibility with iOS 6 (where layout guides do not exist), this method will simply pin the top edge of
 the view to the top edge of the given view controller's view with an inset.
 
 @param viewController The view controller whose topLayoutGuide should be used to pin to.
 @param inset The amount to inset this view's top edge from the layout guide.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinToTopLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset
{
    return [self autoPinToTopLayoutGuideOfViewController:viewController withInset:inset relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)autoPinToTopLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset relation:(NSLayoutRelation)relation
{
    if (__PureLayout_MinSysVer_iOS_7_0) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:relation toItem:viewController.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:inset];
        [viewController.view al_addConstraint:constraint]; // Can't use autoInstall because the layout guide is not a view
        return constraint;
    } else {
        // iOS 6 fallback
        return [self autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:viewController.view withOffset:inset relation:relation];
    }
}

/**
 Pins the bottom edge of the view to the bottom layout guide of the given view controller with an inset.
 For compatibility with iOS 6 (where layout guides do not exist), this method will simply pin the bottom edge of
 the view to the bottom edge of the given view controller's view with an inset.
 
 @param viewController The view controller whose bottomLayoutGuide should be used to pin to.
 @param inset The amount to inset this view's bottom edge from the layout guide.
 @return The constraint added.
 */
- (NSLayoutConstraint *)autoPinToBottomLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset
{
    return [self autoPinToBottomLayoutGuideOfViewController:viewController withInset:inset relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)autoPinToBottomLayoutGuideOfViewController:(UIViewController *)viewController withInset:(CGFloat)inset relation:(NSLayoutRelation)relation
{
    // The bottom inset (and relation, if an inequality) is inverted to become an offset
    inset = -inset;
    if (relation == NSLayoutRelationLessThanOrEqual) {
        relation = NSLayoutRelationGreaterThanOrEqual;
    } else if (relation == NSLayoutRelationGreaterThanOrEqual) {
        relation = NSLayoutRelationLessThanOrEqual;
    }
    if (__PureLayout_MinSysVer_iOS_7_0) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:relation toItem:viewController.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:inset];
        [viewController.view al_addConstraint:constraint]; // Can't use autoInstall because the layout guide is not a view
        return constraint;
    } else {
        // iOS 6 fallback
        return [self autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:viewController.view withOffset:inset relation:relation];
    }
}

#endif /* TARGET_OS_IPHONE */


#pragma mark Deprecated Methods

/**
 DEPRECATED as of PureLayout v2.0.0. Retain a reference to and remove specific constraints instead, or recreate the view(s) entirely to remove all constraints.
 Removes all explicit constraints that affect the view.
 WARNING: Apple's constraint solver is not optimized for large-scale constraint removal; you may encounter major performance issues after using this method.
 It is not recommended to use this method to "reset" a view for reuse in a different way with new constraints. Create a new view instead.
 NOTE: This method preserves implicit constraints, such as intrinsic content size constraints, which you usually do not want to remove.
 */
- (void)autoRemoveConstraintsAffectingView
{
    [self autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:NO];
}

/**
 DEPRECATED as of PureLayout v2.0.0. Retain a reference to and remove specific constraints instead, or recreate the view(s) entirely to remove all constraints.
 Removes all constraints that affect the view, optionally including implicit constraints.
 WARNING: Apple's constraint solver is not optimized for large-scale constraint removal; you may encounter major performance issues after using this method.
 It is not recommended to use this method to "reset" a view for reuse in a different way with new constraints. Create a new view instead.
 NOTE: Implicit constraints are auto-generated lower priority constraints (such as those that attempt to keep a view at
 its intrinsic content size by hugging its content & resisting compression), and you usually do not want to remove these.
 
 @param shouldRemoveImplicitConstraints Whether implicit constraints should be removed or skipped.
 */
- (void)autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:(BOOL)shouldRemoveImplicitConstraints
{
    NSMutableArray *constraintsToRemove = [NSMutableArray new];
    ALView *startView = self;
    do {
        for (NSLayoutConstraint *constraint in startView.constraints) {
            BOOL isImplicitConstraint = [NSStringFromClass([constraint class]) isEqualToString:@"NSContentSizeLayoutConstraint"];
            if (shouldRemoveImplicitConstraints || !isImplicitConstraint) {
                if (constraint.firstItem == self || constraint.secondItem == self) {
                    [constraintsToRemove addObject:constraint];
                }
            }
        }
        startView = startView.superview;
    } while (startView);
    [constraintsToRemove autoRemoveConstraints];
}

/**
 DEPRECATED as of PureLayout v2.0.0. Retain a reference to and remove specific constraints instead, or recreate the view(s) entirely to remove all constraints.
 Recursively removes all explicit constraints that affect the view and its subviews.
 WARNING: Apple's constraint solver is not optimized for large-scale constraint removal; you may encounter major performance issues after using this method.
 It is not recommended to use this method to "reset" views for reuse in a different way with new constraints. Create a new view instead.
 NOTE: This method preserves implicit constraints, such as intrinsic content size constraints, which you usually do not want to remove.
 */
- (void)autoRemoveConstraintsAffectingViewAndSubviews
{
    [self autoRemoveConstraintsAffectingViewAndSubviewsIncludingImplicitConstraints:NO];
}

/**
 DEPRECATED as of PureLayout v2.0.0. Retain a reference to and remove specific constraints instead, or recreate the view(s) entirely to remove all constraints.
 Recursively removes all constraints that affect the view and its subviews, optionally including implicit constraints.
 WARNING: Apple's constraint solver is not optimized for large-scale constraint removal; you may encounter major performance issues after using this method.
 It is not recommended to use this method to "reset" views for reuse in a different way with new constraints. Create a new view instead.
 NOTE: Implicit constraints are auto-generated lower priority constraints (such as those that attempt to keep a view at
 its intrinsic content size by hugging its content & resisting compression), and you usually do not want to remove these.
 
 @param shouldRemoveImplicitConstraints Whether implicit constraints should be removed or skipped.
 */
- (void)autoRemoveConstraintsAffectingViewAndSubviewsIncludingImplicitConstraints:(BOOL)shouldRemoveImplicitConstraints
{
    [self autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:shouldRemoveImplicitConstraints];
    for (ALView *subview in self.subviews) {
        [subview autoRemoveConstraintsAffectingViewAndSubviewsIncludingImplicitConstraints:shouldRemoveImplicitConstraints];
    }
}


#pragma mark Internal Methods

/**
 Applies the global constraint priority and identifier to the given constraint.
 This should be done before installing all constraints.
 
 @param constraint The constraint to set the global priority and identifier on.
 */
+ (void)al_applyGlobalStateToConstraint:(NSLayoutConstraint *)constraint
{
    if ([ALView al_isExecutingPriorityConstraintsBlock]) {
        constraint.priority = [ALView al_currentGlobalConstraintPriority];
    }
#if __PureLayout_MinBaseSDK_iOS_8_0
    NSString *globalConstraintIdentifier = [ALView al_currentGlobalConstraintIdentifier];
    if (globalConstraintIdentifier) {
        [constraint autoIdentify:globalConstraintIdentifier];
    }
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
}

/**
 Adds the given constraint to this view after applying the global state to the constraint.
 NOTE: This method is compatible with all versions of iOS, and should be used for older versions before the active
 property on NSLayoutConstraint was introduced.
 
 This method should be the only one that calls the UIView/NSView addConstraint: method directly.
 
 @param constraint The constraint to set the global priority on and then add to this view.
 */
- (void)al_addConstraint:(NSLayoutConstraint *)constraint
{
    [ALView al_applyGlobalStateToConstraint:constraint];
    if ([ALView al_preventAutomaticConstraintInstallation]) {
        [[ALView al_currentArrayOfCreatedConstraints] addObject:constraint];
    } else {
        [self addConstraint:constraint];
    }
}

/**
 Returns the common superview for this view and the given other view.
 Raises an exception if this view and the other view do not share a common superview.
 
 @return The common superview for the two views.
 */
- (ALView *)al_commonSuperviewWithView:(ALView *)otherView
{
    ALView *commonSuperview = nil;
    ALView *startView = self;
    do {
#if TARGET_OS_IPHONE
        if ([otherView isDescendantOfView:startView]) {
            commonSuperview = startView;
        }
#else
        if ([otherView isDescendantOf:startView]) {
            commonSuperview = startView;
        }
#endif /* TARGET_OS_IPHONE */
        startView = startView.superview;
    } while (startView && !commonSuperview);
    NSAssert(commonSuperview, @"Can't constrain two views that do not share a common superview. Make sure that both views have been added into the same view hierarchy.");
    return commonSuperview;
}

/**
 Aligns this view to another view with an alignment attribute.
 
 @param attribute The attribute to use to align the two views.
 @param otherView The other view to align to.
 @param axis The axis along which the views are distributed, used to validate the alignment attribute.
 @return The constraint added.
 */
- (NSLayoutConstraint *)al_alignAttribute:(ALAttribute)attribute toView:(ALView *)otherView forAxis:(ALAxis)axis
{
    NSLayoutConstraint *constraint = nil;
    switch (attribute) {
        case ALAttributeVertical:
            NSAssert(axis == ALAxisVertical, @"Cannot align views that are distributed horizontally with ALAttributeVertical.");
            constraint = [self autoAlignAxis:ALAxisVertical toSameAxisOfView:otherView];
            break;
        case ALAttributeHorizontal:
            NSAssert(axis != ALAxisVertical, @"Cannot align views that are distributed vertically with ALAttributeHorizontal.");
            constraint = [self autoAlignAxis:ALAxisHorizontal toSameAxisOfView:otherView];
            break;
        case ALAttributeBaseline: // same value as ALAttributeLastBaseline
            NSAssert(axis != ALAxisVertical, @"Cannot align views that are distributed vertically with ALAttributeBaseline.");
            constraint = [self autoAlignAxis:ALAxisBaseline toSameAxisOfView:otherView];
            break;
#if __PureLayout_MinBaseSDK_iOS_8_0
        case ALAttributeFirstBaseline:
            NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"ALAttributeFirstBaseline is only supported on iOS 8.0 or higher.");
            NSAssert(axis != ALAxisVertical, @"Cannot align views that are distributed vertically with ALAttributeFirstBaseline.");
            constraint = [self autoAlignAxis:ALAxisFirstBaseline toSameAxisOfView:otherView];
            break;
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
        case ALAttributeTop:
            NSAssert(axis != ALAxisVertical, @"Cannot align views that are distributed vertically with ALAttributeTop.");
            constraint = [self autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:otherView];
            break;
        case ALAttributeLeft:
            NSAssert(axis == ALAxisVertical, @"Cannot align views that are distributed horizontally with ALAttributeLeft.");
            constraint = [self autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:otherView];
            break;
        case ALAttributeBottom:
            NSAssert(axis != ALAxisVertical, @"Cannot align views that are distributed vertically with ALAttributeBottom.");
            constraint = [self autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:otherView];
            break;
        case ALAttributeRight:
            NSAssert(axis == ALAxisVertical, @"Cannot align views that are distributed horizontally with ALAttributeRight.");
            constraint = [self autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:otherView];
            break;
        case ALAttributeLeading:
            NSAssert(axis == ALAxisVertical, @"Cannot align views that are distributed horizontally with ALAttributeLeading.");
            constraint = [self autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:otherView];
            break;
        case ALAttributeTrailing:
            NSAssert(axis == ALAxisVertical, @"Cannot align views that are distributed horizontally with ALAttributeTrailing.");
            constraint = [self autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:otherView];
            break;
        default:
            NSAssert(nil, @"Unsupported alignment option.");
            break;
    }
    return constraint;
}

@end
