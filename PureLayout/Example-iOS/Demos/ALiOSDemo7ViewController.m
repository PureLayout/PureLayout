//
//  ALiOSDemo7ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemo7ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ALiOSDemo7ViewController ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;

@property (nonatomic, assign) BOOL didSetupConstraints;

// Tracks the state of the animation: whether we are animating to the end state (YES), or back to the initial state (NO)
@property (nonatomic, assign) BOOL isAnimatingToEndState;

// Store some constraints that we intend to modify as part of the animation
@property (nonatomic, strong) NSLayoutConstraint *blueViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *redViewEdgeConstraint;

@end

@implementation ALiOSDemo7ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.blueView];
    [self.view addSubview:self.redView];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     Start the animation when the view appears. Note that the first initial constraint setup and layout pass has already occurred at this point.
     
     To switch between spring animation and regular animation, comment & uncomment the two lines below!
     (Don't uncomment both lines, one at a time!)
     */
    self.isAnimatingToEndState = YES;
    [self animateLayoutWithSpringAnimation]; // uncomment to use spring animation
//    [self animateLayoutWithRegularAnimation]; // uncomment to use regular animation
}

- (void)updateViewConstraints
{
    static const CGFloat kBlueViewInitialHeight = 40.0;
    static const CGFloat kBlueViewEndHeight = 100.0;
    
    // Remember, this code is just the initial constraint setup which only happens the first time this method is called
    if (!self.didSetupConstraints) {
        [self.blueView autoPinToTopLayoutGuideOfViewController:self withInset:20.0];
        [self.blueView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.blueView autoSetDimension:ALDimensionWidth toSize:50.0];
        self.blueViewHeightConstraint = [self.blueView autoSetDimension:ALDimensionHeight toSize:kBlueViewInitialHeight];
        
        [self.redView autoSetDimension:ALDimensionHeight toSize:50.0];
        [self.redView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.blueView withMultiplier:1.5];
        [self.redView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    
    // Unlike the code above, this is code that will execute every time this method is called.
    // Updating the `constant` property of a constraint is very efficient and can be done without removing/recreating the constraint.
    // Any other changes will require you to remove and re-add new constraints. Make sure to remove constraints before you create new ones!
    [self.redViewEdgeConstraint autoRemove];
    if (self.isAnimatingToEndState) {
        // Adjust constraints to be in the end state for the animation
        self.blueViewHeightConstraint.constant = kBlueViewEndHeight;
        self.redViewEdgeConstraint = [self.redView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:150.0];
    } else {
        // Adjust constraints to be in the initial state for the animation
        self.blueViewHeightConstraint.constant = kBlueViewInitialHeight;
        self.redViewEdgeConstraint = [self.redView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.blueView withOffset:20.0];
    }
    
    [super updateViewConstraints];
}

/**
 See the comments in viewDidAppear: above.
 */
- (void)animateLayoutWithSpringAnimation
{
    // These 2 lines will cause -[updateViewConstraints] to be called again on this view controller, where the constraints will be adjusted to the new state
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         [self.view layoutIfNeeded]; // this is what actually causes the views to animate to their new layout
                     }
                     completion:^(BOOL finished) {
                         // Run the animation again in the other direction
                         self.isAnimatingToEndState = !self.isAnimatingToEndState;
                         if (self.navigationController) { // this will be nil if this view controller is no longer in the navigation stack (stops animation when this view controller is no longer onscreen)
                             [self animateLayoutWithSpringAnimation];
                         }
                     }];
}

/**
 See the comments in viewDidAppear: above.
 */
- (void)animateLayoutWithRegularAnimation
{
    // These 2 lines will cause -[updateViewConstraints] to be called again on this view controller, where the constraints will be adjusted to the new state
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded]; // this is what actually causes the views to animate to their new layout
                     }
                     completion:^(BOOL finished) {
                         // Run the animation again in the other direction
                         self.isAnimatingToEndState = !self.isAnimatingToEndState;
                         if (self.navigationController) { // this will be nil if this view controller is no longer in the navigation stack (stops animation when this view controller is no longer onscreen)
                             [self animateLayoutWithRegularAnimation];
                         }
                     }];
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

@end
