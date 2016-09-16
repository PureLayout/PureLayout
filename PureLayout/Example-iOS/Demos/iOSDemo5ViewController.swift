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
        let view = UIView.newAutoLayout()
        view.backgroundColor = .blue
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        return view
        }()
    let redView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .red
        return view
        }()
    let purpleLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.backgroundColor = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 0.3) // semi-transparent purple
        label.textColor = .white
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
            blueView.autoSetDimensions(to: CGSize(width: 150.0, height: 150.0))
            
            // Use a cross-attribute constraint to constrain an ALAxis (Horizontal) to an ALEdge (Bottom)
            redView.autoConstrainAttribute(.horizontal, to: .bottom, of: blueView)
            
            redView.autoAlignAxis(.vertical, toSameAxisOf: blueView)
            redView.autoSetDimensions(to: CGSize(width: 50.0, height: 50.0))
            
            // Use another cross-attribute constraint to place the purpleLabel's baseline on the blueView's top edge
            purpleLabel.autoConstrainAttribute(.baseline, to: .top, of: blueView)
            
            purpleLabel.autoAlignAxis(.vertical, toSameAxisOf: blueView)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
