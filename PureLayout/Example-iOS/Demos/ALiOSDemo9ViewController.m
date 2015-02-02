//
//  ALiOSDemo9ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014 Tyler Fox
//  https://github.com/smileyborg/PureLayout
//

#import "ALiOSDemo9ViewController.h"
#import "PureLayout.h"

@interface ALiOSDemo9ViewController ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo9ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.blueView];
    [self.blueView addSubview:self.redView];
    [self.redView addSubview:self.yellowView];
    [self.yellowView addSubview:self.greenView];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        NSAssert(__PureLayout_MinSysVer_iOS_8_0, @"This demo requires iOS 8.0 or higher to run.");
        
        // Before layoutMargins, this is a typical method of giving a subview some padding from its superview edges
        [self.blueView autoPinToTopLayoutGuideOfViewController:self withInset:10.0];
        [self.blueView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10.0, 10.0, 10.0) excludingEdge:ALEdgeTop];
        
        // Set the layoutMargins of the blueView, which will have an effect on subviews of the blueView that attach to
        // the blueView's margin attributes -- in this case, the redView
        self.blueView.layoutMargins = UIEdgeInsetsMake(10.0, 20.0, 80.0, 20.0);
        [self.redView autoPinEdgesToSuperviewMargins];
        
        // Let the redView inherit the values we just set for the blueView's layoutMargins by setting the below property to YES.
        // Then, pin the yellowView's edges to the redView's margins, giving the yellowView the same insets from its superview as the redView.
        self.redView.preservesSuperviewLayoutMargins = YES;
        [self.yellowView autoPinEdgeToSuperviewMargin:ALEdgeLeft];
        [self.yellowView autoPinEdgeToSuperviewMargin:ALEdgeRight];
        
        // By aligning the yellowView to its superview's horiztonal margin axis, the yellowView will be positioned with its horizontal axis
        // in the middle of the redView's top and bottom margins (causing it to be slightly closer to the top of the redView, since the
        // redView has a much larger bottom margin than top margin).
        [self.yellowView autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
        [self.yellowView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.redView withMultiplier:0.5];
        
        // Since yellowView.preservesSuperviewLayoutMargins is NO by default, it will not preserve (inherit) its superview's margins,
        // and instead will just have the default margins of: {8.0, 8.0, 8.0, 8.0} which will apply to its subviews (greenView)
        [self.greenView autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeBottom];
        [self.greenView autoSetDimension:ALDimensionHeight toSize:50.0];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (UIView *)blueView
{
    if (!_blueView) {
        _blueView = [UIView newAutoLayoutView];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}

- (UIView *)redView
{
    if (!_redView) {
        _redView = [UIView newAutoLayoutView];
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (UIView *)yellowView
{
    if (!_yellowView) {
        _yellowView = [UIView newAutoLayoutView];
        _yellowView.backgroundColor = [UIColor yellowColor];
    }
    return _yellowView;
}

- (UIView *)greenView
{
    if (!_greenView) {
        _greenView = [UIView newAutoLayoutView];
        _greenView.backgroundColor = [UIColor greenColor];
    }
    return _greenView;
}

@end
