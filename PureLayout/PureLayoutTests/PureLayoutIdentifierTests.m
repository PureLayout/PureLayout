//
//  PureLayoutIdentifierTests.m
//  PureLayout Tests
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutIdentifierTests : PureLayoutTestBase

@end

@implementation PureLayoutIdentifierTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

/** Test the -[autoIdentify:] method on NSLayoutConstraint. */
- (void)testIdentify
{
    NSLayoutConstraint *c1 = [[self.viewA autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.viewB] autoIdentify:@"Identify1"];
    XCTAssertEqualObjects(c1.identifier, @"Identify1");
    
    NSLayoutConstraint *c2 = [self.viewD autoSetDimension:ALDimensionHeight toSize:25.0];
    [c2 autoIdentify:@"Identify2"];
    XCTAssertEqualObjects(c2.identifier, @"Identify2");
}

/** Test the -[autoIdentifyConstraints:] method on NSArray. */
- (void)testIdentifyConstraints
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = [[self.viewC autoCenterInSuperview] autoIdentifyConstraints:@"IdentifyConstraints1"];
    for (NSLayoutConstraint *constraint in constraints) {
        XCTAssertEqualObjects(constraint.identifier, @"IdentifyConstraints1");
    }
    
    constraints = [@[self.viewA_A_A, self.viewA_A_B] autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSize:10.0];
    [constraints autoIdentifyConstraints:@"IdentifyConstraints2"];
    for (NSLayoutConstraint *constraint in constraints) {
        XCTAssertEqualObjects(constraint.identifier, @"IdentifyConstraints2");
    }
}

/** Test setting identifiers within a block that prevents automatic constraint installation. */
- (void)testIdentifyConstraintsCreatedWithoutInstalling
{
    __block NSLayoutConstraint *c1, *c2, *c3;
    __block PL__NSArray_of(NSLayoutConstraint *) *c4s;
    PL__NSArray_of(NSLayoutConstraint *) *constraints = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        c1 = [self.viewA autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.viewB];
        c2 = [[self.viewC autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.viewD] autoIdentify:@"Identifier1"];
        [NSLayoutConstraint autoSetIdentifier:@"Identifier2" forConstraints:^{
           c3 = [self.viewA_B autoPinEdgeToSuperviewEdge:ALEdgeBottom];
           c4s = [self.viewA_A autoPinEdgesToSuperviewEdges];
        }];
        XCTAssertNil(c1.identifier);
        XCTAssertEqualObjects(c2.identifier, @"Identifier1");
        XCTAssertEqualObjects(c3.identifier, @"Identifier2");
        for (NSLayoutConstraint *constraint in c4s) {
            XCTAssertEqualObjects(constraint.identifier, @"Identifier2");
        }
    }];
    XCTAssertNil(c1.identifier);
    XCTAssertEqualObjects(c2.identifier, @"Identifier1");
    XCTAssertEqualObjects(c3.identifier, @"Identifier2");
    for (NSLayoutConstraint *constraint in c4s) {
        XCTAssertEqualObjects(constraint.identifier, @"Identifier2");
    }
    [constraints autoInstallConstraints];
    XCTAssertNil(c1.identifier);
    XCTAssertEqualObjects(c2.identifier, @"Identifier1");
    XCTAssertEqualObjects(c3.identifier, @"Identifier2");
    for (NSLayoutConstraint *constraint in c4s) {
        XCTAssertEqualObjects(constraint.identifier, @"Identifier2");
    }
}

/** Test the +[NSLayoutConstraint autoSetIdentifier:forConstraints:] method. */
- (void)testSetIdentifierForConstraints
{
    __block NSLayoutConstraint *c1;
    __block PL__NSArray_of(NSLayoutConstraint *) *c2s;
    [NSLayoutConstraint autoSetIdentifier:@"Identifier1" forConstraints:^{
        c1 = [self.viewA_A_A autoSetDimension:ALDimensionHeight toSize:50.0];
        c2s = [@[self.viewA, self.viewB, self.viewC] autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSpacing:15.0];
    }];
    XCTAssertEqualObjects(c1.identifier, @"Identifier1");
    for (NSLayoutConstraint *constraint in c2s) {
        XCTAssertEqualObjects(constraint.identifier, @"Identifier1");
    }
}

/** Test nested calls to the +[NSLayoutConstraint autoSetIdentifier:forConstraints:] method. */
- (void)testSetIdentifierForConstraintsNested
{
    __block NSLayoutConstraint *c1, *c2, *c3;
    [NSLayoutConstraint autoSetIdentifier:@"IdentifierA" forConstraints:^{
        c1 = [self.viewA_A_A autoSetDimension:ALDimensionHeight toSize:50.0];
        
        [NSLayoutConstraint autoSetIdentifier:@"IdentifierB" forConstraints:^{
            c2 = [self.viewA_A_A autoSetDimension:ALDimensionHeight toSize:50.0];
        }];
        XCTAssertEqualObjects(c2.identifier, @"IdentifierB");
        
        c3 = [self.viewA_A_A autoSetDimension:ALDimensionHeight toSize:50.0];
    }];
    XCTAssertEqualObjects(c1.identifier, @"IdentifierA");
    XCTAssertEqualObjects(c2.identifier, @"IdentifierB");
    XCTAssertEqualObjects(c3.identifier, @"IdentifierA");
}

@end
