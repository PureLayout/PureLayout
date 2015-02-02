//
//  ALiOSDemo10ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014 Tyler Fox
//  https://github.com/smileyborg/PureLayout
//

#import "ALiOSDemo10ViewController.h"
#import "PureLayout.h"

@interface ALiOSDemo10ViewController ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, strong) UIButton *toggleConstraintsButton;

@property (nonatomic, assign) BOOL isShowingHorizontalLayout;
@property (nonatomic, strong) NSArray *horizontalLayoutConstraints;
@property (nonatomic, strong) NSArray *verticalLayoutConstraints;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo10ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.blueView];
    [self.view addSubview:self.redView];
    [self.view addSubview:self.yellowView];
    [self.view addSubview:self.greenView];
    
    [self.view addSubview:self.toggleConstraintsButton];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        NSArray *views = @[self.redView, self.blueView, self.yellowView, self.greenView];
        
        // Create the constraints that define the horizontal layout, but don't install any of them - just store them for now
        self.horizontalLayoutConstraints = [UIView autoCreateConstraintsWithoutInstalling:^{
            [views autoSetViewsDimension:ALDimensionHeight toSize:40.0];
            [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
            [self.redView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        }];
        
        // Create the constraints that define the vertical layout, but don't install any of them - just store them for now
        self.verticalLayoutConstraints = [UIView autoCreateConstraintsWithoutInstalling:^{
            [views autoSetViewsDimension:ALDimensionWidth toSize:60.0];
            [views autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSpacing:70.0 insetSpacing:YES matchedSizes:YES];
            [self.redView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        }];
        
        // Start out in the horizontal layout
        self.isShowingHorizontalLayout = YES;
        [self.horizontalLayoutConstraints autoInstallConstraints];
        
        [self.toggleConstraintsButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
        [self.toggleConstraintsButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

/**
 Callback when the "Toggle Constraints" button is tapped.
 */
- (void)toggleConstraints:(UIButton *)sender
{
    self.isShowingHorizontalLayout = !self.isShowingHorizontalLayout;
    
    if (self.isShowingHorizontalLayout) {
        [self.verticalLayoutConstraints autoRemoveConstraints];
        [self.horizontalLayoutConstraints autoInstallConstraints];
    } else {
        [self.horizontalLayoutConstraints autoRemoveConstraints];
        [self.verticalLayoutConstraints autoInstallConstraints];
    }

    /**
     Uncomment the below code if you want the transitions to be animated!
     */
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.view layoutIfNeeded];
//    }];
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

- (UIButton *)toggleConstraintsButton
{
    if (!_toggleConstraintsButton) {
        _toggleConstraintsButton = [UIButton newAutoLayoutView];
        [_toggleConstraintsButton setTitle:@"Toggle Constraints" forState:UIControlStateNormal];
        [_toggleConstraintsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_toggleConstraintsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_toggleConstraintsButton addTarget:self action:@selector(toggleConstraints:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleConstraintsButton;
}

@end
