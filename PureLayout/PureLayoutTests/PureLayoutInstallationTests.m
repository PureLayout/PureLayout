//
//  PureLayoutInstallationTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutInstallationTests : PureLayoutTestBase

@end

@implementation PureLayoutInstallationTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

/**
 Test the -[autoInstall] method on NSLayoutConstraint with two nil items.
 */
- (void)testInstallNilItems
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint new];
    XCTAssertNil(constraint.firstItem);
    XCTAssertNil(constraint.secondItem);
    
    XCTAssertThrows([constraint autoInstall], @"autoInstall should throw an exception that both items are nil.");
}

/**
 Test the -[autoInstall] method on NSLayoutConstraint with two views as items.
 */
- (void)testInstallTwoItems
{
    NSUInteger startingConstraintsCount = [self.containerView.constraints count];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.viewA attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.viewB attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    
    XCTAssert([self.containerView.constraints count] == startingConstraintsCount, @"containerView should have no new constraints added to it yet.");
    
    [constraint autoInstall];
    
    NSUInteger newConstraintsCount = [self.containerView.constraints count];
    XCTAssert(newConstraintsCount == startingConstraintsCount + 1, @"containerView should have one new constraint added to it.");
}

/**
 Test the -[autoInstall] method on NSLayoutConstraint with one view in firstItem.
 */
- (void)testInstallFirstItem
{
    NSUInteger startingConstraintsCount = [self.viewC.constraints count];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.viewC attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10.0];
    
    XCTAssert([self.containerView.constraints count] == startingConstraintsCount, @"viewC should have no new constraints added to it yet.");
    
    [constraint autoInstall];
    
    NSUInteger newConstraintsCount = [self.viewC.constraints count];
    XCTAssert(newConstraintsCount == startingConstraintsCount + 1, @"viewC should have one new constraint added to it.");
}

@end
