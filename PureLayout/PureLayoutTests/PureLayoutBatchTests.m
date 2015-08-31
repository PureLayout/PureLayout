//
//  PureLayoutBatchTests.m
//  PureLayout Tests
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutBatchTests : PureLayoutTestBase

@end

@implementation PureLayoutBatchTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

/** Returns YES if the constraint is active. */
- (BOOL)isConstraintActive:(NSLayoutConstraint *)constraint
{
#if __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10
    if ([constraint respondsToSelector:@selector(isActive)]) {
        return constraint.isActive;
    }
#endif
    
    // Same as the `isActive` property, but backwards-compatible with iOS and OS X versions before that property was introduced.
    if (constraint.secondItem) {
        ALView *commonSuperview = [constraint.firstItem al_commonSuperviewWithView:constraint.secondItem];
        while (commonSuperview) {
            if ([commonSuperview.constraints containsObject:constraint]) {
                return YES;
            }
            commonSuperview = commonSuperview.superview;
        }
    }
    else {
        if ([((ALView *)constraint.firstItem).constraints containsObject:constraint]) {
            return YES;
        }
    }
    return NO;
}

/** Returns YES if all the constraints in the array are active. */
- (BOOL)allConstraintsAreActivated:(__NSArray_of(NSLayoutConstraint *) *)constraints
{
    BOOL allConstraintsActivated = YES;
    for (NSLayoutConstraint *constraint in constraints) {
        allConstraintsActivated &= [self isConstraintActive:constraint];
    }
    return allConstraintsActivated;
}

/** Returns YES if none of the constraints in the array are active. */
- (BOOL)noConstraintsAreActivated:(__NSArray_of(NSLayoutConstraint *) *)constraints
{
    BOOL anyConstraintActivated = NO;
    for (NSLayoutConstraint *constraint in constraints) {
        anyConstraintActivated |= [self isConstraintActive:constraint];
    }
    return !anyConstraintActivated;
}

/**
 Test the +[NSLayoutConstraint autoCreateAndInstallConstraints:] method.
 */
- (void)testCreateAndInstallConstraints
{
    __NSMutableArray_of(NSLayoutConstraint *) *createdConstraints = [NSMutableArray array];
    __NSArray_of(NSLayoutConstraint *) *returnedConstraints = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [createdConstraints addObjectsFromArray:[self.viewA autoPinEdgesToSuperviewEdges]];
        [createdConstraints addObject:[self.viewA_A autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.viewA_A.superview]];
        [createdConstraints addObject:[self.viewA_A autoAlignAxis:ALAxisVertical toSameAxisOfView:self.viewA_A.superview withOffset:10.0]];
        [createdConstraints addObjectsFromArray:[self.viewA_A autoSetDimensionsToSize:CGSizeMake(50.0, 50.0)]];
        [createdConstraints addObjectsFromArray:[self.viewA_B autoCenterInSuperview]];
        [createdConstraints addObject:[self.viewA_B autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.viewA_A]];
        [createdConstraints addObject:[self.viewB autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeVertical ofView:self.viewA]];
    }];
    XCTAssertEqualObjects(createdConstraints, returnedConstraints, @"The array returned by +[autoCreateAndInstallConstraints:] should contain every constraint created.");
    XCTAssert([self allConstraintsAreActivated:returnedConstraints], @"All constraints created inside of +[autoCreateAndInstallConstraints:] should be activated.");
}

/**
 Test nested calls to the +[NSLayoutConstraint autoCreateAndInstallConstraints:] method.
    - Constraints should be returned ONLY by the call that provided the immediate enclosing block.
        - Calls whose block contains other call(s) should not return constraints from within the blocks of nested call(s).
    - Constraints should be active when they are returned.
 */
