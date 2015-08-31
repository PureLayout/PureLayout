//
//  ALiOSDemo5ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemo5ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ALiOSDemo5ViewController ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UILabel *purpleLabel;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo5ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.blueView];
    [self.view addSubview:self.redView];
    [self.view addSubview:self.purpleLabel];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.blueView autoCenterInSuperview];
        [self.blueView autoSetDimensionsToSize:CGSizeMake(150.0, 150.0)];
        
        // Use a cross-attribute constraint to constrain an ALAxis to an ALEdge.
        // Note that it is safe to cast from a more specific type like ALEdge, ALAxis, etc to the more generic type ALAttribute.
        // As such, the below two lines are functionally identical. Use whichever you prefer.
        // [self.redView autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeBottom ofView:self.blueView];
        [self.redView autoConstrainAttribute:(ALAttribute)ALAxisHorizontal toAttribute:(ALAttribute)ALEdgeBottom ofView:self.blueView]; // same as the above commented-out line
        
        [self.redView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.blueView];
        [self.redView autoSetDimensionsToSize:CGSizeMake(50.0, 50.0)];
        
        // Use another cross-attribute constraint to place the purpleLabel's baseline on the blueView's top edge
        [self.purpleLabel autoConstrainAttribute:ALAttributeBaseline toAttribute:ALAttributeTop ofView:self.blueView];
        [self.purpleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.blueView];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (UIView *)blueView
{
    if (!_blueView) {
        _blueView = [UIView newAutoLayoutView];
        _blueView.backgroundColor = [UIColor blueColor];
        _blueView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _blueView.layer.borderWidth = 0.5;
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

- (UILabel *)purpleLabel
{
    if (!_purpleLabel) {
        _purpleLabel = [UILabel newAutoLayoutView];
        _purpleLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:0.3]; // semi-transparent purple
        _purpleLabel.textColor = [UIColor whiteColor];
        _purpleLabel.text = @"The quick brown fox jumps over the lazy dog";
    }
    return _purpleLabel;
}

@end
