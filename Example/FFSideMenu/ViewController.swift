//
//  ViewController.swift
//  FFSideMenu
//
//  Created by fewspider on 10/01/2015.
//  Copyright (c) 2015 fewspider. All rights reserved.
//

import UIKit
import FFSideMenu

class ViewController: FFSideMenuController {


    // MARK: - Action
    @IBAction func toggleLeft(sender: AnyObject) {
        toggleLeftMenu()
    }

    @IBAction func toggleRight(sender: AnyObject) {
        toggleRightMenu()
    }

    // MARK: - Default
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupMenu(  LeftMenuController(),
                    rightMenuViewController: RightMenuController(),
                    leftMenuWidh: nil,
                    rightMenuWidh: nil,
                    enableTap: true,
                    enablePan: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

