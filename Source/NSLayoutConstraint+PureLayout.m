//
//  NSLayoutConstraint+PureLayout.m
//  v1.1.0
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

#import "NSLayoutConstraint+PureLayout.h"
#import "ALView+PureLayout.h"
#import "PureLayout+Internal.h"


#pragma mark - NSLayoutConstraint+PureLayout

@implementation NSLayoutConstraint (PureLayout)

/**
 Adds the constraint to the appropriate view.
 */
- (void)autoInstall
{
    NSAssert(self.firstItem || self.secondItem, @"Can't install a constraint with nil firstItem and secondItem.");
    if (self.firstItem) {
        if (self.secondItem) {
            NSAssert([self.firstItem isKindOfClass:[ALView class]] && [self.secondItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if both items are views.");
            ALView *commonSuperview = [self.firstItem al_commonSuperviewWithView:self.secondItem];
            [commonSuperview al_addConstraintUsingGlobalPriority:self];
        } else {
            NSAssert([self.firstItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if the item is a view.");
            [self.firstItem al_addConstraintUsingGlobalPriority:self];
        }
    } else {
        NSAssert([self.secondItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if the item is a view.");
        [self.secondItem al_addConstraintUsingGlobalPriority:self];
    }
}

/**
 Removes the constraint from the view it has been added to.
 */
- (void)autoRemove
{
    [ALView autoRemoveConstraint:self];
}

@end
