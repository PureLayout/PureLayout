//
//  PureLayoutPriorityTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014 Tyler Fox
//  https://github.com/smileyborg/PureLayout
//

#import "PureLayoutTestBase.h"

#define DEFINE_WEAK_SELF    __typeof(self) __weak weakSelf = self;

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
- (NSArray *)defaultPriorities
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
 and verifies that when the +[UIView autoSetPriority:forConstraints:] method is used, this one constraint is
 added with the correct priority specified.
 */
- (void)assertConstraint:(NSLayoutConstraint *(^)())block isAddedWithPriority:(ALLayoutPriority)priority
{
    [self assertConstraints:^NSArray *{ return @[block()]; } areAddedWithPriority:priority];
}

/**
 A helper method that takes a block containing one or more calls to the PureLayout API which add multiple
 constraints, and verifies that when the +[UIView autoSetPriority:forConstraints:] method is used, these 
 constraints are added with the correct priority specified.
 */
- (void)assertConstraints:(NSArray *(^)())block areAddedWithPriority:(ALLayoutPriority)priority
{
    __block NSArray *constraints;
    [ALView autoSetPriority:priority forConstraints:^{
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
    DEFINE_WEAK_SELF
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewA autoCenterInSuperview];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewB autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewC autoAlignAxisToSuperviewAxis:ALAxisBaseline];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewC autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }];
}

/**
 Test setting the priority of constraints that pin edges of views to their superview.
 */
- (void)testPriorityForPinningEdgesToSuperview
{
    DEFINE_WEAK_SELF
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewA autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewB autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0 relation:NSLayoutRelationGreaterThanOrEqual];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewC autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewD autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(5.5, -50.0, 42.6, 860.9) excludingEdge:ALEdgeTrailing];
    }];
}

/**
 Test setting the priority of constraints that pin edges of views.
 */
- (void)testPriorityForPinningEdges
{
    DEFINE_WEAK_SELF
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewA autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:weakSelf.viewB];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewB autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:weakSelf.viewC withOffset:-95.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewC autoPinEdge:ALEdgeRight toEdge:ALEdgeBottom ofView:weakSelf.viewD withOffset:555.0];
    }];
}

/**
 Test setting the priority of constraints that align axes of views.
 */
- (void)testPriorityForAligningAxes
{
    DEFINE_WEAK_SELF
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewA autoAlignAxis:ALAxisHorizontal toSameAxisOfView:weakSelf.viewB];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewC autoAlignAxis:ALAxisVertical toSameAxisOfView:weakSelf.viewD];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewB autoAlignAxis:ALAxisBaseline toSameAxisOfView:weakSelf.viewA withOffset:-60.0];
    }];
}

/**
 Test setting the priority of constraints that match dimensions of views.
 */
- (void)testPriorityForMatchingDimensions
{
    DEFINE_WEAK_SELF
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewA autoSetDimensionsToSize:CGSizeMake(90, 180)];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewB autoSetDimension:ALDimensionHeight toSize:0.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewC autoSetDimension:ALDimensionWidth toSize:5.0 relation:NSLayoutRelationLessThanOrEqual];
    }];
}

/**
 Test setting the priority of constraints that constrain any attribute of views.
 */
- (void)testPriorityForConstrainingAnyAttribute
{
    DEFINE_WEAK_SELF
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewA autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeBottom ofView:weakSelf.viewB];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewA autoConstrainAttribute:ALAttributeRight toAttribute:ALAttributeHorizontal ofView:weakSelf.viewC withOffset:50.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewA autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeHeight ofView:weakSelf.viewD withOffset:-100.0 relation:NSLayoutRelationLessThanOrEqual];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewD autoConstrainAttribute:ALAttributeBaseline toAttribute:ALAttributeTrailing ofView:weakSelf.viewA withMultiplier:-6.0];
    }];
    
    [self assertConstraintIsAddedWithDefaultPriorities:^NSLayoutConstraint *{
        return [weakSelf.viewB autoConstrainAttribute:ALAttributeTop toAttribute:ALAttributeLeading ofView:weakSelf.viewA withMultiplier:0.45 relation:NSLayoutRelationGreaterThanOrEqual];
    }];
}

