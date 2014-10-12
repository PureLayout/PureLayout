//
//  ALiOSDemo6ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014 Tyler Fox
//  https://github.com/smileyborg/PureLayout
//

#import "ALiOSDemo6ViewController.h"
#import "PureLayout.h"

@interface ALiOSDemo6ViewController ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;

@end

@implementation ALiOSDemo6ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.blueView];
    [self.view addSubview:self.redView];
    [self.view addSubview:self.yellowView];
    [self.view addSubview:self.greenView];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    // Center the blueView in its superview, and match its width to its height
    [self.blueView autoCenterInSuperview];
    [self.blueView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.blueView];
    
    // Make sure the blueView is always at least 20 pt from any edge
    [self.blueView autoPinToTopLayoutGuideOfViewController:self withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [self.blueView autoPinToBottomLayoutGuideOfViewController:self withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [self.blueView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [self.blueView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
    
    // Add constraints that set the size of the blueView to a ridiculously large size, but set the priority of these constraints
    // to a lower value than Required -- allowing the Auto Layout solver to let these constraints be broken one or both conflict
    // with a higher-priority constraint, such as the above 4 edge constraints
    [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
        [self.blueView autoSetDimensionsToSize:CGSizeMake(10000.0, 10000.0)];
    }];
    
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
