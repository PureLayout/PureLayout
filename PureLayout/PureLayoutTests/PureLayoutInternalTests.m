//
//  PureLayoutInternalTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutInternalTests : PureLayoutTestBase

@end

@implementation PureLayoutInternalTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

/**
 Test that ALAttributes translate directly to the specific enum types.
 */
- (void)testAttributeEnums
{
    XCTAssert(ALAttributeLeft == ALEdgeLeft);
    XCTAssert(ALAttributeRight == ALEdgeRight);
    XCTAssert(ALAttributeTop == ALEdgeTop);
    XCTAssert(ALAttributeBottom == ALEdgeBottom);
    XCTAssert(ALAttributeLeading == ALEdgeLeading);
    XCTAssert(ALAttributeTrailing == ALEdgeTrailing);
    XCTAssert(ALAttributeWidth == ALDimensionWidth);
    XCTAssert(ALAttributeHeight == ALDimensionHeight);
    XCTAssert(ALAttributeVertical == ALAxisVertical);
    XCTAssert(ALAttributeHorizontal == ALAxisHorizontal);
    XCTAssert(ALAttributeBaseline == ALAxisBaseline);
    XCTAssert(ALAttributeLastBaseline == ALAxisLastBaseline);
#if __PureLayout_MinBaseSDK_iOS_8_0
    XCTAssert(ALAttributeFirstBaseline == ALAxisFirstBaseline);
    XCTAssert(ALAttributeMarginLeft == ALMarginLeft);
    XCTAssert(ALAttributeMarginRight == ALMarginRight);
    XCTAssert(ALAttributeMarginTop == ALMarginTop);
    XCTAssert(ALAttributeMarginBottom == ALMarginBottom);
    XCTAssert(ALAttributeMarginLeading == ALMarginLeading);
    XCTAssert(ALAttributeMarginTrailing == ALMarginTrailing);
    XCTAssert(ALAttributeMarginAxisVertical == ALMarginAxisVertical);
    XCTAssert(ALAttributeMarginAxisHorizontal == ALMarginAxisHorizontal);
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
}

/**
 Test the internal NSLayoutAttribute for ALAttribute translation method.
 */
- (void)testLayoutAttributeForAttribute
{
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALEdgeTop] == NSLayoutAttributeTop, @"ALEdgeTop should correspond to NSLayoutAttributeTop.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALEdgeBottom] == NSLayoutAttributeBottom, @"ALEdgeBottom should correspond to NSLayoutAttributeBottom.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALEdgeLeft] == NSLayoutAttributeLeft, @"ALEdgeLeft should correspond to NSLayoutAttributeLeft.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALEdgeRight] == NSLayoutAttributeRight, @"ALEdgeRight should correspond to NSLayoutAttributeRight.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALEdgeLeading] == NSLayoutAttributeLeading, @"ALEdgeLeading should correspond to NSLayoutAttributeLeading.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALEdgeTrailing] == NSLayoutAttributeTrailing, @"ALEdgeTrailing should correspond to NSLayoutAttributeTrailing.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisHorizontal] == NSLayoutAttributeCenterY, @"ALAxisHorizontal should correspond to NSLayoutAttributeCenterY.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisVertical] == NSLayoutAttributeCenterX, @"ALAxisVertical should correspond to NSLayoutAttributeCenterX.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisBaseline] == NSLayoutAttributeBaseline, @"ALAxisBaseline should correspond to NSLayoutAttributeBaseline.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALDimensionWidth] == NSLayoutAttributeWidth, @"ALDimensionWidth should correspond to NSLayoutAttributeWidth.");
    XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALDimensionHeight] == NSLayoutAttributeHeight, @"ALDimensionHeight should correspond to NSLayoutAttributeHeight.");
    
