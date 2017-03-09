//
//  PureLayoutInstantiationTests.m
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "PureLayoutTestBase.h"

@interface PureLayoutInstantiationTests : PureLayoutTestBase

@end

@implementation PureLayoutInstantiationTests

/**
 Test the +[newAutoLayoutView] method.
 */
- (void)testNewAutoLayoutView
{
    ALView *view = [ALView newAutoLayoutView];
    XCTAssertNotNil(view, @"+[ALView newAutoLayoutView] should not return nil.");
    XCTAssert([view isKindOfClass:[ALView class]], @"+[ALView newAutoLayoutView] should return an instance of ALView.");
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from +[ALView newAutoLayoutView] should not translate its autoresizing mask into constraints.");
    
    view = [ALLabel newAutoLayoutView];
    XCTAssertNotNil(view, @"+[ALLabel newAutoLayoutView] should not return nil.");
    XCTAssert([view isKindOfClass:[ALLabel class]], @"+[ALLabel newAutoLayoutView] should return an instance of ALLabel.");
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from +[ALLabel newAutoLayoutView] should not translate its autoresizing mask into constraints.");
    
    view = [ALImageView newAutoLayoutView];
    XCTAssertNotNil(view, @"+[ALImageView newAutoLayoutView] should not return nil.");
    XCTAssert([view isKindOfClass:[ALImageView class]], @"+[ALImageView newAutoLayoutView] should return an instance of ALImageView.");
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from +[ALImageView newAutoLayoutView] should not translate its autoresizing mask into constraints.");
}

/**
 Test the -[initForAutoLayout] method.
 */
- (void)testInitForAutoLayout
{
    ALView *view = [[ALView alloc] initForAutoLayout];
    XCTAssertNotNil(view, @"-[[ALView alloc] initForAutoLayout] should not return nil.");
    XCTAssert([view isKindOfClass:[ALView class]], @"-[[ALView alloc] initForAutoLayout] should return an instance of ALView.");
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from [[ALView alloc] initForAutoLayout] should not translate its autoresizing mask into constraints.");
    
    view = [[ALLabel alloc] initForAutoLayout];
    XCTAssertNotNil(view, @"-[[ALLabel alloc] initForAutoLayout] should not return nil.");
    XCTAssert([view isKindOfClass:[ALLabel class]], @"-[[ALLabel alloc] initForAutoLayout] should return an instance of ALLabel.");
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from [[ALLabel alloc] initForAutoLayout] should not translate its autoresizing mask into constraints.");
    
    view = [[ALImageView alloc] initForAutoLayout];
    XCTAssertNotNil(view, @"-[[ALImageView alloc] initForAutoLayout] should not return nil.");
    XCTAssert([view isKindOfClass:[ALImageView class]], @"-[[ALImageView alloc] initForAutoLayout] should return an instance of ALImageView.");
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from [[ALImageView alloc] initForAutoLayout] should not translate its autoresizing mask into constraints.");
}

/**
 Test the -[configureForAutoLayout] method.
 */
- (void)testConfigureForAutoLayout
{
    ALView *view = [[ALView alloc] init];
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints, @"By default, initialized views should translate their autoresizing mask into constraints.");
    ALView *returnedView = [view configureForAutoLayout];
    XCTAssert(view == returnedView, @"Calling -[view configureForAutoLayout] should return an identical reference to the same view.");
    XCTAssert(returnedView.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from [view configureForAutoLayout] should not translate its autoresizing mask into constraints.");
    
    view = [[ALLabel alloc] init];
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints, @"By default, initialized views should translate their autoresizing mask into constraints.");
    returnedView = [view configureForAutoLayout];
    XCTAssert(view == returnedView, @"Calling -[view configureForAutoLayout] should return an identical reference to the same view.");
    XCTAssert(returnedView.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from [view configureForAutoLayout] should not translate its autoresizing mask into constraints.");
    
    view = [[ALImageView alloc] init];
    XCTAssert(view.translatesAutoresizingMaskIntoConstraints, @"By default, initialized views should translate their autoresizing mask into constraints.");
    returnedView = [view configureForAutoLayout];
    XCTAssert(view == returnedView, @"Calling -[view configureForAutoLayout] should return an identical reference to the same view.");
    XCTAssert(returnedView.translatesAutoresizingMaskIntoConstraints == NO, @"The view returned from [view configureForAutoLayout] should not translate its autoresizing mask into constraints.");
}

@end
