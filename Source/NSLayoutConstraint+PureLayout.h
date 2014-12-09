//
//  NSLayoutConstraint+PureLayout.h
//  v2.0.4
//  https://github.com/smileyborg/PureLayout
//
//  Copyright (c) 2013-2014 Tyler Fox
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


#pragma mark - NSLayoutConstraint+PureLayout

/**
 A category on NSLayoutConstraint that allows constraints to be easily installed & removed.
 */
@interface NSLayoutConstraint (PureLayout)


#pragma mark Install & Remove Constraints

/** Activates the the constraint. */
- (void)autoInstall;

/** Deactivates the constraint. */
- (void)autoRemove;


#pragma mark Identify Constraints

#if __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10

/** Sets the string as the identifier for this constraint. Available in iOS 7.0 and OS X 10.9 and later. */
- (instancetype)autoIdentify:(NSString *)identifer;

#endif /* __PureLayout_MinBaseSDK_iOS_8_0 || __PureLayout_MinBaseSDK_OSX_10_10 */

@end
