//
//  iOSDemo3ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo3ViewController)
class iOSDemo3ViewController: UIViewController {
    
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
        if (!didSetupConstraints) {
            let views: NSArray = [redView, blueView, yellowView, greenView]
            
            // Fix all the heights of the views to 40 pt
            views.autoSetViewsDimension(.height, toSize: 40.0)
            
            // Distribute the views horizontally across the screen, aligned to one another's horizontal axis,
            // with 10 pt spacing between them and to their superview, and their widths matched equally
            views.autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 10.0, insetSpacing: true, matchedSizes: true)
            
            // Align the red view to the horizontal axis of its superview.
            // This will end up affecting all the views, since they are all aligned to one another's horizontal axis.
            self.redView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
