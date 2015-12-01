//
//  TVApp.swift
//  Example-tvOS
//
//  Copyright (c) 2015 Mickey Reiss Fox
//  https://github.com/PureLayout/PureLayout
//
//

import UIKit
import PureLayout

class TVViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let views = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
            .map(TVButton.init)

        views.forEach(self.view.addSubview)

        (views as NSArray).autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Horizontal, withFixedSpacing: 50)
        views.forEach { view in
            view.autoAlignAxisToSuperviewAxis(.Horizontal)
            view.autoSetDimension(.Height, toSize: 300)
        }
    }
}

@UIApplicationMain
class TVAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}

class TVButton : UIControl {
    required init(color: UIColor) {
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