/**
 Test setting the priority of constraints that constrain an array of views.
 */
- (void)testPriorityForConstrainingMultipleViews
{
    DEFINE_WEAK_SELF
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoAlignViewsToEdge:ALEdgeBottom];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoAlignViewsToAxis:ALAxisVertical];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoMatchViewsDimension:ALDimensionWidth];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoSetViewsDimension:ALDimensionHeight toSize:10.0];
    }];
}

/**
 Test setting the priority of constraints that distribute an array of views.
 */
- (void)testPriorityForDistributingMultipleViews
{
    DEFINE_WEAK_SELF
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeBottom withFixedSize:25.0];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeRight withFixedSize:5.0 insetSpacing:NO];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeading withFixedSpacing:0.0];
    }];
    
    [self assertConstraintsAreAddedWithDefaultPriorities:^NSArray *{
        return [weakSelf.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:899.5 insetSpacing:NO];
    }];
}

/**
 Test that nested priority blocks work correctly.
 */
- (void)testNestingPriorityConstraintBlocks
{
    DEFINE_WEAK_SELF
    
    NSLayoutConstraint *constraint0 = [weakSelf.viewD autoAlignAxisToSuperviewAxis:ALAxisVertical];
    XCTAssertEqual(constraint0.priority, ALLayoutPriorityRequired);
    [ALView autoSetPriority:ALLayoutPriorityDefaultLow forConstraints:^{
        NSLayoutConstraint *constraint1 = [weakSelf.viewA autoAlignAxisToSuperviewAxis:ALAxisVertical];
        XCTAssertEqual(constraint1.priority, ALLayoutPriorityDefaultLow);
        [ALView autoSetPriority:ALLayoutPriorityDefaultHigh forConstraints:^{
            NSLayoutConstraint *constraint2 = [weakSelf.viewB autoAlignAxisToSuperviewAxis:ALAxisVertical];
            XCTAssertEqual(constraint2.priority, ALLayoutPriorityDefaultHigh);
        }];
        NSLayoutConstraint *constraint3 = [weakSelf.viewC autoAlignAxisToSuperviewAxis:ALAxisVertical];
        XCTAssertEqual(constraint3.priority, ALLayoutPriorityDefaultLow);
    }];
    NSLayoutConstraint *constraint4 = [weakSelf.viewD autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    XCTAssertEqual(constraint4.priority, ALLayoutPriorityRequired);
}

/**
 Test that constraint priorities are not impacted unless inside of a priority constraints block.
 */
- (void)testInstallingConstraintsOutsidePriorityBlock
{
    DEFINE_WEAK_SELF
    
    __block NSLayoutConstraint *constraint0;
    [ALView autoCreateConstraintsWithoutInstalling:^{
        constraint0 = [weakSelf.viewD autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }];
    XCTAssertEqual(constraint0.priority, ALLayoutPriorityRequired);
    constraint0.priority = ALLayoutPriorityDefaultLow;
    XCTAssertEqual(constraint0.priority, ALLayoutPriorityDefaultLow);
    
    // Install the constraint and check that its priority was not affected
    [constraint0 autoInstall];
    XCTAssertEqual(constraint0.priority, ALLayoutPriorityDefaultLow);
    
    // Remove the constraint, then re-add it but this time inside of a constraints block
    [constraint0 autoRemove];
    XCTAssertEqual(constraint0.priority, ALLayoutPriorityDefaultLow);
    [ALView autoSetPriority:ALLayoutPriorityDefaultHigh forConstraints:^{
        [constraint0 autoInstall];
        XCTAssertEqual(constraint0.priority, ALLayoutPriorityDefaultHigh);
    }];
}

@end
