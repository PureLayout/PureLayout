//
//  ALiOSDemo2ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemo2ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ALiOSDemo2ViewController ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo2ViewController

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
    if (!self.didSetupConstraints) {
        // Apply a fixed height of 50 pt to two views at once, and a fixed height of 70 pt to another two views
        [@[self.redView, self.yellowView] autoSetViewsDimension:ALDimensionHeight toSize:50.0];
        [@[self.blueView, self.greenView] autoSetViewsDimension:ALDimensionHeight toSize:70.0];
        
        NSArray *views = @[self.redView, self.blueView, self.yellowView, self.greenView];
        
        // Match the widths of all the views
        [views autoMatchViewsDimension:ALDimensionWidth];
        
        // Pin the red view 20 pt from the top layout guide of the view controller
        [self.redView autoPinToTopLayoutGuideOfViewController:self withInset:20.0];
        
        // Loop over the views, attaching the left edge to the previous view's right edge,
        // and the top edge to the previous view's bottom edge
        [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        UIView *previousView = nil;
        for (UIView *view in views) {
            if (previousView) {
                [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView];
                [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView];
            }
            previousView = view;
        }
        [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
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
