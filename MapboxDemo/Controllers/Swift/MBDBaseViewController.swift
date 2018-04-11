//
//  MBDBaseViewController.swift
//  MapboxDemo
//
//  Created by mapboxchina on 08/04/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

import Foundation



@objc public class MBDBaseViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Map"

        if let splitViewController =  self.splitViewController {
            self.navigationItem.leftItemsSupplementBackButton = true
            self.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        }
    }
}
