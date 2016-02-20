//
//  PureLayoutDistributeTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014 Vytis Šibonis
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

#pragma mark - Multiple View Distribution Tests

@interface PureLayoutDistributeTests : PureLayoutTestBase

@end

@implementation PureLayoutDistributeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAutoDistributeViewsHorizontallyWithFixedSpacing
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSpacing:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSpacing:20];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeBaseline withFixedSpacing:-30];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSpacing:-30];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSpacing:0];
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsVerticallyWithFixedSpacing
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeRight withFixedSpacing:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithSpacing:20];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeading withFixedSpacing:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithSpacing:0];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSpacing:-35];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithSpacing:-35];
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsHorizontallyWithFixedSize
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithWidth:20];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeBottom withFixedSize:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithWidth:0];
    [constraints autoRemoveConstraints];

    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSize:250];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithWidth:250];
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsVerticallyWithFixedSize
{
    PL__NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSize:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithHeight:20];
    [constraints autoRemoveConstraints];

    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeTrailing withFixedSize:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithHeight:0];
    [constraints autoRemoveConstraints];

    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSize:500];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithHeight:500];
    [constraints autoRemoveConstraints];
}

- (void)assertViews:(PL__NSArray_of(ALView *) *)views areDistributedHorizontallyWithSpacing:(CGFloat)spacing
{
    CGFloat totalSpacing = (views.count + 1) * spacing;
    CGFloat singleViewWidth = (kContainerViewWidth - totalSpacing) / views.count;
    [self assertViews:views areDistributedHorizontallyWithWidth:singleViewWidth andSpacing:spacing];
}

- (void)assertViews:(PL__NSArray_of(ALView *) *)views areDistributedHorizontallyWithWidth:(CGFloat)width
{
    CGFloat totalSpacing = kContainerViewWidth - views.count * width;
    CGFloat singleSpace = totalSpacing / (views.count + 1);
    [self assertViews:views areDistributedHorizontallyWithWidth:width andSpacing:singleSpace];
}

- (void)assertViews:(PL__NSArray_of(ALView *) *)views areDistributedVerticallyWithSpacing:(CGFloat)singleSpace
{
    CGFloat totalSpacing = (views.count + 1) * singleSpace;
    CGFloat singleViewHeight = (kContainerViewHeight - totalSpacing) / views.count;
    [self assertViews:views areDistributedVerticallyWithHeight:singleViewHeight andSpacing:singleSpace];
}

- (void)assertViews:(PL__NSArray_of(ALView *) *)views areDistributedVerticallyWithHeight:(CGFloat)height
{
    CGFloat totalSpacing = kContainerViewHeight - views.count * height;
    CGFloat singleSpace = totalSpacing / (views.count + 1);
    [self assertViews:views areDistributedVerticallyWithHeight:height andSpacing:singleSpace];
}

- (void)assertViews:(PL__NSArray_of(ALView *) *)views areDistributedHorizontallyWithWidth:(CGFloat)width andSpacing:(CGFloat)spacing
{
    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginXEquals(view, CGRectGetMaxX(previousView.frame) + spacing);
        ALAssertWidthEquals(view, width);
        previousView = view;
    }
}

- (void)assertViews:(PL__NSArray_of(ALView *) *)views areDistributedVerticallyWithHeight:(CGFloat)height andSpacing:(CGFloat)spacing
{
    // Y-axis is inverted on Mac, reverse view array to compensate
#if !TARGET_OS_IPHONE
    views = [[views reverseObjectEnumerator] allObjects];
#endif /* !TARGET_OS_IPHONE */
    
    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginYEquals(view, CGRectGetMaxY(previousView.frame) + spacing);
        ALAssertHeightEquals(view, height);
        previousView = view;
    }
}

@end



#pragma mark - Single View Distribution Tests

@interface PureLayoutSingleViewDistributeTests : PureLayoutDistributeTests

@property ALView *singleView;

@end

@implementation PureLayoutSingleViewDistributeTests

// Set up a modified view hierarchy for this test (without calling super).
- (void)setupViewHierarchy
{
    self.singleView = [ALView newAutoLayoutView];
    
    [self.containerView addSubview:self.singleView];
}

// Override the testViewHierarchy method to test our modified view hierarchy.
- (void)testViewHierarchy
{
    XCTAssertNotNil(self.containerView, @"View hierarchy is not setup as expected.");
    XCTAssert(self.singleView.superview == self.containerView, @"View hierarchy is not setup as expected.");
}

// Override the viewArray accessor to always just return an array of the one view used for this test.
- (PL__NSArray_of(ALView *) *)viewArray
{
    return @[self.singleView];
}

- (void)testAutoDistributeViewsHorizontallyWithFixedSpacing
{
    [super testAutoDistributeViewsHorizontallyWithFixedSpacing];
}

- (void)testAutoDistributeViewsVerticallyWithFixedSpacing
{
    [super testAutoDistributeViewsVerticallyWithFixedSpacing];
}

- (void)testAutoDistributeViewsHorizontallyWithFixedSize
{
    [super testAutoDistributeViewsHorizontallyWithFixedSize];
}

- (void)testAutoDistributeViewsVerticallyWithFixedSize
{
    [super testAutoDistributeViewsVerticallyWithFixedSize];
}

@end
