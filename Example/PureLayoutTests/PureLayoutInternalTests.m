//
//  PureLayoutInternalTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014 Tyler Fox
//  https://github.com/smileyborg/PureLayout
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
 Test the internal NSLayoutAttribute for ALEdge translation method.
 */
- (void)testAttributeForEdge
{
    XCTAssert([ALView al_attributeForEdge:ALEdgeTop] == NSLayoutAttributeTop, @"ALEdgeTop should correspond to NSLayoutAttributeTop.");
    XCTAssert([ALView al_attributeForEdge:ALEdgeBottom] == NSLayoutAttributeBottom, @"ALEdgeBottom should correspond to NSLayoutAttributeBottom.");
    XCTAssert([ALView al_attributeForEdge:ALEdgeLeft] == NSLayoutAttributeLeft, @"ALEdgeLeft should correspond to NSLayoutAttributeLeft.");
    XCTAssert([ALView al_attributeForEdge:ALEdgeRight] == NSLayoutAttributeRight, @"ALEdgeRight should correspond to NSLayoutAttributeRight.");
    XCTAssert([ALView al_attributeForEdge:ALEdgeLeading] == NSLayoutAttributeLeading, @"ALEdgeLeading should correspond to NSLayoutAttributeLeading.");
    XCTAssert([ALView al_attributeForEdge:ALEdgeTrailing] == NSLayoutAttributeTrailing, @"ALEdgeTrailing should correspond to NSLayoutAttributeTrailing.");
    
    XCTAssertThrows([ALView al_attributeForEdge:(ALEdge)ALAxisHorizontal], @"Passing an invalid ALEdge should throw an exception.");
    XCTAssertThrows([ALView al_attributeForEdge:(ALEdge)ALAxisVertical], @"Passing an invalid ALEdge should throw an exception.");
    XCTAssertThrows([ALView al_attributeForEdge:(ALEdge)ALAxisBaseline], @"Passing an invalid ALEdge should throw an exception.");
    XCTAssertThrows([ALView al_attributeForEdge:(ALEdge)ALDimensionHeight], @"Passing an invalid ALEdge should throw an exception.");
    XCTAssertThrows([ALView al_attributeForEdge:(ALEdge)ALDimensionWidth], @"Passing an invalid ALEdge should throw an exception.");
    XCTAssertThrows([ALView al_attributeForEdge:(ALEdge)NSLayoutAttributeNotAnAttribute], @"Passing an invalid ALEdge should throw an exception.");
}

/**
 Test the internal NSLayoutAttribute for ALAxis translation method.
 */
- (void)testAttributeForAxis
{
    XCTAssert([ALView al_attributeForAxis:ALAxisHorizontal] == NSLayoutAttributeCenterY, @"ALAxisHorizontal should correspond to NSLayoutAttributeCenterY.");
    XCTAssert([ALView al_attributeForAxis:ALAxisVertical] == NSLayoutAttributeCenterX, @"ALAxisVertical should correspond to NSLayoutAttributeCenterX.");
    XCTAssert([ALView al_attributeForAxis:ALAxisBaseline] == NSLayoutAttributeBaseline, @"ALAxisBaseline should correspond to NSLayoutAttributeBaseline.");
    
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeTop], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeBottom], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeLeft], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeRight], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeLeading], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeTrailing], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALDimensionHeight], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALDimensionWidth], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)NSLayoutAttributeNotAnAttribute], @"Passing an invalid ALAxis should throw an exception.");
}

/**
 Test the internal NSLayoutAttribute for ALDimension translation method.
 */
- (void)testAttributeForDimension
{
    XCTAssert([ALView al_attributeForDimension:ALDimensionWidth] == NSLayoutAttributeWidth, @"ALDimensionWidth should correspond to NSLayoutAttributeWidth.");
    XCTAssert([ALView al_attributeForDimension:ALDimensionHeight] == NSLayoutAttributeHeight, @"ALDimensionHeight should correspond to NSLayoutAttributeHeight.");
    
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALEdgeTop], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALEdgeBottom], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALEdgeLeft], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALEdgeRight], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALEdgeLeading], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALEdgeTrailing], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALAxisHorizontal], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALAxisVertical], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)ALAxisBaseline], @"Passing an invalid ALDimension should throw an exception.");
    XCTAssertThrows([ALView al_attributeForDimension:(ALDimension)NSLayoutAttributeNotAnAttribute], @"Passing an invalid ALDimension should throw an exception.");
}

/**
 Test the internal NSLayoutAttribute for ALAttribute translation method.
 */
