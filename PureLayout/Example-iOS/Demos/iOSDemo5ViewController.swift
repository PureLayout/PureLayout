//
//  iOSDemo5ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo5ViewController)
class iOSDemo5ViewController: UIViewController {
    
    let blueView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .blueColor()
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.layer.borderWidth = 0.5
        return view
        }()
    let redView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .redColor()
        return view
        }()
    let purpleLabel: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.backgroundColor = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 0.3) // semi-transparent purple
        label.textColor = .whiteColor()
        label.text = "The quick brown fox jumps over the lazy dog"
        return label
        }()

    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(blueView)
        view.addSubview(redView)
        view.addSubview(purpleLabel)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            blueView.autoCenterInSuperview()
            blueView.autoSetDimensionsToSize(CGSize(width: 150.0, height: 150.0))
            
            // Use a cross-attribute constraint to constrain an ALAxis (Horizontal) to an ALEdge (Bottom)
            redView.autoConstrainAttribute(.Horizontal, toAttribute: .Bottom, ofView: blueView)
            
            redView.autoAlignAxis(.Vertical, toSameAxisOfView: blueView)
            redView.autoSetDimensionsToSize(CGSize(width: 50.0, height: 50.0))
            
            // Use another cross-attribute constraint to place the purpleLabel's baseline on the blueView's top edge
            purpleLabel.autoConstrainAttribute(.Baseline, toAttribute: .Top, ofView: blueView)
            
            purpleLabel.autoAlignAxis(.Vertical, toSameAxisOfView: blueView)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
