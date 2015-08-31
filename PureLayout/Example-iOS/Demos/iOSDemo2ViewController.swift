//
//  iOSDemo2ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo2ViewController)
class iOSDemo2ViewController: UIViewController {
    
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
        if (!didSetupConstraints) {
            // Apply a fixed height of 50 pt to two views at once, and a fixed height of 70 pt to another two views
            [redView, yellowView].autoSetViewsDimension(.Height, toSize: 50.0)
            [blueView, greenView].autoSetViewsDimension(.Height, toSize: 70.0)
            
            let views = [redView, blueView, yellowView, greenView]
            
            // Match the widths of all the views
            (views as NSArray).autoMatchViewsDimension(.Width)
            
            // Pin the red view 20 pt from the top layout guide of the view controller
            redView.autoPinToTopLayoutGuideOfViewController(self, withInset: 20.0)
            
            // Loop over the views, attaching the left edge to the previous view's right edge,
            // and the top edge to the previous view's bottom edge
            views.first?.autoPinEdgeToSuperviewEdge(.Left)
            var previousView: UIView?
            for view in views {
                if let previousView = previousView {
                    view.autoPinEdge(.Left, toEdge: .Right, ofView: previousView)
                    view.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView)
                }
                previousView = view
            }
            views.last?.autoPinEdgeToSuperviewEdge(.Right)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
