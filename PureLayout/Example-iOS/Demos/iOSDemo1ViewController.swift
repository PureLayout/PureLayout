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
            blueView.autoSetDimensions(to: CGSize(width: 50.0, height: 50.0))
            
            // Red view is positioned at the bottom right corner of the blue view, with the same width, and a height of 40 pt
            redView.autoPinEdge(.top, to: .bottom, of: blueView)
            redView.autoPinEdge(.left, to: .right, of: blueView)
            redView.autoMatch(.width, to: .width, of: blueView)
            redView.autoSetDimension(.height, toSize: 40.0)
            
            // Yellow view is positioned 10 pt below the red view, extending across the screen with 20 pt insets from the edges,
            // and with a fixed height of 25 pt
            yellowView.autoPinEdge(.top, to: .bottom, of: redView, withOffset: 10.0)
            yellowView.autoSetDimension(.height, toSize: 25.0)
            yellowView.autoPinEdge(toSuperviewEdge: .left, withInset: 20.0)
            yellowView.autoPinEdge(toSuperviewEdge: .right, withInset: 20.0)
            
            // Green view is positioned 10 pt below the yellow view, aligned to the vertical axis of its superview,
            // with its height twice the height of the yellow view and its width fixed to 150 pt
            greenView.autoPinEdge(.top, to: .bottom, of: yellowView, withOffset: 10.0)
            greenView.autoAlignAxis(toSuperviewAxis: .vertical)
            greenView.autoMatch(.height, to: .height, of: yellowView, withMultiplier: 2.0)
            greenView.autoSetDimension(.width, toSize: 150.0)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
