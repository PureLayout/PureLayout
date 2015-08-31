//
//  ALMacViewController.m
//  PureLayout Example-Mac
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALMacViewController.h"
#import <PureLayout/PureLayout.h>

typedef NS_ENUM(NSInteger, ExampleConstraintDemo) {
    ExampleConstraintDemoReset = 0,
    ExampleConstraintDemo1,
    ExampleConstraintDemo2,
    ExampleConstraintDemo3,
    ExampleConstraintDemo4,
    ExampleConstraintDemo5,
    ExampleConstraintDemoCount
};

@interface ALMacViewController ()

@property (nonatomic, strong) NSView *containerView;

@property (nonatomic, strong) NSView *blueView;
@property (nonatomic, strong) NSView *redView;
@property (nonatomic, strong) NSView *yellowView;
@property (nonatomic, strong) NSView *greenView;
@property (nonatomic, strong) NSTextView *orangeView;

@property (nonatomic, assign) ExampleConstraintDemo constraintDemo;

@property (nonatomic, assign) BOOL isAnimatingDemo3;
@property (nonatomic, strong) NSLayoutConstraint *demo3BlueBottomInset;
@property (nonatomic, strong) NSLayoutConstraint *demo3BlueRightInset;
@property (nonatomic, strong) NSLayoutConstraint *demo3RedSizeConstraint;
@property (nonatomic, strong) NSLayoutConstraint *demo3GreenPinConstraint;

@end

@implementation ALMacViewController

- (void)loadView
{
    self.view = [NSView new];
    
    [self resetAndSetupViews];
    
    // Start off by resetting and advancing to the first demo
    self.constraintDemo = ExampleConstraintDemoReset;
    [self nextDemo];
}

- (void)resetAndSetupViews
{
    [_containerView removeFromSuperview];
    [_blueView removeFromSuperview];
    [_redView removeFromSuperview];
    [_yellowView removeFromSuperview];
    [_greenView removeFromSuperview];
    [_orangeView removeFromSuperview];
    
    _containerView = nil;
    _blueView = nil;
    _redView = nil;
    _yellowView = nil;
    _greenView = nil;
    _orangeView = nil;
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.blueView];
    [self.containerView addSubview:self.redView];
    [self.containerView addSubview:self.yellowView];
    [self.containerView addSubview:self.greenView];
    [self.containerView addSubview:self.orangeView];
}

/**
 Demonstrates:
    - Setting a view to a fixed width
    - Matching the widths of subviews
    - Distributing subviews vertically with a fixed height
 */
