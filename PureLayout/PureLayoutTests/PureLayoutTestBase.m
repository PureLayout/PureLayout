//
//  PureLayoutTestBase.m
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@implementation PureLayoutTestBase

- (__NSArray_of(ALView *) *)viewArray
{
    return @[self.viewA, self.viewB, self.viewC, self.viewD];
}

- (void)setUp
{
    [super setUp];
    
    self.containerView = [[ALView alloc] initWithFrame:CGRectMake(0.0, 0.0, kContainerViewWidth, kContainerViewHeight)];
    
    [self setupViewHierarchy];
}

- (void)tearDown
{
    
    [super tearDown];
}

/**
 Sets up the default view hierarchy for tests. Test subclasses may override this method to customize the view hierarchy set up.
 */
- (void)setupViewHierarchy
{
    self.viewA = [ALView newAutoLayoutView];
    self.viewA_A = [ALView newAutoLayoutView];
    self.viewA_A_A = [ALView newAutoLayoutView];
    self.viewA_A_B = [ALView newAutoLayoutView];
    self.viewA_B = [ALView newAutoLayoutView];
    self.viewA_B_A = [ALView newAutoLayoutView];
    self.viewB = [ALView newAutoLayoutView];
    self.viewB_A = [ALView newAutoLayoutView];
    self.viewC = [ALView newAutoLayoutView];
    self.viewD = [ALView newAutoLayoutView];
    
    [self.containerView addSubview:self.viewA];
    [self.viewA addSubview:self.viewA_A];
    [self.viewA_A addSubview:self.viewA_A_A];
    [self.viewA_A addSubview:self.viewA_A_B];
    [self.viewA addSubview:self.viewA_B];
    [self.viewA_B addSubview:self.viewA_B_A];
    [self.containerView addSubview:self.viewB];
    [self.viewB addSubview:self.viewB_A];
    [self.containerView addSubview:self.viewC];
    [self.containerView addSubview:self.viewD];
}

/**
 Test the default view hierarchy to make sure it is correctly established.
 */
- (void)testViewHierarchy
{
    XCTAssertNotNil(self.containerView, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewA.superview == self.containerView, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewA_A.superview == self.viewA, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewA_A_A.superview == self.viewA_A, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewA_A_B.superview == self.viewA_A, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewA_B.superview == self.viewA, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewA_B_A.superview == self.viewA_B, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewB.superview == self.containerView, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewB_A.superview == self.viewB, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewC.superview == self.containerView, @"View hierarchy is not setup as expected.");
    XCTAssert(self.viewD.superview == self.containerView, @"View hierarchy is not setup as expected.");
}

/**
 Forces the container view to immediately do a layout pass, which will evaluate the constraints and set the frames for the container view and subviews.
 */
- (void)evaluateConstraints
{
    [self evaluateConstraintsForView:self.containerView];
}

/** 
 Recursively forces the given view and its subviews to immediately do a layout pass (evaluate the constraints and update frames).
 */
- (void)evaluateConstraintsForView:(ALView *)view
{
    for (ALView *subview in view.subviews) {
        [self evaluateConstraintsForView:subview];
    }
#if TARGET_OS_IPHONE
    [view setNeedsLayout];
    [view layoutIfNeeded];
#else
    [view setNeedsLayout:YES];
    [view layoutSubtreeIfNeeded];
#endif /* TARGET_OS_IPHONE */
}

@end