#if __PureLayout_MinBaseSDK_iOS_8_0
    if (__PureLayout_MinSysVer_iOS_8_0) {
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginLeft] == NSLayoutAttributeLeftMargin, @"ALMarginLeft should correspond to NSLayoutAttributeLeftMargin.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginRight] == NSLayoutAttributeRightMargin, @"ALMarginRight should correspond to NSLayoutAttributeRightMargin.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginTop] == NSLayoutAttributeTopMargin, @"ALMarginTop should correspond to NSLayoutAttributeTopMargin.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginBottom] == NSLayoutAttributeBottomMargin, @"ALMarginBottom should correspond to NSLayoutAttributeBottomMargin.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginLeading] == NSLayoutAttributeLeadingMargin, @"ALMarginLeading should correspond to NSLayoutAttributeLeadingMargin.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginTrailing] == NSLayoutAttributeTrailingMargin, @"ALMarginTrailing should correspond to NSLayoutAttributeTrailingMargin.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginAxisVertical] == NSLayoutAttributeCenterXWithinMargins, @"ALMarginAxisVertical should correspond to NSLayoutAttributeCenterXWithinMargins.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginAxisHorizontal] == NSLayoutAttributeCenterYWithinMargins, @"ALMarginAxisHorizontal should correspond to NSLayoutAttributeCenterYWithinMargins.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisLastBaseline] == NSLayoutAttributeLastBaseline, @"ALAxisLastBaseline should correspond to NSLayoutAttributeLastBaseline.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisFirstBaseline] == NSLayoutAttributeFirstBaseline, @"ALAxisFirstBaseline should correspond to NSLayoutAttributeFirstBaseline.");
    } else {
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginLeft], @"ALMarginLeft should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginRight], @"ALMarginRight should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginTop], @"ALMarginTop should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginBottom], @"ALMarginBottom should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginLeading], @"ALMarginLeading should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginTrailing], @"ALMarginTrailing should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginAxisVertical], @"ALMarginAxisVertical should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALMarginAxisHorizontal], @"ALMarginAxisHorizontal should throw an exception on iOS 6 or 7.");
        XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisFirstBaseline], @"ALAxisFirstBaseline should throw an exception on iOS 6 or 7.");
        XCTAssertNoThrow([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisLastBaseline], @"ALAxisLastBaseline should not throw an exception on iOS 6 or 7.");
        XCTAssert([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)ALAxisLastBaseline] == NSLayoutAttributeLastBaseline, @"ALAxisLastBaseline should correspond to NSLayoutAttributeLastBaseline.");
    }
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
    
    XCTAssertThrows([NSLayoutConstraint al_layoutAttributeForAttribute:(ALAttribute)NSLayoutAttributeNotAnAttribute], @"Passing an invalid ALAttribute should throw an exception.");
}

#if __PureLayout_MinBaseSDK_iOS_8_0

/**
 Test the internal edge <-> margin translation method.
 */
- (void)testMarginForEdge
{
    if (__PureLayout_MinSysVer_iOS_8_0) {
        XCTAssert([NSLayoutConstraint al_marginForEdge:ALEdgeLeft] == ALMarginLeft);
        XCTAssert([NSLayoutConstraint al_marginForEdge:ALEdgeRight] == ALMarginRight);
        XCTAssert([NSLayoutConstraint al_marginForEdge:ALEdgeTop] == ALMarginTop);
        XCTAssert([NSLayoutConstraint al_marginForEdge:ALEdgeBottom] == ALMarginBottom);
        XCTAssert([NSLayoutConstraint al_marginForEdge:ALEdgeLeading] == ALMarginLeading);
        XCTAssert([NSLayoutConstraint al_marginForEdge:ALEdgeTrailing] == ALMarginTrailing);
    } else {
        XCTAssertThrows([NSLayoutConstraint al_marginForEdge:ALEdgeLeft]);
        XCTAssertThrows([NSLayoutConstraint al_marginForEdge:ALEdgeRight]);
        XCTAssertThrows([NSLayoutConstraint al_marginForEdge:ALEdgeTop]);
        XCTAssertThrows([NSLayoutConstraint al_marginForEdge:ALEdgeBottom]);
        XCTAssertThrows([NSLayoutConstraint al_marginForEdge:ALEdgeLeading]);
        XCTAssertThrows([NSLayoutConstraint al_marginForEdge:ALEdgeTrailing]);
    }
}

/**
 Test the internal axis <-> margin axis translation method.
 */
- (void)testMarginAxisforAxis
{
    if (__PureLayout_MinSysVer_iOS_8_0) {
        XCTAssert([NSLayoutConstraint al_marginAxisForAxis:ALAxisVertical] == ALMarginAxisVertical);
        XCTAssert([NSLayoutConstraint al_marginAxisForAxis:ALAxisHorizontal] == ALMarginAxisHorizontal);
    } else {
        XCTAssertThrows([NSLayoutConstraint al_marginAxisForAxis:ALAxisVertical]);
        XCTAssertThrows([NSLayoutConstraint al_marginAxisForAxis:ALAxisHorizontal]);
    }
    XCTAssertThrows([NSLayoutConstraint al_marginAxisForAxis:ALAxisBaseline]);
    XCTAssertThrows([NSLayoutConstraint al_marginAxisForAxis:ALAxisFirstBaseline]);
}

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */

