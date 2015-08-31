//
//  ALiOSDemo8ViewController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemo8ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ALiOSDemo8ViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ALiOSDemo8ViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.blueView];
    [self.containerView addSubview:self.redView];
    [self.containerView addSubview:self.yellowView];
    [self.containerView addSubview:self.greenView];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        /**
         First, we'll set up some 'good' constraints that work correctly.
         Note that we identify all of the constraints with a short description of what their purpose is - this is a great feature
         to help you document and comment constraints both in the code, and at runtime. If a Required constraint is ever broken,
         it will raise an exception, and you will see these identifiers show up next to the constraint in the console.
         */
        
        [NSLayoutConstraint autoSetIdentifier:@"Pin Container View Edges" forConstraints:^{
            [self.containerView autoPinToTopLayoutGuideOfViewController:self withInset:10.0];
            [self.containerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0, 10.0, 10.0, 10.0) excludingEdge:ALEdgeTop];
        }];
        
        NSArray *views = @[self.redView, self.blueView, self.yellowView, self.greenView];
        
        [[views autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSize:40.0] autoIdentifyConstraints:@"Distribute Views Vertically"];
        
        /**
         Note that the -autoIdentify and -autoIdentifyConstraints methods set the identifier, and then return the constraint(s).
         This lets you chain the identifier call right after creating the constraint(s), and still capture a reference to the constraint(s)!
         */
        
        NSArray *constraints = [[views autoSetViewsDimension:ALDimensionWidth toSize:60.0] autoIdentifyConstraints:@"Set Width of All Views"];
        constraints = nil; // you can do something with the constraints at this point
        
        NSLayoutConstraint *constraint = [[self.redView autoAlignAxisToSuperviewAxis:ALAxisVertical] autoIdentify:@"Align Red View to Superview Vertical Axis"];
        constraint = nil; // you can do something with the constraint at this point
        
        /**
         Now, let's add some 'bad' constraints that conflict with one or more of the 'good' constraints above.
         Start by uncommenting one of the below constraints, and running the demo. A constraint exception will be logged
         to the console, because one or more views was over-constrained, and therefore one or more constraints had to be broken.
         But because we have provided human-readable identifiers, notice how easy it is to figure out which constraints are
         conflicting, and which constraint shouldn't be there!
         */
        [NSLayoutConstraint autoSetIdentifier:@"Bad Constraints That Break Things" forConstraints:^{
//            [self.redView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:5.0]; // uncomment me and watch things blow up!
            
//            [self.redView autoPinEdgeToSuperviewEdge:ALEdgeLeft]; // uncomment me and watch things blow up!
            
//            [views autoSetViewsDimension:ALDimensionHeight toSize:50.0]; // uncomment me and watch things blow up!
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView newAutoLayoutView];
        _containerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _containerView;
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
