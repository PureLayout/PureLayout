//
//  iOSDemo10ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo10ViewController)
class iOSDemo10ViewController: UIViewController {
    
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
    let yellowView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .yellow
        return view
        }()
    let greenView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .green
        return view
        }()
    let toggleConstraintsButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("Toggle Constraints", for: UIControlState())
        button.setTitleColor(.white, for: UIControlState())
        button.setTitleColor(.gray, for: .highlighted)
        return button
        }()
    
    var didSetupConstraints = false
    
    // Flag that we use to know which layout we're currently in. We start with the horizontal layout.
    var isHorizontalLayoutActive = true
    
    // Properties to store the constraints for each of the two layouts. Only one set of these will be installed at any given time.
    var horizontalLayoutConstraints: NSArray?
    var verticalLayoutConstraints: NSArray?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(blueView)
        view.addSubview(redView)
        view.addSubview(yellowView)
        view.addSubview(greenView)
        
        view.addSubview(toggleConstraintsButton)
        toggleConstraintsButton.addTarget(self, action: #selector(iOSDemo10ViewController.toggleConstraints(_:)), for: .touchUpInside)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            let views: NSArray = [redView, blueView, yellowView, greenView]
            
            // Create and install the constraints that define the horizontal layout, because this is the one we're starting in.
            // Note that we use autoCreateAndInstallConstraints() here in order to easily collect all the constraints into a single array.
            horizontalLayoutConstraints = NSLayoutConstraint.autoCreateAndInstallConstraints {
                views.autoSetViewsDimension(.height, toSize: 40.0)
                views.autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 10.0, insetSpacing: true, matchedSizes: true)
                self.redView.autoAlignAxis(toSuperviewAxis: .horizontal)
            } as NSArray?
            
            // Create the constraints that define the vertical layout, but don't install any of them - just store them for now.
            // Note that we use autoCreateConstraintsWithoutInstalling() here in order to both prevent the constraints from being installed automatically,
            // and to easily collect all the constraints into a single array.
            verticalLayoutConstraints = NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
                views.autoSetViewsDimension(.width, toSize: 60.0)
                views.autoDistributeViews(along: .vertical, alignedTo: .vertical, withFixedSpacing: 70.0, insetSpacing: true, matchedSizes: true)
                self.redView.autoAlignAxis(toSuperviewAxis: .vertical)
            } as NSArray?
            
            toggleConstraintsButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10.0)
            toggleConstraintsButton.autoAlignAxis(toSuperviewAxis: .vertical)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    /**
    Callback when the "Toggle Constraints" button is tapped.
    */
    func toggleConstraints(_ sender: UIButton) {
        isHorizontalLayoutActive = !isHorizontalLayoutActive
        
        if (isHorizontalLayoutActive) {
            verticalLayoutConstraints?.autoRemoveConstraints()
            horizontalLayoutConstraints?.autoInstallConstraints()
        } else {
            horizontalLayoutConstraints?.autoRemoveConstraints()
            verticalLayoutConstraints?.autoInstallConstraints()
        }
        
        /**
        Uncomment the below code if you want the transitions to be animated!
        */
//        UIView.animateWithDuration(0.2) {
//            self.view.layoutIfNeeded()
//        }
    }
}
