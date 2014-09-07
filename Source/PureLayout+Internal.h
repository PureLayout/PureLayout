//
//  PureLayout+Internal.h
//  v1.1.0
//  https://github.com/smileyborg/PureLayout
//
//  Copyright (c) 2014 Tyler Fox
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


/**
 A category that exposes the internal (private) helper methods of the ALView+PureLayout category.
 */
@interface ALView (PureLayoutInternal)

+ (NSLayoutAttribute)al_attributeForEdge:(ALEdge)edge;
+ (NSLayoutAttribute)al_attributeForAxis:(ALAxis)axis;
+ (NSLayoutAttribute)al_attributeForDimension:(ALDimension)dimension;
+ (NSLayoutAttribute)al_attributeForALAttribute:(NSInteger)ALAttribute;
+ (ALLayoutConstraintAxis)al_constraintAxisForAxis:(ALAxis)axis;

- (void)al_addConstraintUsingGlobalPriority:(NSLayoutConstraint *)constraint;
- (ALView *)al_commonSuperviewWithView:(ALView *)peerView;
- (NSLayoutConstraint *)al_alignToView:(ALView *)peerView withOption:(NSLayoutFormatOptions)alignment forAxis:(ALAxis)axis;

@end


/**
 A category that exposes the internal (private) helper methods of the NSArray+PureLayout category.
 */
@interface NSArray (PureLayoutInternal)

- (ALView *)al_commonSuperviewOfViews;
- (BOOL)al_containsMinimumNumberOfViews:(NSUInteger)minimumNumberOfViews;
- (NSArray *)al_copyViewsOnly;

@end
