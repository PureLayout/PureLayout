//
//  PureLayoutDistributeTests.m
//  Example
//
//  Created by Vytis ⚫ on 2014-11-09.
//
//

#import "PureLayoutTestBase.h"

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
    NSArray *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSpacing:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSpacing:20];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSpacing:-30];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSpacing:-30];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSpacing:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSpacing:0];
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsVerticallyWithFixedSpacing
{
    NSArray *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSpacing:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithSpacing:20];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSpacing:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithSpacing:0];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSpacing:-35];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithSpacing:-35];
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsHorizontallyWithFixedSize
{
    NSArray *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithWidth:20];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithWidth:0];
    [constraints autoRemoveConstraints];

    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:1000];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithWidth:1000];
    [constraints autoRemoveConstraints];
}

- (void)testAutoDistributeViewsVerticallyWithFixedSize
{
    NSArray *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSize:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithHeight:20];
    [constraints autoRemoveConstraints];

    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSize:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithHeight:0];
    [constraints autoRemoveConstraints];

    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSize:500];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedVerticallyWithHeight:500];
    [constraints autoRemoveConstraints];
}

- (void)assertViews:(NSArray *)views areDistributedHorizontallyWithSpacing:(CGFloat)spacing
{
    CGFloat totalSpacing = (views.count + 1) * spacing;
    CGFloat singleViewWidth = (kContainerViewWidth - totalSpacing) / views.count;
    [self assertViews:views areDistributedHorizontallyWithWidth:singleViewWidth andSpacing:spacing];
}

- (void)assertViews:(NSArray *)views areDistributedHorizontallyWithWidth:(CGFloat)width
{
    CGFloat totalSpacing = kContainerViewWidth - views.count * width;
    CGFloat singleSpace = totalSpacing / (views.count + 1);
    [self assertViews:views areDistributedHorizontallyWithWidth:width andSpacing:singleSpace];
}

- (void)assertViews:(NSArray *)views areDistributedVerticallyWithSpacing:(CGFloat)singleSpace
{
    CGFloat totalSpacing = (views.count + 1) * singleSpace;
    CGFloat singleViewHeight = (kContainerViewHeight - totalSpacing) / views.count;
    [self assertViews:views areDistributedVerticallyWithHeight:singleViewHeight andSpacing:singleSpace];
}

- (void)assertViews:(NSArray *)views areDistributedVerticallyWithHeight:(CGFloat)height
{
    CGFloat totalSpacing = kContainerViewHeight - views.count * height;
    CGFloat singleSpace = totalSpacing / (views.count + 1);
    [self assertViews:views areDistributedVerticallyWithHeight:height andSpacing:singleSpace];
}

- (void)assertViews:(NSArray *)views areDistributedHorizontallyWithWidth:(CGFloat)width andSpacing:(CGFloat)spacing
{
    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginXEquals(view, CGRectGetMaxX(previousView.frame) + spacing);
        ALAssertWidthEquals(view, width);
        previousView = view;
    }
}

- (void)assertViews:(NSArray *)views areDistributedVerticallyWithHeight:(CGFloat)height andSpacing:(CGFloat)spacing
{
    // Vertical axis is inverted on Mac, reverse array to compensate
#if !TARGET_OS_IPHONE
    views = [[views reverseObjectEnumerator] allObjects];
#endif /* TARGET_OS_IPHONE */
    
    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginYEquals(view, CGRectGetMaxY(previousView.frame) + spacing);
        ALAssertHeightEquals(view, height);
        previousView = view;
    }
}

@end
