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
    __NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
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
    __NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
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

- (void)testAutoDistributeViewsHorizontallyWithProvidedSpacings
{
    __NSArray_of(NSLayoutConstraint *) *constraints = nil;
    __NSMutableArray_of(NSNumber *) * spacings = [NSMutableArray arrayWithCapacity:self.viewArray.count + 1];
    float spacingSum = 0.0;
    for(int i=0; i < self.viewArray.count + 1; i++){
        float spacing = (i+3.0) * 2.0;
        spacingSum += spacing;
        [spacings addObject:[NSNumber numberWithFloat:spacing]];
    }
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withSpacings:spacings matchedSizes:YES];
    [self evaluateConstraints];
    
    CGFloat containerWidth = self.containerView.frame.size.width;
    float expectedWidth = (containerWidth - spacingSum) / ((float) self.viewArray.count);

    CGFloat previousEdge = 0.0;
    int i = 0;
    for(ALView * view in self.viewArray){
        CGFloat x = view.frame.origin.x;
        CGFloat spacing = x - previousEdge;
        previousEdge = x + view.frame.size.width;
        float plannedSpacing = [spacings[i] floatValue];
        XCTAssert(ROUNDED_EQUALS(plannedSpacing, spacing));
        //check if all views have almost the same width
        ALAssertWidthEquals(view, expectedWidth);
        i++;
    }
    XCTAssert(ROUNDED_EQUALS(previousEdge + [[spacings lastObject] floatValue], containerWidth));
    
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsVerticallyWithProvidedSpacings
{
    __NSArray_of(ALView *) * views = self.viewArray;
    __NSArray_of(NSLayoutConstraint *) *constraints = nil;
    __NSMutableArray_of(NSNumber *) * spacingsMutable = [NSMutableArray arrayWithCapacity:views.count + 1];
    float spacingSum = 0.0;
    for(int i=0; i < views.count + 1; i++){
        float spacing = (i+4.0) * 3.0;
        spacingSum += spacing;
        [spacingsMutable addObject:[NSNumber numberWithFloat:spacing]];
    }
    __NSArray_of(NSNumber *) * spacings = spacingsMutable;
    
    constraints = [views autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeRight withSpacings:spacings matchedSizes:YES];
    [self evaluateConstraints];
    
#if !TARGET_OS_IPHONE
    views = [[views reverseObjectEnumerator] allObjects];
    spacings = [[spacings reverseObjectEnumerator] allObjects];
#endif
    
    CGFloat containerHeight = self.containerView.frame.size.height;
    CGFloat previousEdge =  0.0;
    float expectedHeight = (containerHeight - spacingSum) / ((float) self.viewArray.count);
    int i = 0;
    for(ALView * view in views){
        CGFloat y = view.frame.origin.y;
        CGFloat spacing = y - previousEdge;
        previousEdge = y + view.frame.size.height; 
        float plannedSpacing = [spacings[i] floatValue];
        XCTAssert(ROUNDED_EQUALS(plannedSpacing, spacing));
        ALAssertHeightEquals(view, expectedHeight);
        i++;
    }
    XCTAssert(ROUNDED_EQUALS(previousEdge + [[spacings lastObject] floatValue], containerHeight));
    
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsHorizontallyWithFixedSize
{
    __NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
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
    __NSArray_of(NSLayoutConstraint *) *constraints = nil;
    
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

- (void)assertViews:(__NSArray_of(ALView *) *)views areDistributedHorizontallyWithSpacing:(CGFloat)spacing
{
    CGFloat totalSpacing = (views.count + 1) * spacing;
    CGFloat singleViewWidth = (kContainerViewWidth - totalSpacing) / views.count;
    [self assertViews:views areDistributedHorizontallyWithWidth:singleViewWidth andSpacing:spacing];
}

- (void)assertViews:(__NSArray_of(ALView *) *)views areDistributedHorizontallyWithWidth:(CGFloat)width
{
    CGFloat totalSpacing = kContainerViewWidth - views.count * width;
    CGFloat singleSpace = totalSpacing / (views.count + 1);
    [self assertViews:views areDistributedHorizontallyWithWidth:width andSpacing:singleSpace];
}

- (void)assertViews:(__NSArray_of(ALView *) *)views areDistributedVerticallyWithSpacing:(CGFloat)singleSpace
{
    CGFloat totalSpacing = (views.count + 1) * singleSpace;
    CGFloat singleViewHeight = (kContainerViewHeight - totalSpacing) / views.count;
    [self assertViews:views areDistributedVerticallyWithHeight:singleViewHeight andSpacing:singleSpace];
}

- (void)assertViews:(__NSArray_of(ALView *) *)views areDistributedVerticallyWithHeight:(CGFloat)height
{
    CGFloat totalSpacing = kContainerViewHeight - views.count * height;
    CGFloat singleSpace = totalSpacing / (views.count + 1);
    [self assertViews:views areDistributedVerticallyWithHeight:height andSpacing:singleSpace];
}

- (void)assertViews:(__NSArray_of(ALView *) *)views areDistributedHorizontallyWithWidth:(CGFloat)width andSpacing:(CGFloat)spacing
{
    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginXEquals(view, CGRectGetMaxX(previousView.frame) + spacing);
        ALAssertWidthEquals(view, width);
        previousView = view;
    }
}

- (void)assertViews:(__NSArray_of(ALView *) *)views areDistributedVerticallyWithHeight:(CGFloat)height andSpacing:(CGFloat)spacing
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
- (__NSArray_of(ALView *) *)viewArray
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
