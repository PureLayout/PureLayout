//
//  NSLayoutConstraint+PureLayout.m
//  https://github.com/PureLayout/PureLayout
//
//  Copyright (c) 2013-2015 Tyler Fox
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
#import "NSArray+PureLayout.h"
#import "PureLayout+Internal.h"


#pragma mark - NSLayoutConstraint+PureLayout

@implementation NSLayoutConstraint (PureLayout)

#pragma mark Batch Constraint Creation

/**
 A global variable that stores a stack of arrays of constraints created without being immediately installed.
 When executing a constraints block passed into the +[autoCreateConstraintsWithoutInstalling:] method, a new
 mutable array is pushed onto this stack, and all constraints created with PureLayout in the block are added
 to this array. When the block finishes executing, the array is popped off this stack. Automatic constraint
 installation is prevented if this stack contains at least 1 array.
 
 NOTE: Access to this variable is not synchronized (and should only be done on the main thread).
 */
static PL__NSMutableArray_of(PL__NSMutableArray_of(NSLayoutConstraint *) *) *_al_arraysOfCreatedConstraints = nil;

/**
 A global variable that is set to YES when installing a batch of constraints collected from a call to +[autoCreateAndInstallConstraints].
 When this flag is YES, constraints are installed immediately without checking for or adding to the +[al_currentArrayOfCreatedConstraints].
 This is necessary to properly handle nested calls to +[autoCreateAndInstallConstraints], where calls whose block contains other call(s)
 should not return constraints from within the blocks of nested call(s).
 */
static BOOL _al_isInstallingCreatedConstraints = NO;

/**
 Accessor for the global state that stores arrays of constraints created without being installed.
 */
+ (PL__NSMutableArray_of(PL__NSMutableArray_of(NSLayoutConstraint *) *) *)al_arraysOfCreatedConstraints
{
    NSAssert([NSThread isMainThread], @"PureLayout is not thread safe, and must be used exclusively from the main thread.");
    if (!_al_arraysOfCreatedConstraints) {
        _al_arraysOfCreatedConstraints = [NSMutableArray new];
    }
    return _al_arraysOfCreatedConstraints;
}

/**
 Accessor for the current mutable array of constraints created without being immediately installed.
 */
+ (PL__NSMutableArray_of(NSLayoutConstraint *) *)al_currentArrayOfCreatedConstraints
{
    return [[self al_arraysOfCreatedConstraints] lastObject];
}

/**
 Accessor for the global state that determines whether automatic constraint installation should be prevented.
 */
+ (BOOL)al_preventAutomaticConstraintInstallation
{
    return (_al_isInstallingCreatedConstraints == NO) && ([[self al_arraysOfCreatedConstraints] count] > 0);
}

/**
 Creates all of the constraints in the block, then installs (activates) them all at once.
 All constraints created from calls to the PureLayout API in the block are returned in a single array.
 This may be more efficient than installing (activating) each constraint one-by-one.
 
 Note: calls to this method may be nested. The constraints returned from a call will NOT include constraints
 created in nested calls; constraints are only returned from the inner-most call they are created within.
 
 @param block A block of method calls to the PureLayout API that create constraints.
 @return An array of the constraints that were created from calls to the PureLayout API inside the block.
 */
+ (PL__NSArray_of(NSLayoutConstraint *) *)autoCreateAndInstallConstraints:(__attribute__((noescape)) ALConstraintsBlock)block
{
    NSArray *createdConstraints = [self autoCreateConstraintsWithoutInstalling:block];
    _al_isInstallingCreatedConstraints = YES;
    [createdConstraints autoInstallConstraints];
    _al_isInstallingCreatedConstraints = NO;
    return createdConstraints;
}

/**
 Creates all of the constraints in the block but prevents them from being automatically installed (activated).
 All constraints created from calls to the PureLayout API in the block are returned in a single array.
 
 Note: calls to this method may be nested. The constraints returned from a call will NOT include constraints
 created in nested calls; constraints are only returned from the inner-most call they are created within.
 
 @param block A block of method calls to the PureLayout API that create constraints.
 @return An array of the constraints that were created from calls to the PureLayout API inside the block.
 */
+ (PL__NSArray_of(NSLayoutConstraint *) *)autoCreateConstraintsWithoutInstalling:(__attribute__((noescape)) ALConstraintsBlock)block
{
    NSAssert(block, @"The constraints block cannot be nil.");
    NSArray *createdConstraints = nil;
    if (block) {
        [[self al_arraysOfCreatedConstraints] addObject:[NSMutableArray new]];
        block();
        createdConstraints = [self al_currentArrayOfCreatedConstraints];
        [[self al_arraysOfCreatedConstraints] removeLastObject];
    }
    return createdConstraints;
}


#pragma mark Set Priority For Constraints

