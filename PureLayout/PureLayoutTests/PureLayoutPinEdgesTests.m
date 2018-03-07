//
//  PureLayoutPinEdgesTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutPinEdgesTests : PureLayoutTestBase

@end

@implementation PureLayoutPinEdgesTests

- (void)testAutoPinEdgeToSuperviewEdge
{
    [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0];
    [self evaluateConstraints];
    ALAssertOriginEquals(self.viewA, 5.0, VALUES(10.0, 990.0));
    
    [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
    [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-10.0];
    [self evaluateConstraints];
    ALAssertFrameEquals(self.viewA, 5.0, VALUES(10.0, -10.0), kContainerViewWidth - 5.0, kContainerViewHeight);
    
    [self.viewB autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0.0];
    [self.viewB autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-52.0];
    [self evaluateConstraints];
    ALAssertMaxEquals(self.viewB, kContainerViewWidth, VALUES(kContainerViewHeight + 52.0, -52.0));
    
    [self.viewB autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:500.0];
    [self evaluateConstraints];
    ALAssertOriginXEquals(self.viewB, 500.0);
    
    [self.viewB autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
    [self evaluateConstraints];
    ALAssertFrameEquals(self.viewB, 500.0, VALUES(0.0, -52.0), kContainerViewWidth - 500.0, kContainerViewHeight + 52.0);
}

-(void)testAutoPinEdgesReturnsConstraintsCounterclockwiseFromTop
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = [self.viewA autoPinEdgesToSuperviewEdges];

    XCTAssertEqual([[constraints objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[constraints objectAtIndex:1] firstAttribute], NSLayoutAttributeLeading);
    XCTAssertEqual([[constraints objectAtIndex:2] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[constraints objectAtIndex:3] firstAttribute], NSLayoutAttributeTrailing);
}

-(void)testAutoPinEdgesExcludingEdgeRetainsRelativeConstraintOrdering
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = [self.viewA autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeLeading];

    XCTAssertEqual([[constraints objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[constraints objectAtIndex:1] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[constraints objectAtIndex:2] firstAttribute], NSLayoutAttributeTrailing);
}

-(void)testAutoPinEdgesExcludingLeftEdgeDoesNotUseTrailing
{
    PL__NSArray_of(NSLayoutConstraint *) *excludingLeft = [self.viewA autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeLeft];
    
    XCTAssertEqual([[excludingLeft objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingLeft objectAtIndex:1] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[excludingLeft objectAtIndex:2] firstAttribute], NSLayoutAttributeRight);
    
    PL__NSArray_of(NSLayoutConstraint *) *excludingLeading = [self.viewA autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeLeading];
    
    XCTAssertEqual([[excludingLeading objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingLeading objectAtIndex:1] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[excludingLeading objectAtIndex:2] firstAttribute], NSLayoutAttributeTrailing);
}

-(void)testAutoPinEdgesExcludingRightEdgeDoesNotUseLeading
{
    PL__NSArray_of(NSLayoutConstraint *) *excludingRight = [self.viewA autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeRight];
    
    XCTAssertEqual([[excludingRight objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingRight objectAtIndex:1] firstAttribute], NSLayoutAttributeLeft);
    XCTAssertEqual([[excludingRight objectAtIndex:2] firstAttribute], NSLayoutAttributeBottom);
    
    PL__NSArray_of(NSLayoutConstraint *) *excludingTrailing = [self.viewA autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeTrailing];
    
    XCTAssertEqual([[excludingTrailing objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingTrailing objectAtIndex:1] firstAttribute], NSLayoutAttributeLeading);
    XCTAssertEqual([[excludingTrailing objectAtIndex:2] firstAttribute], NSLayoutAttributeBottom);
}

#if PL__PureLayout_MinBaseSDK_iOS_8_0

-(void)testAutoPinEdgesSuperViewMarginsReturnsConstraintsCounterclockwiseFromTop
{
    PL__NSArray_of(NSLayoutConstraint *)*constraints = [self.viewA autoPinEdgesToSuperviewMarginsWithInsets:(ALEdgeInsetsZero)];
    
    XCTAssertEqual([[constraints objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[constraints objectAtIndex:1] firstAttribute], NSLayoutAttributeLeading);
    XCTAssertEqual([[constraints objectAtIndex:2] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[constraints objectAtIndex:3] firstAttribute], NSLayoutAttributeTrailing);
}

-(void)testAutoPinEdgesToSuperviewMarginsExcludingEdgeRetainsRelativeConstraintOrdering
{
    PL__NSArray_of(NSLayoutConstraint *)*constraints = [self.viewA autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeLeading];
    
    XCTAssertEqual([[constraints objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[constraints objectAtIndex:1] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[constraints objectAtIndex:2] firstAttribute], NSLayoutAttributeTrailing);
}

-(void)testAutoPinMarginsExcludingLeftEdgeDoesNotUseTrailing
{
    PL__NSArray_of(NSLayoutConstraint *) *excludingLeft = [self.viewA autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeLeft];
    
    XCTAssertEqual([[excludingLeft objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingLeft objectAtIndex:1] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[excludingLeft objectAtIndex:2] firstAttribute], NSLayoutAttributeRight);
    
    PL__NSArray_of(NSLayoutConstraint *) *excludingLeading = [self.viewA autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeLeading];
    
    XCTAssertEqual([[excludingLeading objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingLeading objectAtIndex:1] firstAttribute], NSLayoutAttributeBottom);
    XCTAssertEqual([[excludingLeading objectAtIndex:2] firstAttribute], NSLayoutAttributeTrailing);
}

-(void)testAutoPinMarginsExcludingRightEdgeDoesNotUseLeading
{
    PL__NSArray_of(NSLayoutConstraint *) *excludingRight = [self.viewA autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeRight];
    
    XCTAssertEqual([[excludingRight objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingRight objectAtIndex:1] firstAttribute], NSLayoutAttributeLeft);
    XCTAssertEqual([[excludingRight objectAtIndex:2] firstAttribute], NSLayoutAttributeBottom);
    
    PL__NSArray_of(NSLayoutConstraint *) *excludingTrailing = [self.viewA autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeTrailing];
    
    XCTAssertEqual([[excludingTrailing objectAtIndex:0] firstAttribute], NSLayoutAttributeTop);
    XCTAssertEqual([[excludingTrailing objectAtIndex:1] firstAttribute], NSLayoutAttributeLeading);
    XCTAssertEqual([[excludingTrailing objectAtIndex:2] firstAttribute], NSLayoutAttributeBottom);
}

#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */

@end
