//
//  PureLayout+Internal.h
//  https://github.com/PureLayout/PureLayout
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

#import "PureLayoutDefines.h"


// Using generics with NSMutableArray is so common in the internal implementation of PureLayout that it gets a dedicated preprocessor macro for better readability.
#define PL__NSMutableArray_of(type)                   PL__GENERICS(NSMutableArray, type)

PL__ASSUME_NONNULL_BEGIN

/** A constant that represents the smallest valid positive value for the multiplier of a constraint,
    since a value of 0 will cause the second item to be lost in the internal auto layout engine. */
static const CGFloat kMULTIPLIER_MIN_VALUE = (CGFloat)0.00001; // very small floating point numbers (e.g. CGFLOAT_MIN) can cause problems


/**
 A category that exposes the internal (private) helper methods of the ALView+PureLayout category.
 */
@interface ALView (PureLayoutInternal)

- (void)al_addConstraint:(NSLayoutConstraint *)constraint;
- (ALView *)al_commonSuperviewWithView:(ALView *)otherView;
- (NSLayoutConstraint *)al_alignAttribute:(ALAttribute)attribute toView:(ALView *)otherView forAxis:(ALAxis)axis;

@end


/**
 A category that exposes the internal (private) helper methods of the NSArray+PureLayout category.
 */
@interface NSArray (PureLayoutInternal)

- (ALView *)al_commonSuperviewOfViews;
- (BOOL)al_containsMinimumNumberOfViews:(NSUInteger)minimumNumberOfViews;
- (PL__NSArray_of(ALView *) *)al_copyViewsOnly;

@end


/**
 A category that exposes the internal (private) helper methods of the NSLayoutConstraint+PureLayout category.
 */
@interface NSLayoutConstraint (PureLayoutInternal)

+ (BOOL)al_preventAutomaticConstraintInstallation;
+ (PL__NSMutableArray_of(NSLayoutConstraint *) *)al_currentArrayOfCreatedConstraints;
+ (BOOL)al_isExecutingPriorityConstraintsBlock;
+ (ALLayoutPriority)al_currentGlobalConstraintPriority;
#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10
+ (nullable NSString *)al_currentGlobalConstraintIdentifier;
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */
+ (void)al_applyGlobalStateToConstraint:(NSLayoutConstraint *)constraint;
+ (NSLayoutAttribute)al_layoutAttributeForAttribute:(ALAttribute)attribute;
+ (ALLayoutConstraintAxis)al_constraintAxisForAxis:(ALAxis)axis;
#if PL__PureLayout_MinBaseSDK_iOS_8_0
+ (ALMargin)al_marginForEdge:(ALEdge)edge;
+ (ALMarginAxis)al_marginAxisForAxis:(ALAxis)axis;
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */

@end

PL__ASSUME_NONNULL_END