- (void)testAttributeForALAttribute
{
    XCTAssert([ALView al_attributeForALAttribute:ALEdgeTop] == NSLayoutAttributeTop, @"ALEdgeTop should correspond to NSLayoutAttributeTop.");
    XCTAssert([ALView al_attributeForALAttribute:ALEdgeBottom] == NSLayoutAttributeBottom, @"ALEdgeBottom should correspond to NSLayoutAttributeBottom.");
    XCTAssert([ALView al_attributeForALAttribute:ALEdgeLeft] == NSLayoutAttributeLeft, @"ALEdgeLeft should correspond to NSLayoutAttributeLeft.");
    XCTAssert([ALView al_attributeForALAttribute:ALEdgeRight] == NSLayoutAttributeRight, @"ALEdgeRight should correspond to NSLayoutAttributeRight.");
    XCTAssert([ALView al_attributeForALAttribute:ALEdgeLeading] == NSLayoutAttributeLeading, @"ALEdgeLeading should correspond to NSLayoutAttributeLeading.");
    XCTAssert([ALView al_attributeForALAttribute:ALEdgeTrailing] == NSLayoutAttributeTrailing, @"ALEdgeTrailing should correspond to NSLayoutAttributeTrailing.");
    XCTAssert([ALView al_attributeForALAttribute:ALAxisHorizontal] == NSLayoutAttributeCenterY, @"ALAxisHorizontal should correspond to NSLayoutAttributeCenterY.");
    XCTAssert([ALView al_attributeForALAttribute:ALAxisVertical] == NSLayoutAttributeCenterX, @"ALAxisVertical should correspond to NSLayoutAttributeCenterX.");
    XCTAssert([ALView al_attributeForALAttribute:ALAxisBaseline] == NSLayoutAttributeBaseline, @"ALAxisBaseline should correspond to NSLayoutAttributeBaseline.");
    XCTAssert([ALView al_attributeForALAttribute:ALDimensionWidth] == NSLayoutAttributeWidth, @"ALDimensionWidth should correspond to NSLayoutAttributeWidth.");
    XCTAssert([ALView al_attributeForALAttribute:ALDimensionHeight] == NSLayoutAttributeHeight, @"ALDimensionHeight should correspond to NSLayoutAttributeHeight.");
    
    XCTAssertThrows([ALView al_attributeForALAttribute:NSLayoutAttributeNotAnAttribute], @"Passing an invalid ALAttribute should throw an exception.");
}

/**
 Test the internal NSLayoutConstraintAxis for ALAxis translation method.
 */
- (void)testConstraintAxisForAxis
{
    XCTAssert([ALView al_constraintAxisForAxis:ALAxisHorizontal] == ALLayoutConstraintAxisHorizontal, @"ALAxisHorizontal should correspond to UILayoutConstraintAxisHorizontal.");
    XCTAssert([ALView al_constraintAxisForAxis:ALAxisVertical] == ALLayoutConstraintAxisVertical, @"ALAxisHorizontal should correspond to UILayoutConstraintAxisVertical.");
    XCTAssert([ALView al_constraintAxisForAxis:ALAxisBaseline] == ALLayoutConstraintAxisHorizontal, @"ALAxisBaseline should correspond to UILayoutConstraintAxisHorizontal.");
    
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeTop], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeBottom], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeLeft], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeRight], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeLeading], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALEdgeTrailing], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALDimensionHeight], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)ALDimensionWidth], @"Passing an invalid ALAxis should throw an exception.");
    XCTAssertThrows([ALView al_attributeForAxis:(ALAxis)NSLayoutAttributeNotAnAttribute], @"Passing an invalid ALAxis should throw an exception.");
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
    NSArray *viewArray = @[self.viewA, self.viewB, self.viewC];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");
    
    viewArray = @[self.viewC, self.viewB, self.viewA_A];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");
    
    viewArray = @[self.viewA_A_B, self.viewA_A_A];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.viewA_A, @"The common superview of viewArray should be viewA_A.");
    
    viewArray = @[self.viewA_A_B, self.viewA_A_A, self.viewA];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.viewA, @"The common superview of viewArray should be viewA.");
    
    viewArray = @[self.viewA_A_B, self.viewA_A_A, self.viewA, self.viewB, self.viewC, self.viewA_B, self.viewA_B_A, self.viewB, self.viewB_A];
    XCTAssert([viewArray al_commonSuperviewOfViews] == self.containerView, @"The common superview of viewArray should be containerView.");
    
    ALView *orphanView = [ALView newAutoLayoutView]; // has no superview
    
    viewArray = @[orphanView];
    XCTAssert([viewArray al_commonSuperviewOfViews] == orphanView, @"The common superview of viewArray should be orphanView.");
    
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
    NSArray *viewsOnlyArray = [startingArray al_copyViewsOnly];
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
