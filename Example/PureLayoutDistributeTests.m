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

- (void)testAutoDistributeViewsAlongAxisWithFixedSpacing
{
    CGFloat spacing = 20;
    CGFloat totalSpacing = (self.viewArray.count + 1) * spacing;
    CGFloat singleViewWidth = (kContainerViewWidth - totalSpacing) / self.viewArray.count;
    [self.viewArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSpacing:spacing];
    [self evaluateConstraints];
    
    ALAssertOriginEquals(self.viewA, spacing, 0);
    ALAssertSizeEquals(self.viewA, singleViewWidth, 0);
    
    ALAssertOriginEquals(self.viewB, CGRectGetMaxX(self.viewA.frame) + spacing, 0);
    ALAssertSizeEquals(self.viewB, singleViewWidth, 0);

    ALAssertOriginEquals(self.viewC, CGRectGetMaxX(self.viewB.frame) + spacing, 0);
    ALAssertSizeEquals(self.viewC, singleViewWidth, 0);

    ALAssertOriginEquals(self.viewD, CGRectGetMaxX(self.viewC.frame) + spacing, 0);
    ALAssertSizeEquals(self.viewD, singleViewWidth, 0);
}

@end
