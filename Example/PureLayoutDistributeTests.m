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

- (void)assertViews:(NSArray *)views areDistributedHorizontallyWithSpacing:(CGFloat)spacing
{
    CGFloat totalSpacing = (views.count + 1) * spacing;
    CGFloat singleViewWidth = (kContainerViewWidth - totalSpacing) / views.count;

    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginXEquals(view, CGRectGetMaxX(previousView.frame) + spacing);
        ALAssertWidthEquals(view, singleViewWidth);
        previousView = view;
    }
}

- (void)assertViews:(NSArray *)views areDistributedVerticallyWithSpacing:(CGFloat)spacing
{
    CGFloat totalSpacing = (views.count + 1) * spacing;
    CGFloat singleViewHeight = (kContainerViewHeight - totalSpacing) / views.count;
    
// Vertical axis is inverted on Mac, reverse array to compensate
#if !TARGET_OS_IPHONE
    views = [[views reverseObjectEnumerator] allObjects];
#endif /* TARGET_OS_IPHONE */
    
    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginYEquals(view, CGRectGetMaxY(previousView.frame) + spacing);
        ALAssertHeightEquals(view, singleViewHeight);
        previousView = view;
    }
}

- (void)testAutoDistributeViewsHorizontallyWithFixedSize
{
    NSArray *constraints = nil;
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:20];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSize:20];
    [constraints autoRemoveConstraints];
    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:0];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSize:0];
    [constraints autoRemoveConstraints];

    
    constraints = [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSize:1000];
    [self evaluateConstraints];
    [self assertViews:self.viewArray areDistributedHorizontallyWithSize:1000];
    [constraints autoRemoveConstraints];
}

- (void)assertViews:(NSArray *)views areDistributedHorizontallyWithSize:(CGFloat)size
{
    CGFloat totalSpacing = kContainerViewHeight - views.count * size;
    CGFloat singleSpace = totalSpacing / (views.count + 1);
    
    ALView *previousView = nil;
    for (ALView *view in views) {
        ALAssertOriginXEquals(view, CGRectGetMaxX(previousView.frame) + singleSpace);
        ALAssertWidthEquals(view, size);
        previousView = view;
    }
}

@end