- (void)testCreateAndInstallConstraintsNested
{
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_1 = nil;
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_1_1 = nil;
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_2 = nil;
    
    __NSArray_of(NSLayoutConstraint *) *returnedConstraints1 = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        returnedConstraints1_1 = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [self.viewB autoSetDimension:ALDimensionWidth toSize:100.0];
            [self.viewC autoSetDimension:ALDimensionHeight toSize:100.0];
            
            returnedConstraints1_1_1 = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
                [self.viewD autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeWidth ofView:self.viewC withMultiplier:2.0];
            }];
            XCTAssertEqual(returnedConstraints1_1_1.count, 1);
            XCTAssert([self allConstraintsAreActivated:returnedConstraints1_1_1]);
            
            [self.viewB autoSetDimension:ALDimensionHeight toSize:100.0];
            [self.viewC autoSetDimension:ALDimensionWidth toSize:100.0];
        }];
        XCTAssertEqual(returnedConstraints1_1.count, 4);
        XCTAssert([self allConstraintsAreActivated:returnedConstraints1_1]);

        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        
        returnedConstraints1_2 = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.viewA autoAlignAxisToSuperviewAxis:ALAxisVertical];
        }];
        XCTAssertEqual(returnedConstraints1_2.count, 2);
        XCTAssert([self allConstraintsAreActivated:returnedConstraints1_2]);
        
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    }];
    XCTAssertEqual(returnedConstraints1.count, 3);
    XCTAssert([self allConstraintsAreActivated:returnedConstraints1]);
    XCTAssertEqual(returnedConstraints1_1.count, 4);
    XCTAssert([self allConstraintsAreActivated:returnedConstraints1_1]);
    XCTAssertEqual(returnedConstraints1_1_1.count, 1);
    XCTAssert([self allConstraintsAreActivated:returnedConstraints1_1_1]);
    XCTAssertEqual(returnedConstraints1_2.count, 2);
    XCTAssert([self allConstraintsAreActivated:returnedConstraints1_2]);
}

/**
 Test the +[NSLayoutConstraint autoCreateConstraintsWithoutInstalling:] method.
 */
- (void)testCreateConstraintsWithoutInstalling
{
    __NSMutableArray_of(NSLayoutConstraint *) *createdConstraints = [NSMutableArray array];
    __NSArray_of(NSLayoutConstraint *) *returnedConstraints = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [createdConstraints addObjectsFromArray:[self.viewA autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) excludingEdge:ALEdgeBottom]];
        [createdConstraints addObject:[self.viewA_A autoAlignAxis:ALAxisVertical toSameAxisOfView:self.viewA_A.superview]];
        [createdConstraints addObject:[self.viewA_A autoAlignAxis:ALAxisBaseline toSameAxisOfView:self.viewA_A.superview withOffset:-10.0]];
        [createdConstraints addObjectsFromArray:[self.viewA_A autoSetDimensionsToSize:CGSizeMake(20.0, 80.0)]];
        [createdConstraints addObjectsFromArray:[self.viewA_B autoCenterInSuperview]];
        [createdConstraints addObject:[self.viewA_B autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.viewA_A]];
        [createdConstraints addObject:[self.viewB autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeTop ofView:self.viewA]];
    }];
    XCTAssertEqualObjects(createdConstraints, returnedConstraints, @"The array returned by +[autoCreateAndInstallConstraints:] should contain every constraint created.");
    XCTAssert([self noConstraintsAreActivated:returnedConstraints], @"All constraints created inside of +[autoCreateAndInstallConstraints:] should not be activated.");
}

/**
 Test nested calls to the +[NSLayoutConstraint autoCreateConstraintsWithoutInstalling:] method.
    - Constraints should be returned ONLY by the call that provided the immediate enclosing block.
        - Calls whose block contains other call(s) should not return constraints from within the blocks of nested call(s).
    - Constraints should never be active.
 */
