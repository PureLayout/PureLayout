//
//  iOSDemo6ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo6ViewController)
class iOSDemo6ViewController: UIViewController {
    
    let blueView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .blue
        return view
        }()

    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(blueView)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            // Center the blueView in its superview, and match its width to its height
            blueView.autoCenterInSuperview()
            blueView.autoMatch(.width, to: .height, of: blueView)
            
            // Make sure the blueView is always at least 20 pt from any edge
            blueView.autoPin(toTopLayoutGuideOf: self, withInset: 20.0, relation: .greaterThanOrEqual)
            blueView.autoPin(toBottomLayoutGuideOf: self, withInset: 20.0, relation: .greaterThanOrEqual)
            blueView.autoPinEdge(toSuperviewEdge: .left, withInset: 20.0, relation: .greaterThanOrEqual)
            blueView.autoPinEdge(toSuperviewEdge: .right, withInset: 20.0, relation: .greaterThanOrEqual)
            
            // Add constraints that set the size of the blueView to a ridiculously large size, but set the priority of these constraints
            // to a lower value than Required. This allows the Auto Layout solver to let these constraints be broken if one or both of
            // them conflict with higher-priority constraint(s), such as the above 4 edge constraints.
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityDefaultHigh) {
                self.blueView.autoSetDimensions(to: CGSize(width: 10000.0, height: 10000.0))
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
