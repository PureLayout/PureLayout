//
//  iOSDemo9ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo9ViewController)
class iOSDemo9ViewController: UIViewController {
    
    let blueView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .blueColor()
        return view
        }()
    let redView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .redColor()
        return view
        }()
    let yellowView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .yellowColor()
        return view
        }()
    let greenView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .greenColor()
        return view
        }()

    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(blueView)
        blueView.addSubview(redView)
        redView.addSubview(yellowView)
        yellowView.addSubview(greenView)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            // Before layout margins were introduced, this is a typical way of giving a subview some padding from its superview's edges
            blueView.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
            blueView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 10.0), excludingEdge: .Top)
            
            // Set the layoutMargins of the blueView, which will have an effect on subviews of the blueView that attach to
            // the blueView's margin attributes -- in this case, the redView
            blueView.layoutMargins = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 80.0, right: 20.0)
            redView.autoPinEdgesToSuperviewMargins()
            
            // Let the redView inherit the values we just set for the blueView's layoutMargins by setting the below property to YES.
            // Then, pin the yellowView's edges to the redView's margins, giving the yellowView the same insets from its superview as the redView.
            redView.preservesSuperviewLayoutMargins = true
            yellowView.autoPinEdgeToSuperviewMargin(.Left)
            yellowView.autoPinEdgeToSuperviewMargin(.Right)
            
            // By aligning the yellowView to its superview's horiztonal margin axis, the yellowView will be positioned with its horizontal axis
            // in the middle of the redView's top and bottom margins (causing it to be slightly closer to the top of the redView, since the
            // redView has a much larger bottom margin than top margin).
            yellowView.autoAlignAxisToSuperviewMarginAxis(.Horizontal)
            yellowView.autoMatchDimension(.Height, toDimension: .Height, ofView: redView, withMultiplier: 0.5)
            
            // Since yellowView.preservesSuperviewLayoutMargins is NO by default, it will not preserve (inherit) its superview's margins,
            // and instead will just have the default margins of: {8.0, 8.0, 8.0, 8.0} which will apply to its subviews (greenView)
            greenView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)
            greenView.autoSetDimension(.Height, toSize: 50.0)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
