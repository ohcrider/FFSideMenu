//
//  LeftMenuController.swift
//  FFSideMenu
//
//  Created by fewspider on 15/10/1.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit

class LeftMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var items = [
        [
            "identifier": "testOne",
            "text": "left test one"
        ],
        [
            "identifier": "testTwo",
            "text": "left test two"
        ],
        [
            "identifier": "testThree",
            "text": "left test three"
        ],
        [
            "identifier": "testFour",
            "text": "left test four"
        ],
        [
            "identifier": "testFive",
            "text": "left test Five"
        ],
        [
            "identifier": "testSix",
            "text": "left test Six"
        ],
        [
            "identifier": "testSevent",
            "text": "left test sevent"
        ]

    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        self.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0)
        self.tableView.backgroundColor = UIColor(red:0, green:0.75, blue:1, alpha:1)
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(items[indexPath.row]["identifier"]!, forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = items[indexPath.row]["text"]
        cell.backgroundColor = tableView.backgroundColor

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.yellowColor()
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
