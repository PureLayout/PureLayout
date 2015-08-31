//
//  PureLayoutTestBase.h
//  PureLayout Tests
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import <XCTest/XCTest.h>
#import "PureLayout.h"
#import "PureLayout+Internal.h"


#if TARGET_OS_IPHONE
#   define VALUES(iOS, OSX)        (iOS)  // a macro that takes a value for each platform, and substitutes the value for the current platform
#   define ALLabel                 UILabel
#   define ALImageView             UIImageView
#else
#   define VALUES(iOS, OSX)        (OSX)  // a macro that takes a value for each platform, and substitutes the value for the current platform
#   define ALLabel                 NSTextView
#   define ALImageView             NSImageView
#endif /* TARGET_OS_IPHONE */



#define EPSILON                                     1.0  // the allowable delta between the expected result and the actual result (due to rounding)
#define ROUNDED_EQUALS(a, b)                        (fabs((a) - (b)) < EPSILON)

#define ALAssertFrameEquals(view, x, y, w, h)       XCTAssert(ROUNDED_EQUALS(CGRectGetMinX(view.frame), x) && ROUNDED_EQUALS(CGRectGetMinY(view.frame), y) && ROUNDED_EQUALS(CGRectGetWidth(view.frame), w) && ROUNDED_EQUALS(CGRectGetHeight(view.frame), h))
#define ALAssertOriginEquals(view, x, y)            XCTAssert(ROUNDED_EQUALS(CGRectGetMinX(view.frame), x) && ROUNDED_EQUALS(CGRectGetMinY(view.frame), y))
#define ALAssertCenterEquals(view, x, y)            XCTAssert(ROUNDED_EQUALS(CGRectGetMidX(view.frame), x) && ROUNDED_EQUALS(CGRectGetMidY(view.frame), y))
#define ALAssertMaxEquals(view, x, y)               XCTAssert(ROUNDED_EQUALS(CGRectGetMaxX(view.frame), x) && ROUNDED_EQUALS(CGRectGetMaxY(view.frame), y))
#define ALAssertSizeEquals(view, w, h)              XCTAssert(ROUNDED_EQUALS(CGRectGetWidth(view.frame), w) && ROUNDED_EQUALS(CGRectGetHeight(view.frame), h))
#define ALAssertOriginXEquals(view, x)              XCTAssert(ROUNDED_EQUALS(CGRectGetMinX(view.frame), x))
#define ALAssertOriginYEquals(view, y)              XCTAssert(ROUNDED_EQUALS(CGRectGetMinY(view.frame), y))
#define ALAssertCenterXEquals(view, x)              XCTAssert(ROUNDED_EQUALS(CGRectGetMidX(view.frame), x))
#define ALAssertCenterYEquals(view, y)              XCTAssert(ROUNDED_EQUALS(CGRectGetMidY(view.frame), y))
#define ALAssertMaxXEquals(view, x)                 XCTAssert(ROUNDED_EQUALS(CGRectGetMaxX(view.frame), x))
#define ALAssertMaxYEquals(view, y)                 XCTAssert(ROUNDED_EQUALS(CGRectGetMaxY(view.frame), y))
#define ALAssertWidthEquals(view, w)                XCTAssert(ROUNDED_EQUALS(CGRectGetWidth(view.frame), w))
#define ALAssertHeightEquals(view, h)               XCTAssert(ROUNDED_EQUALS(CGRectGetHeight(view.frame), h))


static const CGFloat kContainerViewWidth = 1000.0;
static const CGFloat kContainerViewHeight = 1000.0;

@interface PureLayoutTestBase : XCTestCase

// An array of viewA, viewB, viewC, and viewD
@property (nonatomic, readonly) __NSArray_of(ALView *) *viewArray;

// The indendentation below represents how the view hierarchy is set up
@property (nonatomic, strong) ALView *containerView;
@property (nonatomic, strong) ALView *  viewA;
@property (nonatomic, strong) ALView *      viewA_A;
@property (nonatomic, strong) ALView *          viewA_A_A;
@property (nonatomic, strong) ALView *          viewA_A_B;
@property (nonatomic, strong) ALView *      viewA_B;
@property (nonatomic, strong) ALView *          viewA_B_A;
@property (nonatomic, strong) ALView *  viewB;
@property (nonatomic, strong) ALView *      viewB_A;
@property (nonatomic, strong) ALView *  viewC;
@property (nonatomic, strong) ALView *  viewD;

/** Sets up the default view hierarchy for tests. Test subclasses may override this method to customize the view hierarchy set up. */
- (void)setupViewHierarchy;
/** Test subclasses should override this method with updated tests if the -[setupViewHierarchy] method is overridden. */
- (void)testViewHierarchy;

/** Forces the container view to immediately do a layout pass, which will evaluate the constraints and set the frames for the container view and subviews. */
- (void)evaluateConstraints;

/** Forces the given view to immediately do a layout pass, which will evaluate the constraints and set the frames for the view and any subviews. */
- (void)evaluateConstraintsForView:(ALView *)view;

@end
