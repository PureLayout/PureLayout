//
//  iOSDemo1ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo1ViewController)
class iOSDemo1ViewController: UIViewController {
    
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
        view.addSubview(redView)
        view.addSubview(yellowView)
        view.addSubview(greenView)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        // Check a flag didSetupConstraints before creating constraints, because this method may be called multiple times, and we
        // only want to create these constraints once. Without this check, the same constraints could be added multiple times,
        // which can hurt performance and cause other issues. See Demo 7 (Animation) for an example of code that runs every time.
        if (!didSetupConstraints) {
            // Blue view is centered on screen, with size {50 pt, 50 pt}
            blueView.autoCenterInSuperview()
            blueView.autoSetDimensionsToSize(CGSize(width: 50.0, height: 50.0))
            
            // Red view is positioned at the bottom right corner of the blue view, with the same width, and a height of 40 pt
            redView.autoPinEdge(.Top, toEdge: .Bottom, ofView: blueView)
            redView.autoPinEdge(.Left, toEdge: .Right, ofView: blueView)
            redView.autoMatchDimension(.Width, toDimension: .Width, ofView: blueView)
            redView.autoSetDimension(.Height, toSize: 40.0)
            
            // Yellow view is positioned 10 pt below the red view, extending across the screen with 20 pt insets from the edges,
            // and with a fixed height of 25 pt
            yellowView.autoPinEdge(.Top, toEdge: .Bottom, ofView: redView, withOffset: 10.0)
            yellowView.autoSetDimension(.Height, toSize: 25.0)
            yellowView.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
            yellowView.autoPinEdgeToSuperviewEdge(.Right, withInset: 20.0)
            
            // Green view is positioned 10 pt below the yellow view, aligned to the vertical axis of its superview,
            // with its height twice the height of the yellow view and its width fixed to 150 pt
            greenView.autoPinEdge(.Top, toEdge: .Bottom, ofView: yellowView, withOffset: 10.0)
            greenView.autoAlignAxisToSuperviewAxis(.Vertical)
            greenView.autoMatchDimension(.Height, toDimension: .Height, ofView: yellowView, withMultiplier: 2.0)
            greenView.autoSetDimension(.Width, toSize: 150.0)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
