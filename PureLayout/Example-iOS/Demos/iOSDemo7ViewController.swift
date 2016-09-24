//
//  iOSDemo7ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo7ViewController)
class iOSDemo7ViewController: UIViewController {
    
    let blueView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .blue
        return view
        }()
    let redView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .red
        return view
        }()

    var didSetupConstraints = false
    
    // Tracks the state of the animation: whether we are animating to the end state (true), or back to the initial state (false)
    var isAnimatingToEndState = true
    
    // Store some constraints that we intend to modify as part of the animation
    var blueViewHeightConstraint: NSLayoutConstraint?
    var redViewEdgeConstraint: NSLayoutConstraint?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(blueView)
        view.addSubview(redView)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /**
        Start the animation when the view appears. Note that the first initial constraint setup and layout pass has already occurred at this point.
        
        To switch between spring animation and regular animation, comment & uncomment the two lines below!
        (Don't uncomment both lines, one at a time!)
        */
        animateLayoutWithSpringAnimation() // uncomment to use spring animation
//        animateLayoutWithRegularAnimation() // uncomment to use regular animation
    }
    
    override func updateViewConstraints() {
        let blueViewInitialHeight: CGFloat = 40.0
        let blueViewEndHeight: CGFloat = 100.0
        
        // Remember, this code is just the initial constraint setup which only happens the first time this method is called
        if (!didSetupConstraints) {
            blueView.autoPin(toTopLayoutGuideOf: self, withInset: 20.0)
            blueView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            blueView.autoSetDimension(.width, toSize: 50.0)
            blueViewHeightConstraint = blueView.autoSetDimension(.height, toSize: blueViewInitialHeight)
            
            redView.autoSetDimension(.height, toSize: 50.0)
            redView.autoMatch(.width, to: .height, of: blueView, withMultiplier: 1.5)
            redView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            didSetupConstraints = true
        }
        
        // Unlike the code above, this is code that will execute every time this method is called.
        // Updating the `constant` property of a constraint is very efficient and can be done without removing/recreating the constraint.
        // Any other changes will require you to remove and re-add new constraints. Make sure to remove constraints before you create new ones!
        redViewEdgeConstraint?.autoRemove()
        if isAnimatingToEndState {
            blueViewHeightConstraint?.constant = blueViewEndHeight
            redViewEdgeConstraint = redView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 150.0)
        } else {
            blueViewHeightConstraint?.constant = blueViewInitialHeight
            redViewEdgeConstraint = redView.autoPinEdge(.top, to: .bottom, of: blueView, withOffset: 20.0)
        }
        
        super.updateViewConstraints()
    }
    
    /// See the comments in viewDidAppear: above.
    func animateLayoutWithSpringAnimation() {
        
        // These 2 lines will cause updateViewConstraints() to be called again on this view controller, where the constraints will be adjusted to the new state
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(),
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { (finished: Bool) -> Void in
                // Run the animation again in the other direction
                self.isAnimatingToEndState = !self.isAnimatingToEndState
                if (self.navigationController != nil) { // this will be nil if this view controller is no longer in the navigation stack (stops animation when this view controller is no longer onscreen)
                    self.animateLayoutWithSpringAnimation()
                }
        })
    }
    
    /// See the comments in viewDidAppear: above.
    func animateLayoutWithRegularAnimation() {
        
        // These 2 lines will cause updateViewConstraints() to be called again on this view controller, where the constraints will be adjusted to the new state
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions(),
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { (finished: Bool) -> Void in
                // Run the animation again in the other direction
                self.isAnimatingToEndState = !self.isAnimatingToEndState
                if (self.navigationController != nil) { // this will be nil if this view controller is no longer in the navigation stack (stops animation when this view controller is no longer onscreen)
                    self.animateLayoutWithRegularAnimation()
                }
        })
    }
}
