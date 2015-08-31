//
//  PureLayoutPriorityTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutPriorityTests : PureLayoutTestBase

@end

@implementation PureLayoutPriorityTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

/**
 Returns an array of the default priorities to test.
 */
- (__NSArray_of(NSNumber *) *)defaultPriorities
{
    return @[@(ALLayoutPriorityFittingSizeLevel), @(ALLayoutPriorityDefaultHigh), @(ALLayoutPriorityRequired), @(ALLayoutPriorityDefaultLow)];
}

/**
 A helper method that takes a block containing a call to the PureLayout API which adds one constraint,
 and calls -[assertConstraint:isAddedWithPriority:] for each of the default priorities.
 */
- (void)assertConstraintIsAddedWithDefaultPriorities:(NSLayoutConstraint *(^)())block
{
    for (NSNumber *layoutPriority in [self defaultPriorities]) {
        [self assertConstraint:block isAddedWithPriority:[layoutPriority floatValue]];
    }
}

/**
 A helper method that takes a block containing one or more calls to the PureLayout API which add multiple
 constraints, and calls -[assertConstraints:areAddedWithPriority:] for each of the default priorities.
 */
- (void)assertConstraintsAreAddedWithDefaultPriorities:(NSArray *(^)())block
{
    for (NSNumber *layoutPriority in [self defaultPriorities]) {
        [self assertConstraints:block areAddedWithPriority:[layoutPriority floatValue]];
    }
}

/**
 A helper method that takes a block containing a call to the PureLayout API which adds one constraint,
 and verifies that when the +[NSLayoutConstraint autoSetPriority:forConstraints:] method is used, this one constraint is
 added with the correct priority specified.
 */
- (void)assertConstraint:(NSLayoutConstraint *(^)())block isAddedWithPriority:(ALLayoutPriority)priority
{
    [self assertConstraints:^__NSArray_of(NSLayoutConstraint *) *{ return @[block()]; } areAddedWithPriority:priority];
}

/**
 A helper method that takes a block containing one or more calls to the PureLayout API which add multiple
 constraints, and verifies that when the +[NSLayoutConstraint autoSetPriority:forConstraints:] method is used,
 these constraints are added with the correct priority specified.
 */
- (void)assertConstraints:(__NSArray_of(NSLayoutConstraint *) *(^)())block areAddedWithPriority:(ALLayoutPriority)priority
{
    __block __NSArray_of(NSLayoutConstraint *) *constraints;
    [NSLayoutConstraint autoSetPriority:priority forConstraints:^{
        constraints = block();
    }];
    XCTAssert([constraints count] > 0, @"The array of constraints should not be empty.");
    for (NSLayoutConstraint *constraint in constraints) {
        XCTAssert(constraint.priority == priority, @"The constraint priority should be equal to the one specified for the constraints block.");
    }
}

/**
 Test setting the priority of constraints that center views to their superview.
 */
- (void)testPriorityForCentering
{
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewA autoCenterInSuperview];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewB autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewC autoAlignAxisToSuperviewAxis:ALAxisBaseline];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewC autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }];
}

/**
 Test setting the priority of constraints that pin edges of views to their superview.
 */
- (void)testPriorityForPinningEdgesToSuperview
{
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewA autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewB autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0 relation:NSLayoutRelationGreaterThanOrEqual];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewC autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewD autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(5.5, -50.0, 42.6, 860.9) excludingEdge:ALEdgeTrailing];
    }];
}

/**
 Test setting the priority of constraints that pin edges of views.
 */
- (void)testPriorityForPinningEdges
{
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewA autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.viewB];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewB autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.viewC withOffset:-95.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewC autoPinEdge:ALEdgeRight toEdge:ALEdgeBottom ofView:self.viewD withOffset:555.0];
    }];
}

/**
 Test setting the priority of constraints that align axes of views.
 */
- (void)testPriorityForAligningAxes
{
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewA autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.viewB];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewC autoAlignAxis:ALAxisVertical toSameAxisOfView:self.viewD];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewB autoAlignAxis:ALAxisBaseline toSameAxisOfView:self.viewA withOffset:-60.0];
    }];
}

/**
 Test setting the priority of constraints that match dimensions of views.
 */
