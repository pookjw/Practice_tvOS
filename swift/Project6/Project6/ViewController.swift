//
//  ViewController.swift
//  Project6
//
//  Created by Jinwoo Kim on 2/11/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UISegmentedControl.appearance().tintColor = .green
        
        let light = UITraitCollection(userInterfaceStyle: .light)
        let dark = UITraitCollection(userInterfaceStyle: .dark)
        
        UISegmentedControl.appearance(for: light).tintColor = .blue
        UISegmentedControl.appearance(for: dark).tintColor = .red
        
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(red: 0.30, green: 0, blue: 0, alpha: 1)
        } else {
            view.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 1, alpha: 1)
        }
    }
}

