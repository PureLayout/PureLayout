//
//  iOSDemo8ViewController.swift
//  PureLayout Example-iOS
//
//  Copyright (c) 2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

import UIKit
import PureLayout

@objc(iOSDemo8ViewController)
class iOSDemo8ViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .lightGray
        return view
        }()
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
        
        view.addSubview(containerView)
        containerView.addSubview(blueView)
        containerView.addSubview(redView)
        containerView.addSubview(yellowView)
        containerView.addSubview(greenView)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            /**
            First, we'll set up some 'good' constraints that work correctly.
            Note that we identify all of the constraints with a short description of what their purpose is - this is a great feature
            to help you document and comment constraints both in the code, and at runtime. If a Required constraint is ever broken,
            it will raise an exception, and you will see these identifiers show up next to the constraint in the console.
            */
            
            NSLayoutConstraint.autoSetIdentifier("Pin Container View Edges") {
                self.containerView.autoPin(toTopLayoutGuideOf: self, withInset: 10.0)
                self.containerView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0), excludingEdge: .top)
            }

            let views: NSArray = [redView, blueView, yellowView, greenView]
            
            (views.autoDistributeViews(along: .vertical, alignedTo: .vertical, withFixedSize: 40.0) as NSArray).autoIdentifyConstraints("Distribute Views Vertically")

            /**
            Note that the -autoIdentify and -autoIdentifyConstraints methods set the identifier, and then return the constraint(s).
            This lets you chain the identifier call right after creating the constraint(s), and still capture a reference to the constraint(s)!
            */
            
            let constraints = (views.autoSetViewsDimension(.width, toSize: 60.0) as NSArray).autoIdentifyConstraints("Set Width of All Views")
            print("Just added \(constraints.count) constraints!") // you can do something with the constraints at this point
            let constraint = redView.autoAlignAxis(toSuperviewAxis: .vertical).autoIdentify("Align Red View to Superview Vertical Axis")
            print("Just added one constraint with the identifier: \(constraint.identifier)") // you can do something with the constraint at this point
            
            /**
            Now, let's add some 'bad' constraints that conflict with one or more of the 'good' constraints above.
            Start by uncommenting one of the below constraints, and running the demo. A constraint exception will be logged
            to the console, because one or more views was over-constrained, and therefore one or more constraints had to be broken.
            But because we have provided human-readable identifiers, notice how easy it is to figure out which constraints are
            conflicting, and which constraint shouldn't be there!
            */
            NSLayoutConstraint.autoSetIdentifier("Bad Constraints That Break Things") {
//                self.redView.autoAlignAxis(.Vertical, toSameAxisOfView: self.view, withOffset: 5.0) // uncomment me and watch things blow up!
                
//                self.redView.autoPinEdgeToSuperviewEdge(.Left) // uncomment me and watch things blow up!
                
//                views.autoSetViewsDimension(.Height, toSize: 50.0) // uncomment me and watch things blow up!
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