- (void)testCreateConstraintsWithoutInstallingNested
{
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_1 = nil;
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_1_1 = nil;
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_2 = nil;
    
    __NSArray_of(NSLayoutConstraint *) *returnedConstraints1 = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        returnedConstraints1_1 = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
            [self.viewB autoSetDimension:ALDimensionWidth toSize:100.0];
            [self.viewC autoSetDimension:ALDimensionHeight toSize:100.0];
            
            returnedConstraints1_1_1 = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
                [self.viewD autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeWidth ofView:self.viewC withMultiplier:2.0];
            }];
            XCTAssertEqual(returnedConstraints1_1_1.count, 1);
            XCTAssert([self noConstraintsAreActivated:returnedConstraints1_1_1]);
            
            [self.viewB autoSetDimension:ALDimensionHeight toSize:100.0];
            [self.viewC autoSetDimension:ALDimensionWidth toSize:100.0];
        }];
        XCTAssertEqual(returnedConstraints1_1.count, 4);
        XCTAssert([self noConstraintsAreActivated:returnedConstraints1_1]);
        
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        
        returnedConstraints1_2 = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
            [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.viewA autoAlignAxisToSuperviewAxis:ALAxisVertical];
        }];
        XCTAssertEqual(returnedConstraints1_2.count, 2);
        XCTAssert([self noConstraintsAreActivated:returnedConstraints1_2]);
        
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    }];
    XCTAssertEqual(returnedConstraints1.count, 3);
    XCTAssert([self noConstraintsAreActivated:returnedConstraints1]);
    XCTAssertEqual(returnedConstraints1_1.count, 4);
    XCTAssert([self noConstraintsAreActivated:returnedConstraints1_1]);
    XCTAssertEqual(returnedConstraints1_1_1.count, 1);
    XCTAssert([self noConstraintsAreActivated:returnedConstraints1_1_1]);
    XCTAssertEqual(returnedConstraints1_2.count, 2);
    XCTAssert([self noConstraintsAreActivated:returnedConstraints1_2]);
}

/**
 Test nested calls to both +[NSLayoutConstraint autoCreateAndInstallConstraints:] and +[NSLayoutConstraint autoCreateConstraintsWithoutInstalling:] methods.
 */
- (void)testBothBatchCreateMethodsNested
{
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_1 = nil;
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_1_1 = nil;
    __block __NSArray_of(NSLayoutConstraint *) *returnedConstraints1_2 = nil;
    
    __NSArray_of(NSLayoutConstraint *) *returnedConstraints1 = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        returnedConstraints1_1 = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [self.viewB autoSetDimension:ALDimensionWidth toSize:100.0];
            [self.viewC autoSetDimension:ALDimensionHeight toSize:100.0];
            
            returnedConstraints1_1_1 = [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
                [self.viewD autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeWidth ofView:self.viewC withMultiplier:2.0];
            }];
            XCTAssertEqual(returnedConstraints1_1_1.count, 1);
            XCTAssert([self noConstraintsAreActivated:returnedConstraints1_1_1]);
            
            [self.viewB autoSetDimension:ALDimensionHeight toSize:100.0];
            [self.viewC autoSetDimension:ALDimensionWidth toSize:100.0];
        }];
        XCTAssertEqual(returnedConstraints1_1.count, 4);
        XCTAssert([self allConstraintsAreActivated:returnedConstraints1_1]);
        
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        
        returnedConstraints1_2 = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.viewA autoAlignAxisToSuperviewAxis:ALAxisVertical];
        }];
        XCTAssertEqual(returnedConstraints1_2.count, 2);
        XCTAssert([self allConstraintsAreActivated:returnedConstraints1_2]);
        
        [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    }];
    XCTAssertEqual(returnedConstraints1.count, 3);
    XCTAssert([self noConstraintsAreActivated:returnedConstraints1]);
    XCTAssertEqual(returnedConstraints1_1.count, 4);
    XCTAssert([self allConstraintsAreActivated:returnedConstraints1_1]);
    XCTAssertEqual(returnedConstraints1_1_1.count, 1);
    XCTAssert([self noConstraintsAreActivated:returnedConstraints1_1_1]);
    XCTAssertEqual(returnedConstraints1_2.count, 2);
    XCTAssert([self allConstraintsAreActivated:returnedConstraints1_2]);
}

@end