- (void)testPriorityForMatchingDimensions
{
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewA autoSetDimensionsToSize:CGSizeMake(90, 180)];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewB autoSetDimension:ALDimensionHeight toSize:0.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewC autoSetDimension:ALDimensionWidth toSize:5.0 relation:NSLayoutRelationLessThanOrEqual];
    }];
}

/**
 Test setting the priority of constraints that constrain any attribute of views.
 */
- (void)testPriorityForConstrainingAnyAttribute
{
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewA autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeBottom ofView:self.viewB];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewA autoConstrainAttribute:ALAttributeRight toAttribute:ALAttributeHorizontal ofView:self.viewC withOffset:50.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewA autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeHeight ofView:self.viewD withOffset:-100.0 relation:NSLayoutRelationLessThanOrEqual];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewD autoConstrainAttribute:ALAttributeBaseline toAttribute:ALAttributeTrailing ofView:self.viewA withMultiplier:-6.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [self.viewB autoConstrainAttribute:ALAttributeTop toAttribute:ALAttributeLeading ofView:self.viewA withMultiplier:0.45 relation:NSLayoutRelationGreaterThanOrEqual];
    }];
}

/**
 Test setting the priority of constraints that constrain an array of views.
 */
- (void)testPriorityForConstrainingMultipleViews
{
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoAlignViewsToEdge:ALEdgeBottom];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoAlignViewsToAxis:ALAxisVertical];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoMatchViewsDimension:ALDimensionWidth];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoSetViewsDimension:ALDimensionHeight toSize:10.0];
    }];
}

/**
 Test setting the priority of constraints that distribute an array of views.
 */
- (void)testPriorityForDistributingMultipleViews
{
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeBottom withFixedSize:25.0];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeRight withFixedSize:5.0 insetSpacing:NO];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeading withFixedSpacing:0.0];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^__NSArray_of(NSLayoutConstraint *) *{
        return [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:899.5 insetSpacing:NO];
    }];
}

/**
 Test that nested priority blocks work correctly.
 */
- (void)testNestingPriorityConstraintBlocks
{
    NSLayoutConstraint *constraint0 = [self.viewD autoAlignAxisToSuperviewAxis:ALAxisVertical];
    XCTAssertEqual(constraint0.priority, ALLayoutPriorityRequired);
    [NSLayoutConstraint autoSetPriority:ALLayoutPriorityDefaultLow forConstraints:^{
        NSLayoutConstraint *constraint1 = [self.viewA autoAlignAxisToSuperviewAxis:ALAxisVertical];
        XCTAssertEqual(constraint1.priority, ALLayoutPriorityDefaultLow);
        [NSLayoutConstraint autoSetPriority:ALLayoutPriorityDefaultHigh forConstraints:^{
            NSLayoutConstraint *constraint2 = [self.viewB autoAlignAxisToSuperviewAxis:ALAxisVertical];
            XCTAssertEqual(constraint2.priority, ALLayoutPriorityDefaultHigh);
        }];
        NSLayoutConstraint *constraint3 = [self.viewC autoAlignAxisToSuperviewAxis:ALAxisVertical];
        XCTAssertEqual(constraint3.priority, ALLayoutPriorityDefaultLow);
    }];
    NSLayoutConstraint *constraint4 = [self.viewD autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    XCTAssertEqual(constraint4.priority, ALLayoutPriorityRequired);
}

/**
 Test that constraint priorities are not impacted unless inside of a priority constraints block.
 */
- (void)testInstallingConstraintsOutsidePriorityBlock
{
    __block NSLayoutConstraint *constraint;
    [NSLayoutConstraint autoCreateConstraintsWithoutInstalling:^{
        constraint = [self.viewD autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }];
    XCTAssertEqual(constraint.priority, ALLayoutPriorityRequired);
    constraint.priority = ALLayoutPriorityDefaultLow;
    XCTAssertEqual(constraint.priority, ALLayoutPriorityDefaultLow);
    
    // Install the constraint and check that its priority was not affected
    [constraint autoInstall];
    XCTAssertEqual(constraint.priority, ALLayoutPriorityDefaultLow);
    
    // Remove the constraint, then re-add it but this time inside of a constraints block
    [constraint autoRemove];
    XCTAssertEqual(constraint.priority, ALLayoutPriorityDefaultLow);
    [NSLayoutConstraint autoSetPriority:ALLayoutPriorityDefaultHigh forConstraints:^{
        [constraint autoInstall];
        XCTAssertEqual(constraint.priority, ALLayoutPriorityDefaultHigh);
    }];
}

@end
