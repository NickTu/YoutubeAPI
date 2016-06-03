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
    
    let tableKey = ["type","order","videoDuration","videoDimension","videoDefinition"]
    var tableData : Dictionary<String , NSMutableArray> = [:]
    var nowType : Int!
    
    
    override func viewDidLoad() {
        tableData[tableKey[0]] = [ "video", "channel", "playlist" ]
        tableData[tableKey[1]] = [ "date", "rating", "relevance","viewCount" ]
        tableData[tableKey[2]] = [ "any", "long", "medium", "short"]
        tableData[tableKey[3]] = [ "2d", "3d", "any"]
        tableData[tableKey[4]] = [ "any", "high", "standard"]
        tableView.delegate = self
        tableView.dataSource = self
        nowType = tableData[tableKey[0]]?.indexOfObject(recordSearchSettings.type)
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
            nowType = indexPath.row
        case 1:
            lastIndex = NSIndexPath(forRow: (tableData[tableKey[1]]?.indexOfObject(recordSearchSettings.order))! , inSection: indexPath.section)
            recordSearchSettings.order = tableData[tableKey[1]]![indexPath.row] as! String
        case 2:
            lastIndex = NSIndexPath(forRow: (tableData[tableKey[2]]?.indexOfObject(recordSearchSettings.videoDuration))! , inSection: indexPath.section)
            recordSearchSettings.videoDuration = tableData[tableKey[2]]![indexPath.row] as! String
        case 3:
            lastIndex = NSIndexPath(forRow: (tableData[tableKey[3]]?.indexOfObject(recordSearchSettings.videoDimension))! , inSection: indexPath.section)
            recordSearchSettings.videoDimension = tableData[tableKey[3]]![indexPath.row] as! String
        case 4:
            lastIndex = NSIndexPath(forRow: (tableData[tableKey[4]]?.indexOfObject(recordSearchSettings.videoDefinition))! , inSection: indexPath.section)
            recordSearchSettings.videoDefinition = tableData[tableKey[4]]![indexPath.row] as! String
        default:
            lastIndex = nil
            print("Error indexPath.section = \(indexPath.section)")
        }
        
        tableView.cellForRowAtIndexPath(lastIndex!)!.accessoryType = .None
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
        tableView.reloadData()
        
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
        case 2:
            if indexPath.row == (tableData[tableKey[2]]?.indexOfObject(recordSearchSettings.videoDuration))! {
                cell!.accessoryType = .Checkmark
            }else {
                cell!.accessoryType = .None
            }
        case 3:
            if indexPath.row == (tableData[tableKey[3]]?.indexOfObject(recordSearchSettings.videoDimension))! {
                cell!.accessoryType = .Checkmark
            }else {
                cell!.accessoryType = .None
            }
        case 4:
            if indexPath.row == (tableData[tableKey[4]]?.indexOfObject(recordSearchSettings.videoDefinition))! {
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
        if nowType == 0 {
            return tableKey.count
        }else {
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableKey[section]
    }
}