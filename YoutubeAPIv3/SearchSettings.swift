//
//  SearchSettings.swift
//  YoutubeAPI
//
//  Created by 涂安廷 on 2016/5/29.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class SearchSettings: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func finishSearchSettings(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    let tableKey = ["type","order"]
    var tableData : Dictionary<String , NSMutableArray> = [:]
    
    
    override func viewDidLoad() {
        tableData[tableKey[0]] = [ "video", "channel", "playlist" ]
        tableData[tableKey[1]] = [ "date", "rating", "relevance","viewCount" ]
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData[tableKey[section]]?.count)!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let lastIndex:NSIndexPath!
        switch indexPath.section {
        case 0:
            lastIndex = NSIndexPath(forRow: (tableData[tableKey[0]]?.indexOfObject(recordSearchSettings.type))! , inSection: indexPath.section)
            recordSearchSettings.type = tableData[tableKey[0]]![indexPath.row] as! String
        case 1:
            lastIndex = NSIndexPath(forRow: (tableData[tableKey[1]]?.indexOfObject(recordSearchSettings.order))! , inSection: indexPath.section)
            recordSearchSettings.order = tableData[tableKey[1]]![indexPath.row] as! String

        default:
            lastIndex = nil
            print("Error indexPath.section = \(indexPath.section)")
        }
        
        tableView.cellForRowAtIndexPath(lastIndex!)!.accessoryType = .None
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellSearchSettings")
        switch indexPath.section {
        case 0:
            if indexPath.row == (tableData[tableKey[0]]?.indexOfObject(recordSearchSettings.type))! {
                cell!.accessoryType = .Checkmark
            }else {
                cell!.accessoryType = .None
            }
        case 1:
            if indexPath.row == (tableData[tableKey[1]]?.indexOfObject(recordSearchSettings.order))! {
                cell!.accessoryType = .Checkmark
            }else {
                cell!.accessoryType = .None
            }
        default:
            print("Error indexPath.section = \(indexPath.section)")
        }
        
        cell!.textLabel?.text = tableData[tableKey[indexPath.section]]![indexPath.row] as? String
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableKey.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableKey[section]
    }
}