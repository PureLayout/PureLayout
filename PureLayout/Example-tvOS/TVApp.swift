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

        let views = [UIColor.red, UIColor.green, UIColor.blue]
            .map(TVButton.init)

        views.forEach(self.view.addSubview)

        (views as NSArray).autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 50)
        views.forEach { view in
            view.autoAlignAxis(toSuperviewAxis: .horizontal)
            view.autoSetDimension(.height, toSize: 300)
        }
    }
}

@UIApplicationMain
class TVAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}

class TVButton : UIControl {
    required init(color: UIColor) {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
