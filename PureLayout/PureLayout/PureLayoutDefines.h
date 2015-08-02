//
//  PureLayoutDefines.h
//  https://github.com/smileyborg/PureLayout
//
//  Copyright (c) 2014-2015 Tyler Fox
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#ifndef PureLayoutDefines_h
#define PureLayoutDefines_h

#import <Foundation/Foundation.h>

// Define some preprocessor macros to check for a minimum Base SDK. These are used to prevent compile-time errors in older versions of Xcode.
#define __PureLayout_MinBaseSDK_iOS_8_0                   (TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1)
#define __PureLayout_MinBaseSDK_OSX_10_10                 (!TARGET_OS_IPHONE && __MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9)

// Define some preprocessor macros to check for a minimum System Version. These are used to prevent runtime crashes on older versions of iOS/OS X.
#define __PureLayout_MinSysVer_iOS_7_0                    (TARGET_OS_IPHONE && floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define __PureLayout_MinSysVer_iOS_8_0                    (TARGET_OS_IPHONE && floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
#define __PureLayout_MinSysVer_OSX_10_9                   (!TARGET_OS_IPHONE && floor(NSFoundationVersionNumber) > NSFoundationVersionNumber10_8_4)

// Define some preprocessor macros that allow nullability annotations to be adopted in a backwards-compatible manner.
#if __has_feature(nullability)
#   define __PL_ASSUME_NONNULL_BEGIN        NS_ASSUME_NONNULL_BEGIN
#   define __PL_ASSUME_NONNULL_END          NS_ASSUME_NONNULL_END
#else
#   define __PL_ASSUME_NONNULL_BEGIN
#   define __PL_ASSUME_NONNULL_END
#endif

// Define some preprocessor macros that allow generics to be adopted in a backwards-compatible manner.
#if __has_feature(objc_generics)
#   define __PL_GENERICS(class, ...)        class<__VA_ARGS__>
#else
#   define __PL_GENERICS(class, ...)        class
#endif

// Using generics with NSArray is so common in PureLayout that it gets a dedicated preprocessor macro for better readability.
#define __NSArray_of(type)                  __PL_GENERICS(NSArray, type)

// Define generic AL-prefixed macros for the types/constants/etc that have slight naming variations across iOS and OS X, which allows the same code to be platform-independent.
#if TARGET_OS_IPHONE
#   import <UIKit/UIKit.h>
#   define ALView                                      UIView
#   define ALEdgeInsets                                UIEdgeInsets
#   define ALEdgeInsetsZero                            UIEdgeInsetsZero
#   define ALEdgeInsetsMake                            UIEdgeInsetsMake
#   define ALLayoutConstraintAxis                      UILayoutConstraintAxis
#   define ALLayoutConstraintOrientation               ALLayoutConstraintAxis
#   define ALLayoutConstraintAxisHorizontal            UILayoutConstraintAxisHorizontal
#   define ALLayoutConstraintAxisVertical              UILayoutConstraintAxisVertical
#   define ALLayoutConstraintOrientationHorizontal     ALLayoutConstraintAxisHorizontal
#   define ALLayoutConstraintOrientationVertical       ALLayoutConstraintAxisVertical
#   define ALLayoutPriority                            UILayoutPriority
#   define ALLayoutPriorityRequired                    UILayoutPriorityRequired
#   define ALLayoutPriorityDefaultHigh                 UILayoutPriorityDefaultHigh
#   define ALLayoutPriorityDefaultLow                  UILayoutPriorityDefaultLow
#   define ALLayoutPriorityFittingSizeLevel            UILayoutPriorityFittingSizeLevel
#   define ALLayoutPriorityFittingSizeCompression      ALLayoutPriorityFittingSizeLevel
#else
#   import <Cocoa/Cocoa.h>
#   define ALView                                      NSView
#   define ALEdgeInsets                                NSEdgeInsets
#   define ALEdgeInsetsZero                            NSEdgeInsetsMake(0, 0, 0, 0)
#   define ALEdgeInsetsMake                            NSEdgeInsetsMake
#   define ALLayoutConstraintOrientation               NSLayoutConstraintOrientation
#   define ALLayoutConstraintAxis                      ALLayoutConstraintOrientation
#   define ALLayoutConstraintOrientationHorizontal     NSLayoutConstraintOrientationHorizontal
#   define ALLayoutConstraintOrientationVertical       NSLayoutConstraintOrientationVertical
#   define ALLayoutConstraintAxisHorizontal            ALLayoutConstraintOrientationHorizontal
#   define ALLayoutConstraintAxisVertical              ALLayoutConstraintOrientationVertical
#   define ALLayoutPriority                            NSLayoutPriority
#   define ALLayoutPriorityRequired                    NSLayoutPriorityRequired
#   define ALLayoutPriorityDefaultHigh                 NSLayoutPriorityDefaultHigh
#   define ALLayoutPriorityDefaultLow                  NSLayoutPriorityDefaultLow
#   define ALLayoutPriorityFittingSizeCompression      NSLayoutPriorityFittingSizeCompression
#   define ALLayoutPriorityFittingSizeLevel            ALLayoutPriorityFittingSizeCompression
#endif /* TARGET_OS_IPHONE */


