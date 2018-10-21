//
//  ALiOSDemo11ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Spiros Gerokostas
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemo11ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ALiOSDemo11ViewController ()

@property (nonatomic, strong) UILabel *blueLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo11ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.blueLabel];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {

        if (@available(iOS 9.0, *)) {
            [self.scrollView autoPinEdgesToSuperviewSafeAreaWithInsets:UIEdgeInsetsZero];
        } else {
            [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
        
        [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
        [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20.0f];
        [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:20.0f];
        [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView newAutoLayoutView];
    }
    return _scrollView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView newAutoLayoutView];
    }
    return _contentView;
}

- (UILabel *)blueLabel
{
    if (!_blueLabel) {
        _blueLabel = [UILabel newAutoLayoutView];
        _blueLabel.numberOfLines = 0;
        _blueLabel.lineBreakMode = NSLineBreakByClipping;
        _blueLabel.backgroundColor = [UIColor blueColor];
        _blueLabel.textColor = [UIColor whiteColor];
        _blueLabel.text = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", nil);
    }
    return _blueLabel;
}

@end