/**
 Test the internal NSLayoutConstraintAxis for ALAxis translation method.
 */
- (void)testConstraintAxisForAxis
{
    XCTAssert([NSLayoutConstraint al_constraintAxisForAxis:ALAxisHorizontal] == ALLayoutConstraintAxisHorizontal, @"ALAxisHorizontal should correspond to UILayoutConstraintAxisHorizontal.");
    XCTAssert([NSLayoutConstraint al_constraintAxisForAxis:ALAxisVertical] == ALLayoutConstraintAxisVertical, @"ALAxisHorizontal should correspond to UILayoutConstraintAxisVertical.");
    XCTAssert([NSLayoutConstraint al_constraintAxisForAxis:ALAxisBaseline] == ALLayoutConstraintAxisHorizontal, @"ALAxisBaseline should correspond to UILayoutConstraintAxisHorizontal.");
}

/**
 Test the internal helper method to identify the common superview of two views.
 */
- (void)testCommonSuperviewWithView
{
    XCTAssert([self.viewA al_commonSuperviewWithView:self.viewB] == self.containerView, @"The common superview of viewA and viewB should be containerView.");
    XCTAssert([self.viewB al_commonSuperviewWithView:self.viewA] == self.containerView, @"The common superview of viewB and viewA should be containerView.");
    XCTAssert([self.viewA al_commonSuperviewWithView:self.viewC] == self.containerView, @"The common superview of viewA and viewC should be containerView.");
    XCTAssert([self.viewA al_commonSuperviewWithView:self.viewD] == self.containerView, @"The common superview of viewA and viewD should be containerView.");
    XCTAssert([self.viewB al_commonSuperviewWithView:self.viewD] == self.containerView, @"The common superview of viewB and viewD should be containerView.");
    XCTAssert([self.viewC al_commonSuperviewWithView:self.viewD] == self.containerView, @"The common superview of viewC and viewD should be containerView.");
    XCTAssert([self.viewA al_commonSuperviewWithView:self.viewC] == self.containerView, @"The common superview of viewA and viewC should be containerView.");
    
    XCTAssert([self.viewA al_commonSuperviewWithView:self.viewA_A] == self.viewA, @"The common superview of viewA and viewA_A should be viewA.");
    XCTAssert([self.viewA al_commonSuperviewWithView:self.viewA_B] == self.viewA, @"The common superview of viewA and viewA_B should be viewA.");
    XCTAssert([self.viewA al_commonSuperviewWithView:self.viewA_A_A] == self.viewA, @"The common superview of viewA and viewA_A_A should be viewA.");
    XCTAssert([self.viewA_A al_commonSuperviewWithView:self.viewA] == self.viewA, @"The common superview of viewA_A and viewA should be viewA.");
    XCTAssert([self.viewA_B al_commonSuperviewWithView:self.viewA] == self.viewA, @"The common superview of viewA_B and viewA should be viewA.");
    XCTAssert([self.viewA_A_A al_commonSuperviewWithView:self.viewA] == self.viewA, @"The common superview of viewA_A_A and viewA should be viewA.");
    
    XCTAssert([self.viewA_A_A al_commonSuperviewWithView:self.viewA_B_A] == self.viewA, @"The common superview of viewA_A_A and viewA_B_A should be viewA.");
    XCTAssert([self.viewA_B_A al_commonSuperviewWithView:self.viewA_A_A] == self.viewA, @"The common superview of viewA_B_A and viewA_A_A should be viewA.");
    
    XCTAssert([self.viewA_A_A al_commonSuperviewWithView:self.viewD] == self.containerView, @"The common superview of viewA_A_A and viewD should be containerView.");
    XCTAssert([self.viewD al_commonSuperviewWithView:self.viewA_A_A] == self.containerView, @"The common superview of viewD and viewA_A_A should be containerView.");
    
    XCTAssert([self.viewA_A_A al_commonSuperviewWithView:self.viewA_A_B] == self.viewA_A, @"The common superview of viewA_A_A and viewA_A_B should be viewA_A.");
    XCTAssert([self.viewA_A_B al_commonSuperviewWithView:self.viewA_A_A] == self.viewA_A, @"The common superview of viewA_A_B and viewA_A_A should be viewA_A.");
    
    XCTAssert([self.viewA_B al_commonSuperviewWithView:self.viewA_B] == self.viewA_B, @"The common superview of viewA_B and viewA_B should be itself.");
    
    ALView *orphanView = [ALView newAutoLayoutView]; // has no superview
    
    XCTAssert([orphanView al_commonSuperviewWithView:orphanView] == orphanView, @"The common superview of orphanView and orphanView should be itself.");
    
    XCTAssertThrows([orphanView al_commonSuperviewWithView:self.viewA_A_A], @"An exception should be thrown as there is no common superview of orphanView and viewA_A_A.");
    XCTAssertThrows([self.viewA_A_A al_commonSuperviewWithView:orphanView], @"An exception should be thrown as there is no common superview of view_A_A_A and orphanView.");
    
    XCTAssertThrows([orphanView al_commonSuperviewWithView:self.containerView], @"An exception should be thrown as there is no common superview of orphanView and containerView.");
    XCTAssertThrows([self.containerView al_commonSuperviewWithView:orphanView], @"An exception should be thrown as there is no common superview of containerView and orphanView.");
}