#pragma mark PureLayout Attributes

/** Constants that represent edges of a view. */
typedef NS_ENUM(NSInteger, ALEdge) {
    /** The left edge of the view. */
    ALEdgeLeft = NSLayoutAttributeLeft,
    /** The right edge of the view. */
    ALEdgeRight = NSLayoutAttributeRight,
    /** The top edge of the view. */
    ALEdgeTop = NSLayoutAttributeTop,
    /** The bottom edge of the view. */
    ALEdgeBottom = NSLayoutAttributeBottom,
    /** The leading edge of the view (left edge for left-to-right languages like English, right edge for right-to-left languages like Arabic). */
    ALEdgeLeading = NSLayoutAttributeLeading,
    /** The trailing edge of the view (right edge for left-to-right languages like English, left edge for right-to-left languages like Arabic). */
    ALEdgeTrailing = NSLayoutAttributeTrailing
};

/** Constants that represent dimensions of a view. */
typedef NS_ENUM(NSInteger, ALDimension) {
    /** The width of the view. */
    ALDimensionWidth = NSLayoutAttributeWidth,
    /** The height of the view. */
    ALDimensionHeight = NSLayoutAttributeHeight
};

/** Constants that represent axes of a view. */
typedef NS_ENUM(NSInteger, ALAxis) {
    /** A vertical line equidistant from the view's left and right edges. */
    ALAxisVertical = NSLayoutAttributeCenterX,
    /** A horizontal line equidistant from the view's top and bottom edges. */
    ALAxisHorizontal = NSLayoutAttributeCenterY,
    
    /** A horizontal line at the baseline of the last line of text in the view. (For views that do not draw text, will be equivalent to ALEdgeBottom.) Same as ALAxisLastBaseline. */
    ALAxisBaseline = NSLayoutAttributeBaseline,
    /** A horizontal line at the baseline of the last line of text in the view. (For views that do not draw text, will be equivalent to ALEdgeBottom.) */
    ALAxisLastBaseline = ALAxisBaseline,
    #if __PureLayout_MinBaseSDK_iOS_8_0
    /** A horizontal line at the baseline of the first line of text in a view. (For views that do not draw text, will be equivalent to ALEdgeTop.) Available in iOS 8.0 and later. */
    ALAxisFirstBaseline = NSLayoutAttributeFirstBaseline
    #endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
};

#if __PureLayout_MinBaseSDK_iOS_8_0

/** Constants that represent layout margins of a view. Available in iOS 8.0 and later. */
typedef NS_ENUM(NSInteger, ALMargin) {
    /** The left margin of the view, based on the view's layoutMargins left inset. */
    ALMarginLeft = NSLayoutAttributeLeftMargin,
    /** The right margin of the view, based on the view's layoutMargins right inset. */
    ALMarginRight = NSLayoutAttributeRightMargin,
    /** The top margin of the view, based on the view's layoutMargins top inset. */
    ALMarginTop = NSLayoutAttributeTopMargin,
    /** The bottom margin of the view, based on the view's layoutMargins bottom inset. */
    ALMarginBottom = NSLayoutAttributeBottomMargin,
    /** The leading margin of the view, based on the view's layoutMargins left/right (depending on language direction) inset. */
    ALMarginLeading = NSLayoutAttributeLeadingMargin,
    /** The trailing margin of the view, based on the view's layoutMargins left/right (depending on language direction) inset. */
    ALMarginTrailing = NSLayoutAttributeTrailingMargin
};

