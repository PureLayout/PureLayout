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

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

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

@end
