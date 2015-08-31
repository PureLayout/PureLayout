//
//  ALiOSDemo4ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemo4ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ALiOSDemo4ViewController ()

@property (nonatomic, strong) UILabel *blueLabel;
@property (nonatomic, strong) UILabel *redLabel;
@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo4ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.blueLabel];
    [self.view addSubview:self.redLabel];
    [self.view addSubview:self.greenView];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    static const CGFloat kSmallPadding = 20.0;
    static const CGFloat kLargePadding = 50.0;
    
    /**
     NOTE: To observe the effect of leading & trailing attributes, you need to change the OS language setting from a left-to-right language,
     such as English, to a right-to-left language, such as Arabic.
     
     This demo project includes localized strings for Arabic, so you will see the Lorem Ipsum text in Arabic if the system is set to that language.
     
     See this method of easily forcing the simulator's language from Xcode: http://stackoverflow.com/questions/8596168/xcode-run-project-with-specified-localization
     */
    
    if (!self.didSetupConstraints) {
        // Prevent the blueLabel from compressing smaller than required to fit its single line of text
        [self.blueLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        // Position the single-line blueLabel at the top of the screen spanning the width, with some small insets
        [self.blueLabel autoPinToTopLayoutGuideOfViewController:self withInset:kSmallPadding];
        [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kSmallPadding];
        [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kSmallPadding];
        
        // Make the redLabel 60% of the width of the blueLabel
        [self.redLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.blueLabel withMultiplier:0.6];
        
        // The redLabel is positioned below the blueLabel, with its leading edge to its superview, and trailing edge to the greenView
        [self.redLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.blueLabel withOffset:kSmallPadding];
        [self.redLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kSmallPadding];
        [self.redLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLargePadding];
        
        // The greenView is positioned below the blueLabel, with its leading edge to the redLabel, and trailing edge to its superview
        [self.greenView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.redLabel withOffset:kLargePadding];
        [self.greenView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.blueLabel withOffset:kSmallPadding];
        [self.greenView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kSmallPadding];
        
        // Match the greenView's height to its width (keeping a consistent aspect ratio)
        [self.greenView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.greenView];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (UILabel *)blueLabel
{
    if (!_blueLabel) {
        _blueLabel = [UILabel newAutoLayoutView];
        _blueLabel.numberOfLines = 1;
        _blueLabel.lineBreakMode = NSLineBreakByClipping;
        _blueLabel.backgroundColor = [UIColor blueColor];
        _blueLabel.textColor = [UIColor whiteColor];
        _blueLabel.text = NSLocalizedString(@"Lorem ipsum", nil);
    }
    return _blueLabel;
}

- (UILabel *)redLabel
{
    if (!_redLabel) {
        _redLabel = [UILabel newAutoLayoutView];
        _redLabel.numberOfLines = 0;
        _redLabel.backgroundColor = [UIColor redColor];
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.text = NSLocalizedString(@"Lorem ipsum", nil);
    }
    return _redLabel;
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