/** Constants that represent axes of the layout margins of a view. Available in iOS 8.0 and later. */
typedef NS_ENUM(NSInteger, ALMarginAxis) {
    /** A vertical line equidistant from the view's left and right margins. */
    ALMarginAxisVertical = NSLayoutAttributeCenterXWithinMargins,
    /** A horizontal line equidistant from the view's top and bottom margins. */
    ALMarginAxisHorizontal = NSLayoutAttributeCenterYWithinMargins
};

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */

/** An attribute of a view that can be used in auto layout constraints. These constants are identical to the more specific enum types: 
    ALEdge, ALAxis, ALDimension, ALMargin, ALMarginAxis. It is safe to cast a more specific enum type to the ALAttribute type. */
typedef NS_ENUM(NSInteger, ALAttribute) {
    /** The left edge of the view. */
    ALAttributeLeft = ALEdgeLeft,
    /** The right edge of the view. */
    ALAttributeRight = ALEdgeRight,
    /** The top edge of the view. */
    ALAttributeTop = ALEdgeTop,
    /** The bottom edge of the view. */
    ALAttributeBottom = ALEdgeBottom,
    /** The leading edge of the view (left edge for left-to-right languages like English, right edge for right-to-left languages like Arabic). */
    ALAttributeLeading = ALEdgeLeading,
    /** The trailing edge of the view (right edge for left-to-right languages like English, left edge for right-to-left languages like Arabic). */
    ALAttributeTrailing = ALEdgeTrailing,
    /** The width of the view. */
    ALAttributeWidth = ALDimensionWidth,
    /** The height of the view. */
    ALAttributeHeight = ALDimensionHeight,
    /** A vertical line equidistant from the view's left and right edges. */
    ALAttributeVertical = ALAxisVertical,
    /** A horizontal line equidistant from the view's top and bottom edges. */
    ALAttributeHorizontal = ALAxisHorizontal,
    /** A horizontal line at the baseline of the last line of text in the view. (For views that do not draw text, will be equivalent to ALEdgeBottom.) Same as ALAxisLastBaseline. */
    ALAttributeBaseline = ALAxisBaseline,
    /** A horizontal line at the baseline of the last line of text in the view. (For views that do not draw text, will be equivalent to ALEdgeBottom.) */
    ALAttributeLastBaseline = ALAxisLastBaseline,
#if __PureLayout_MinBaseSDK_iOS_8_0
    /** A horizontal line at the baseline of the first line of text in a view. (For views that do not draw text, will be equivalent to ALEdgeTop.) Available in iOS 8.0 and later. */
    ALAttributeFirstBaseline = ALAxisFirstBaseline,
    /** The left margin of the view, based on the view's layoutMargins left inset. */
    ALAttributeMarginLeft = ALMarginLeft,
    /** The right margin of the view, based on the view's layoutMargins right inset. */
    ALAttributeMarginRight = ALMarginRight,
    /** The top margin of the view, based on the view's layoutMargins top inset. */
    ALAttributeMarginTop = ALMarginTop,
    /** The bottom margin of the view, based on the view's layoutMargins bottom inset. */
    ALAttributeMarginBottom = ALMarginBottom,
    /** The leading margin of the view, based on the view's layoutMargins left/right (depending on language direction) inset. */
    ALAttributeMarginLeading = ALMarginLeading,
    /** The trailing margin of the view, based on the view's layoutMargins left/right (depending on language direction) inset. */
    ALAttributeMarginTrailing = ALMarginTrailing,
    /** A vertical line equidistant from the view's left and right margins. */
    ALAttributeMarginAxisVertical = ALMarginAxisVertical,
    /** A horizontal line equidistant from the view's top and bottom margins. */
    ALAttributeMarginAxisHorizontal = ALMarginAxisHorizontal
#endif /* __PureLayout_MinBaseSDK_iOS_8_0 */
};

/** A block containing method calls to the PureLayout API. Takes no arguments and has no return value. */
typedef void(^ALConstraintsBlock)(void);

#endif /* PureLayoutDefines_h */