- (void)setupDemo1
{
    NSArray *subviews = @[self.blueView, self.redView, self.yellowView, self.greenView, self.orangeView];
    
    [self.blueView autoSetDimension:ALDimensionWidth toSize:80.0];
    [subviews autoMatchViewsDimension:ALDimensionWidth];
    
    [self.orangeView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [subviews autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSize:30.0 insetSpacing:YES];
}

/**
 Demonstrates:
 - Matching a view's width to its height
 - Matching the heights of subviews
 - Distributing subviews horizontally with fixed spacing
 */
- (void)setupDemo2
{
    NSArray *subviews = @[self.blueView, self.redView, self.yellowView, self.greenView, self.orangeView];

    [self.blueView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.blueView];
    [subviews autoMatchViewsDimension:ALDimensionHeight];
    
    [self.orangeView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [subviews autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:NO];
}

/**
 Demonstrates:
 - Achieving a common layout scenario for content (e.g. an image view, title label, and body text)
 - Matching the widths of two views using a multiplier
 - Pinning views to each other and to the superview to maintain padding and insets
 - Using leading/trailing edge attributes instead of left/right
 (Change language from English to Arabic to see the difference.)
 */
- (void)setupDemo3
{
    [self.redView autoSetDimension:ALDimensionHeight toSize:44.0];
    [self.blueView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.redView];

    [self.redView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20.0];
    [self.redView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0];

    [self.blueView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:20.0];
    [self.blueView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0];

    [self.blueView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.redView withOffset:10.0];
    [self.blueView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.redView withMultiplier:3.0];

    [self.orangeView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.blueView withOffset:20.0];
    [self.orangeView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.redView withOffset:20.0];
    [self.orangeView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.blueView withOffset:-10.0];
    [self.orangeView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0];
}

/**
 Demonstrates:
 - Looping over subviews to apply constraints between them
 - Setting a priority less than required for specific constraints
 - Specifying an inequality constraint that competes with the lower priority constraints
 --> the orange view will maintain at least 10 points of spacing to the bottom of its superview (required constraint),
 and this may require reducing its height (breaking the lower priority constraint)
 */
- (void)setupDemo4
{
    [self.blueView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [self.blueView autoSetDimensionsToSize:CGSizeMake(25.0, 10.0)];
    [self.blueView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    NSArray *subviews = @[self.blueView, self.redView, self.yellowView, self.greenView, self.orangeView];
    
    [subviews autoAlignViewsToAxis:ALAxisVertical];
    
    NSView *previousView = nil;
    for (NSView *view in subviews) {
        if (previousView) {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:10.0];
            // The orange view will be allowed to change its size if it conflicts with a required constraint
            NSLayoutPriority priority = (view == self.orangeView) ? NSLayoutPriorityDefaultHigh + 1 : NSLayoutPriorityRequired;
            [NSLayoutConstraint autoSetPriority:priority forConstraints:^{
                [view autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:previousView withMultiplier:1.5];
                [view autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:previousView withMultiplier:2.0];
            }];
        }
        previousView = view;
    }
    
    [self.orangeView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView withOffset:-10.0 relation:NSLayoutRelationLessThanOrEqual];
}

/**
 Demonstrates:
 - Applying a constraint across different types of attributes
 */
- (void)setupDemo5
{
    [self.redView autoCenterInSuperview];
    [self.redView autoSetDimensionsToSize:CGSizeMake(100.0, 250.0)];
    
    [self.orangeView autoSetDimensionsToSize:CGSizeMake(50.0, 50.0)];
    [self.orangeView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.redView];
    [self.orangeView autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeTop ofView:self.redView];
}


#pragma mark Private Helper Methods

/**
 Switches to the next demo in the sequence.
 Removes all constraints, then calls the next demo's setup method.
 */
- (void)setupConstraintsForCurrentDemo
{
    if (self.constraintDemo >= ExampleConstraintDemoCount) {
        // Return to the first demo after the last one
        self.constraintDemo = ExampleConstraintDemo1;
    }
    
    [self resetAndSetupViews];
    
    [self.containerView autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsMake(30.0, 10.0, 10.0, 10.0)];
    
    switch (self.constraintDemo) {
        case ExampleConstraintDemo1:
            [self setupDemo1];
            break;
        case ExampleConstraintDemo2:
            [self setupDemo2];
            break;
        case ExampleConstraintDemo3:
            [self setupDemo3];
            break;
        case ExampleConstraintDemo4:
            [self setupDemo4];
            break;
        case ExampleConstraintDemo5:
            [self setupDemo5];
            break;
        default:
            self.constraintDemo = ExampleConstraintDemoReset;
            break;
    }
}

/**
 Advances to the next demo and flags the view for a constraint update.
 */
- (void)nextDemo
{
    self.constraintDemo++;
    
    [self setupConstraintsForCurrentDemo];
}

#pragma mark Property Accessors

- (NSView *)containerView
{
    if (!_containerView) {
        _containerView = [NSView newAutoLayoutView];
        _containerView.wantsLayer = YES;
        _containerView.layer.backgroundColor = [NSColor colorWithWhite:0.2 alpha:1].CGColor;
    }
    return _containerView;
}

- (NSView *)blueView
{
    if (!_blueView) {
        _blueView = [[NSView alloc] initForAutoLayout];
        _blueView.wantsLayer = YES;
        _blueView.layer.backgroundColor = [NSColor blueColor].CGColor;
    }
    return _blueView;
}

- (NSView *)redView
{
    if (!_redView) {
        _redView = [[NSView alloc] initForAutoLayout];
        _redView.wantsLayer = YES;
        _redView.layer.backgroundColor = [NSColor redColor].CGColor;
    }
    return _redView;
}

- (NSView *)yellowView
{
    if (!_yellowView) {
        _yellowView = [[NSView alloc] initForAutoLayout];
        _yellowView.wantsLayer = YES;
        _yellowView.layer.backgroundColor = [NSColor yellowColor].CGColor;
    }
    return _yellowView;
}

- (NSView *)greenView
{
    if (!_greenView) {
        _greenView = [[NSView alloc] initForAutoLayout];
        _greenView.wantsLayer = YES;
        _greenView.layer.backgroundColor = [NSColor greenColor].CGColor;
    }
    return _greenView;
}

- (NSTextView *)orangeView
{
    if (!_orangeView) {
        _orangeView = [[NSTextView alloc] initForAutoLayout];
        _orangeView.wantsLayer = YES;
        _orangeView.backgroundColor = [NSColor orangeColor];
        _orangeView.font = [NSFont systemFontOfSize:10.0];
        _orangeView.textColor = [NSColor whiteColor];
        _orangeView.alignment = NSCenterTextAlignment;
        _orangeView.string = NSLocalizedString(@"Lorem ipsum", nil);
        _orangeView.verticallyResizable = NO;
    }
    return _orangeView;
}

@end
