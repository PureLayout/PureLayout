//
//  iOSDemo4ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo4ViewController)
class iOSDemo4ViewController: UIViewController {
    
    let blueLabel: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.backgroundColor = .blueColor()
        label.numberOfLines = 1
        label.lineBreakMode = .ByClipping
        label.textColor = .whiteColor()
        label.text = NSLocalizedString("Lorem ipsum", comment: "")
        return label
        }()
    let redLabel: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.backgroundColor = .redColor()
        label.numberOfLines = 0
        label.textColor = .whiteColor()
        label.text = NSLocalizedString("Lorem ipsum", comment: "")
        return label
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
        
        view.addSubview(blueLabel)
        view.addSubview(redLabel)
        view.addSubview(greenView)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        /**
        NOTE: To observe the effect of leading & trailing attributes, you need to change the OS language setting from a left-to-right language,
        such as English, to a right-to-left language, such as Arabic.
        
        This demo project includes localized strings for Arabic, so you will see the Lorem Ipsum text in Arabic if the system is set to that language.
        
        See this method of easily forcing the simulator's language from Xcode: http://stackoverflow.com/questions/8596168/xcode-run-project-with-specified-localization
        */
        
        let smallPadding: CGFloat = 20.0
        let largePadding: CGFloat = 50.0
        
        if (!didSetupConstraints) {
            // Prevent the blueLabel from compressing smaller than required to fit its single line of text
            blueLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
            
            // Position the single-line blueLabel at the top of the screen spanning the width, with some small insets
            blueLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: smallPadding)
            blueLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: smallPadding)
            blueLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: smallPadding)
            
            // Make the redLabel 60% of the width of the blueLabel
            redLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: blueLabel, withMultiplier: 0.6)
            
            // The redLabel is positioned below the blueLabel, with its leading edge to its superview, and trailing edge to the greenView
            redLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: blueLabel, withOffset: smallPadding)
            redLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: smallPadding)
            redLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: largePadding)
            
            // The greenView is positioned below the blueLabel, with its leading edge to the redLabel, and trailing edge to its superview
            greenView.autoPinEdge(.Leading, toEdge: .Trailing, ofView: redLabel, withOffset: largePadding)
            greenView.autoPinEdge(.Top, toEdge: .Bottom, ofView: blueLabel, withOffset: smallPadding)
            greenView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: smallPadding)
            
            // Match the greenView's height to its width (keeping a consistent aspect ratio)
            greenView.autoMatchDimension(.Width, toDimension: .Height, ofView: greenView)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
