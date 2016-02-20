//
//  iOSDemo11ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Spiros Gerokostas
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo11ViewController)
class iOSDemo11ViewController: UIViewController {
    
    let scrollView  = UIScrollView.newAutoLayoutView()
    let contentView = UIView.newAutoLayoutView()
    
    let blueLabel: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.backgroundColor = .blueColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByClipping
        label.textColor = .whiteColor()
        label.text = NSLocalizedString("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", comment: "")
        return label
    }()
    
    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(blueLabel)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            
            contentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            contentView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)
            
            blueLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 20)
            blueLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 20)
            blueLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 20)
            blueLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