/**
 Test the internal helper method to identify the common superview of an array of views.
 */
- (void)testCommonSuperviewOfViews
{
    __NSArray_of(ALView *) *viewArray;
    
    viewArray = @[self.viewA, self.viewB, self.viewC];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");
    
    viewArray = @[self.viewA_A, self.viewB_A];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");
    
    viewArray = @[self.viewC, self.viewB, self.viewA_A];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");
    
    viewArray = @[self.viewA_A_B, self.viewA_A_A];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.viewA_A, @"The common superview of viewArray should be viewA_A.");
    
    viewArray = @[self.viewA_A_B, self.viewA_A_A, self.viewA];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.viewA, @"The common superview of viewArray should be viewA.");
    
    viewArray = @[self.viewA_A_B, self.viewA_A_A, self.viewA, self.viewB, self.viewC, self.viewA_B, self.viewA_B_A, self.viewB, self.viewB_A];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");

    viewArray = @[self.viewA];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");
    
    
    ALView *orphanView = [ALView newAutoLayoutView]; // has no superview

    viewArray = @[orphanView];
    XCTAssertThrows([viewArray al_commonSuperviewOfViews], @"An exception should be thrown as there is no common superview of viewArray.");

    viewArray = @[orphanView, self.viewC, self.viewB, self.viewA_A];
    XCTAssertThrows([viewArray al_commonSuperviewOfViews], @"An exception should be thrown as there is no common superview of viewArray.");
    
    viewArray = @[self.viewA_A_B, self.viewB, orphanView];
    XCTAssertThrows([viewArray al_commonSuperviewOfViews], @"An exception should be thrown as there is no common superview of viewArray.");
}

/**
 Test the internal helper method that counts whether an array contains a minimum number of views.
 */
- (void)testContainsMinimumNumberOfViews
{
    NSArray *array = @[[NSObject new], [ALLabel new], [ALImageView new], [NSString new], [ALView new], [NSDecimalNumber new], [NSLayoutConstraint new]];
    XCTAssert([array al_containsMinimumNumberOfViews:2]);
    XCTAssert([array al_containsMinimumNumberOfViews:3]);
    XCTAssert([array al_containsMinimumNumberOfViews:4] == NO);
    
    array = @[[ALView newAutoLayoutView]];
    XCTAssert([array al_containsMinimumNumberOfViews:1]);
    XCTAssert([array al_containsMinimumNumberOfViews:2] == NO);
    
    array = @[];
    XCTAssert([array al_containsMinimumNumberOfViews:0]);
    XCTAssert([array al_containsMinimumNumberOfViews:1] == NO);
}

/**
 Test the internal helper method to return a copy of an arbitrary array containing only the views.
 */
- (void)testCopyViewsOnly
{
    NSArray *startingArray = @[[NSObject new], [ALLabel new], [ALImageView new], [NSString new], [ALView new], [NSDecimalNumber new], [NSLayoutConstraint new]];
    __NSArray_of(ALView *) *viewsOnlyArray = [startingArray al_copyViewsOnly];
    XCTAssert([viewsOnlyArray count] == 3, @"Only 3 objects should remain in the new array.");
    
    startingArray = @[[ALView newAutoLayoutView]];
    viewsOnlyArray = [startingArray al_copyViewsOnly];
    XCTAssert([viewsOnlyArray count] == 1, @"1 object should remain in the new array.");
    XCTAssert(viewsOnlyArray[0] == startingArray[0], @"The one object in both arrays should be identical.");
    
    startingArray = @[];
    viewsOnlyArray = [startingArray al_copyViewsOnly];
    XCTAssert([viewsOnlyArray count] == 0, @"The new array should be empty.");
}

@end
