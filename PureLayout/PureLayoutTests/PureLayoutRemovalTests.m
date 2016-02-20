//
//  PureLayoutRemovalTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutRemovalTests : PureLayoutTestBase

@end

@implementation PureLayoutRemovalTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

/**
 Test the +[removeConstraint:] method on UIView.
 Test the case where we're removing a constraint that was added to the closest common superview of the two views it
 constrains.
 */
- (void)testRemoveConstraint
{
    [self.viewA autoCenterInSuperview];
    
    NSUInteger constraintsCount = [self.viewA.superview.constraints count];
    XCTAssert(constraintsCount > 0, @"viewA's superview should have constraints added to it.");
    
    [self.viewA.superview.constraints[0] autoRemove];
    NSUInteger newConstraintsCount = [self.viewA.superview.constraints count];
    XCTAssert(constraintsCount - newConstraintsCount == 1, @"viewA's superview should have one less constraint on it.");
}

/**
 Test the -[autoRemove] method on NSLayoutConstraint.
 Test the case where we're removing a constraint that only applies to one view.
 */
- (void)testRemoveConstraintFromSingleView
{
    NSLayoutConstraint *constraint = [self.viewA autoSetDimension:ALDimensionWidth toSize:10.0];
    
    NSUInteger constraintsCount = [self.viewA.constraints count];
    XCTAssert(constraintsCount > 0, @"viewA should have a constraint added to it.");
    
    [constraint autoRemove];
    NSUInteger newConstraintsCount = [self.viewA.constraints count];
    XCTAssert(constraintsCount - newConstraintsCount == 1, @"viewA should have one less constraint on it.");
}

/**
 Test the -[autoRemove] method on NSLayoutConstraint.
 Test the case where we're removing a constraint that was added to a view that is not the closest common superview of
 the two views it constrains.
 */
- (void)testRemoveConstraintFromNotImmediateSuperview
{
    [self.viewC removeFromSuperview];
    [self.viewB removeFromSuperview];
    [self.viewA addSubview:self.viewB];
    [self.viewB addSubview:self.viewC];
    
    NSLayoutConstraint *constraint = [self.viewC autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.viewB removeConstraint:constraint];
    [self.containerView addConstraint:constraint];
    
    NSUInteger constraintsCount = [self.containerView.constraints count];
    XCTAssert(constraintsCount > 0, @"containerView should have a constraint added to it.");
    
    [constraint autoRemove];
    NSUInteger newConstraintsCount = [self.containerView.constraints count];
    XCTAssert(constraintsCount - newConstraintsCount == 1, @"containerView should have one less constraint on it.");
}

/**
 Test the -[autoRemoveConstraints] method on NSArray.
 */
- (void)testRemoveConstraints
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = [@[self.viewA, self.viewB, self.viewC, self.viewD] autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSize:10.0];
    
    NSUInteger constraintsCount = [self.containerView.constraints count];
    XCTAssert(constraintsCount > 0, @"containerView should have constraints added to it.");
    
    [constraints autoRemoveConstraints];
    NSUInteger newConstraintsCount = [self.containerView.constraints count];
    XCTAssert(newConstraintsCount == 0, @"containerView should have no constraints on it.");
}

/**
 Test the -[autoRemove] method on NSLayoutConstraint.
 */
- (void)testRemove
{
    NSLayoutConstraint *constraint = [self.containerView autoSetDimension:ALDimensionHeight toSize:0.0];
    
    NSUInteger constraintsCount = [self.containerView.constraints count];
    XCTAssert(constraintsCount > 0, @"containerView should have a constraint added to it.");
    
    [constraint autoRemove];
    NSUInteger newConstraintsCount = [self.containerView.constraints count];
    XCTAssert(constraintsCount - newConstraintsCount == 1, @"containerView should have one less constraint on it.");
}

@end