/**
 A global variable that stores a stack of layout priorities to set on constraints.
 When executing a constraints block passed into the +[autoSetPriority:forConstraints:] method, the priority for
 that call is pushed onto this stack, and when the block finishes executing, that priority is popped off this
 stack. If this stack contains at least 1 priority, the priority at the top of the stack will be set for all
 constraints created by this library (even if automatic constraint installation is being prevented).
 NOTE: Access to this variable is not synchronized (and should only be done on the main thread).
 */
static PL__NSMutableArray_of(NSNumber *) *_al_globalConstraintPriorities = nil;

/**
 Accessor for the global stack of layout priorities.
 */
+ (PL__NSMutableArray_of(NSNumber *) *)al_globalConstraintPriorities
{
    NSAssert([NSThread isMainThread], @"PureLayout is not thread safe, and must be used exclusively from the main thread.");
    if (!_al_globalConstraintPriorities) {
        _al_globalConstraintPriorities = [NSMutableArray new];
    }
    return _al_globalConstraintPriorities;
}

/**
 Returns the current layout priority to use for constraints.
 When executing a constraints block passed into +[autoSetPriority:forConstraints:], this will return
 the priority for the current block. Otherwise, the default Required priority is returned.
 */
+ (ALLayoutPriority)al_currentGlobalConstraintPriority
{
    PL__NSMutableArray_of(NSNumber *) *globalConstraintPriorities = [self al_globalConstraintPriorities];
    if ([globalConstraintPriorities count] == 0) {
        return ALLayoutPriorityRequired;
    }
    return [[globalConstraintPriorities lastObject] floatValue];
}

/**
 Accessor for the global state that determines if we're currently in the scope of a priority constraints block.
 */
+ (BOOL)al_isExecutingPriorityConstraintsBlock
{
    return [[self al_globalConstraintPriorities] count] > 0;
}

/**
 Sets the constraint priority to the given value for all constraints created using the PureLayout
 API within the given constraints block.
 
 NOTE: This method will have no effect (and will NOT set the priority) on constraints created or added
 without using the PureLayout API!
 
 @param priority The layout priority to be set on all constraints created in the constraints block.
 @param block A block of method calls to the PureLayout API that create and install constraints.
 */
+ (void)autoSetPriority:(ALLayoutPriority)priority forConstraints:(__attribute__((noescape)) ALConstraintsBlock)block
{
    NSAssert(block, @"The constraints block cannot be nil.");
    if (block) {
        [[self al_globalConstraintPriorities] addObject:@(priority)];
        block();
        [[self al_globalConstraintPriorities] removeLastObject];
    }
}


#pragma mark Identify Constraints

#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10

/**
 A global variable that stores a stack of identifier strings to set on constraints.
 When executing a constraints block passed into the +[autoSetIdentifier:forConstraints:] method, the identifier for
 that call is pushed onto this stack, and when the block finishes executing, that identifier is popped off this
 stack. If this stack contains at least 1 identifier, the identifier at the top of the stack will be set for all
 constraints created by this library (even if automatic constraint installation is being prevented).
 NOTE: Access to this variable is not synchronized (and should only be done on the main thread).
 */
static PL__NSMutableArray_of(NSString *) *_al_globalConstraintIdentifiers = nil;

/**
 Accessor for the global state of constraint identifiers.
 */
+ (PL__NSMutableArray_of(NSString *) *)al_globalConstraintIdentifiers
{
    NSAssert([NSThread isMainThread], @"PureLayout is not thread safe, and must be used exclusively from the main thread.");
    if (!_al_globalConstraintIdentifiers) {
        _al_globalConstraintIdentifiers = [NSMutableArray new];
    }
    return _al_globalConstraintIdentifiers;
}

/**
 Returns the current identifier string to use for constraints.
 When executing a constraints block passed into +[autoSetIdentifier:forConstraints:], this will return
 the identifier for the current block. Otherwise, nil is returned.
 */
+ (NSString *)al_currentGlobalConstraintIdentifier
{
    PL__NSMutableArray_of(NSString *) *globalConstraintIdentifiers = [self al_globalConstraintIdentifiers];
    if ([globalConstraintIdentifiers count] == 0) {
        return nil;
    }
    return [globalConstraintIdentifiers lastObject];
}

/**
 Sets the identifier for all constraints created using the PureLayout API within the given constraints block.
 
 NOTE: This method will have no effect (and will NOT set the identifier) on constraints created or added
 without using the PureLayout API!
 
 @param identifier A string used to identify all constraints created in the constraints block.
 @param block A block of method calls to the PureLayout API that create and install constraints.
 */
