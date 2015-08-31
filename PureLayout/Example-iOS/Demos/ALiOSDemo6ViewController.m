//
//  ALiOSDemo6ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemo6ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ALiOSDemo6ViewController ()

@property (nonatomic, strong) UIView *blueView;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo6ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.blueView];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        // Center the blueView in its superview, and match its width to its height
        [self.blueView autoCenterInSuperview];
        [self.blueView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.blueView];
        
        // Make sure the blueView is always at least 20 pt from any edge
        [self.blueView autoPinToTopLayoutGuideOfViewController:self withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
        [self.blueView autoPinToBottomLayoutGuideOfViewController:self withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
        [self.blueView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
        [self.blueView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0 relation:NSLayoutRelationGreaterThanOrEqual];
        
        // Add constraints that set the size of the blueView to a ridiculously large size, but set the priority of these constraints
        // to a lower value than Required. This allows the Auto Layout solver to let these constraints be broken if one or both of
        // them conflict with higher-priority constraint(s), such as the above 4 edge constraints.
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.blueView autoSetDimensionsToSize:CGSizeMake(10000.0, 10000.0)];
        }];
        
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

@end