+ (void)autoSetIdentifier:(NSString *)identifier forConstraints:(__attribute__((noescape)) ALConstraintsBlock)block
{
    NSAssert(block, @"The constraints block cannot be nil.");
    NSAssert(identifier, @"The identifier string cannot be nil.");
    if (block) {
        if (identifier) {
            [[self al_globalConstraintIdentifiers] addObject:identifier];
        }
        block();
        if (identifier) {
            [[self al_globalConstraintIdentifiers] removeLastObject];
        }
    }
}

/**
 Sets the string as the identifier for this constraint. Available in iOS 7.0 and OS X 10.9 and later.
 The identifier will be printed along with the constraint's description.
 This is helpful to document a constraint's purpose and aid in debugging.
 
 @param identifier A string used to identify this constraint.
 @return This constraint.
 */
- (instancetype)autoIdentify:(NSString *)identifier
{
    if ([self respondsToSelector:@selector(setIdentifier:)]) {
        self.identifier = identifier;
    }
    return self;
}

#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */


#pragma mark Install & Remove Constraints

/**
 Activates the constraint.
 */
- (void)autoInstall
{
#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10
    if ([self respondsToSelector:@selector(setActive:)]) {
        [NSLayoutConstraint al_applyGlobalStateToConstraint:self];
        if ([NSLayoutConstraint al_preventAutomaticConstraintInstallation]) {
            [[NSLayoutConstraint al_currentArrayOfCreatedConstraints] addObject:self];
        } else {
            self.active = YES;
        }
        return;
    }
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */
    
    NSAssert(self.firstItem || self.secondItem, @"Can't install a constraint with nil firstItem and secondItem.");
    if (self.firstItem) {
        if (self.secondItem) {
            NSAssert([self.firstItem isKindOfClass:[ALView class]] && [self.secondItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if both items are views.");
            ALView *commonSuperview = [self.firstItem al_commonSuperviewWithView:self.secondItem];
            [commonSuperview al_addConstraint:self];
        } else {
            NSAssert([self.firstItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if the item is a view.");
            [self.firstItem al_addConstraint:self];
        }
    } else {
        NSAssert([self.secondItem isKindOfClass:[ALView class]], @"Can only automatically install a constraint if the item is a view.");
        [self.secondItem al_addConstraint:self];
    }
}

/**
 Deactivates the constraint.
 */
- (void)autoRemove
{
#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10
    if ([self respondsToSelector:@selector(setActive:)]) {
        self.active = NO;
        return;
    }
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */
    
    if (self.secondItem) {
        ALView *commonSuperview = [self.firstItem al_commonSuperviewWithView:self.secondItem];
        while (commonSuperview) {
            if ([commonSuperview.constraints containsObject:self]) {
                [commonSuperview removeConstraint:self];
                return;
            }
            commonSuperview = commonSuperview.superview;
        }
    }
    else {
        [self.firstItem removeConstraint:self];
        return;
    }
    NSAssert(nil, @"Failed to remove constraint: %@", self);
}


#pragma mark Internal Methods

/**
 Applies the global constraint priority and identifier to the given constraint.
 This should be done before installing all constraints.
 
 @param constraint The constraint to set the global priority and identifier on.
 */
+ (void)al_applyGlobalStateToConstraint:(NSLayoutConstraint *)constraint
{
    if ([NSLayoutConstraint al_isExecutingPriorityConstraintsBlock]) {
        constraint.priority = [NSLayoutConstraint al_currentGlobalConstraintPriority];
    }
#if PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10
    NSString *globalConstraintIdentifier = [NSLayoutConstraint al_currentGlobalConstraintIdentifier];
    if (globalConstraintIdentifier) {
        [constraint autoIdentify:globalConstraintIdentifier];
    }
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 || PL__PureLayout_MinBaseSDK_OSX_10_10 */
}

/**
 Returns the corresponding NSLayoutAttribute for the given ALAttribute.
 
 @return The layout attribute for the given ALAttribute.
 */
+ (NSLayoutAttribute)al_layoutAttributeForAttribute:(ALAttribute)attribute
{
    NSLayoutAttribute layoutAttribute = NSLayoutAttributeNotAnAttribute;
    switch (attribute) {
        case ALAttributeLeft:
            layoutAttribute = NSLayoutAttributeLeft;
            break;
        case ALAttributeRight:
            layoutAttribute = NSLayoutAttributeRight;
            break;
        case ALAttributeTop:
            layoutAttribute = NSLayoutAttributeTop;
            break;
        case ALAttributeBottom:
            layoutAttribute = NSLayoutAttributeBottom;
            break;
        case ALAttributeLeading:
            layoutAttribute = NSLayoutAttributeLeading;
            break;
        case ALAttributeTrailing:
            layoutAttribute = NSLayoutAttributeTrailing;
            break;
        case ALAttributeWidth:
            layoutAttribute = NSLayoutAttributeWidth;
            break;
        case ALAttributeHeight:
            layoutAttribute = NSLayoutAttributeHeight;
            break;
        case ALAttributeVertical:
            layoutAttribute = NSLayoutAttributeCenterX;
            break;
        case ALAttributeHorizontal:
            layoutAttribute = NSLayoutAttributeCenterY;
            break;
        case ALAttributeBaseline: // same value as ALAxisLastBaseline
            layoutAttribute = NSLayoutAttributeBaseline;
            break;
#if PL__PureLayout_MinBaseSDK_iOS_8_0
        case ALAttributeFirstBaseline:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALAxisFirstBaseline is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeFirstBaseline;
            break;
        case ALAttributeMarginLeft:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeLeftMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeLeftMargin;
            break;
        case ALAttributeMarginRight:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeRightMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeRightMargin;
            break;
        case ALAttributeMarginTop:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeTopMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeTopMargin;
            break;
        case ALAttributeMarginBottom:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeBottomMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeBottomMargin;
            break;
        case ALAttributeMarginLeading:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeLeadingMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeLeadingMargin;
            break;
        case ALAttributeMarginTrailing:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALEdgeTrailingMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeTrailingMargin;
            break;
        case ALAttributeMarginAxisVertical:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALAxisVerticalMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeCenterXWithinMargins;
            break;
        case ALAttributeMarginAxisHorizontal:
            NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"ALAxisHorizontalMargin is only supported on iOS 8.0 or higher.");
            layoutAttribute = NSLayoutAttributeCenterYWithinMargins;
            break;
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */
        default:
            NSAssert(nil, @"Not a valid ALAttribute.");
            break;
    }
    return layoutAttribute;
}

/**
 Returns the corresponding ALLayoutConstraintAxis for the given ALAxis.
 
 @return The constraint axis for the given axis.
 */
+ (ALLayoutConstraintAxis)al_constraintAxisForAxis:(ALAxis)axis
{
    ALLayoutConstraintAxis constraintAxis;
    switch (axis) {
        case ALAxisVertical:
            constraintAxis = ALLayoutConstraintAxisVertical;
            break;
        case ALAxisHorizontal:
        case ALAxisBaseline: // same value as ALAxisLastBaseline
#if PL__PureLayout_MinBaseSDK_iOS_8_0
        case ALAxisFirstBaseline:
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */
            constraintAxis = ALLayoutConstraintAxisHorizontal;
            break;
        default:
            NSAssert(nil, @"Not a valid ALAxis.");
            constraintAxis = ALLayoutConstraintAxisHorizontal; // default to an arbitrary value to satisfy the compiler
            break;
    }
    return constraintAxis;
}

#if PL__PureLayout_MinBaseSDK_iOS_8_0

/**
 Returns the corresponding margin for the given edge.
 
 @param edge The edge to convert to the corresponding margin.
 @return The margin for the given edge.
 */
+ (ALMargin)al_marginForEdge:(ALEdge)edge
{
    NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"Margin attributes are only supported on iOS 8.0 or higher.");
    ALMargin margin;
    switch (edge) {
        case ALEdgeLeft:
            margin = ALMarginLeft;
            break;
        case ALEdgeRight:
            margin = ALMarginRight;
            break;
        case ALEdgeTop:
            margin = ALMarginTop;
            break;
        case ALEdgeBottom:
            margin = ALMarginBottom;
            break;
        case ALEdgeLeading:
            margin = ALMarginLeading;
            break;
        case ALEdgeTrailing:
            margin = ALMarginTrailing;
            break;
        default:
            NSAssert(nil, @"Not a valid ALEdge.");
            margin = ALMarginLeft; // default to an arbitrary value to satisfy the compiler
            break;
    }
    return margin;
}

/**
 Returns the corresponding margin axis for the given axis.
 
 @param axis The axis to convert to the corresponding margin axis.
 @return The margin axis for the given axis.
 */
+ (ALMarginAxis)al_marginAxisForAxis:(ALAxis)axis
{
    NSAssert(PL__PureLayout_MinSysVer_iOS_8_0, @"Margin attributes are only supported on iOS 8.0 or higher.");
    ALMarginAxis marginAxis;
    switch (axis) {
        case ALAxisVertical:
            marginAxis = ALMarginAxisVertical;
            break;
        case ALAxisHorizontal:
            marginAxis = ALMarginAxisHorizontal;
            break;
        case ALAxisBaseline:
        case ALAxisFirstBaseline:
            NSAssert(nil, @"The baseline axis attributes do not have corresponding margin axis attributes.");
            marginAxis = ALMarginAxisVertical; // default to an arbitrary value to satisfy the compiler
            break;
        default:
            NSAssert(nil, @"Not a valid ALAxis.");
            marginAxis = ALMarginAxisVertical; // default to an arbitrary value to satisfy the compiler
            break;
    }
    return marginAxis;
}

#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */

@end
