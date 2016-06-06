//
//  VideoCategories.swift
//  YoutubeAPI
//
//  Created by 涂安廷 on 2016/5/29.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class VideoCategories: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func finishSearchSettings(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
    let tableData = [ "All","Film & Animation", "Autos & Vehicles", "Music", "Pets & Animals", "Sports", "Short Movies", "Travel & Events", "Gaming", "Videoblogging", "People & Blogs", "Comedy", "Entertainment", "News & Politics", "Howto & Style", "Education", "Science & Technology", "Movies", "Anime/Animation", "Action/Adventure", "Classics", "Documentary", "Drama", "Family", "Foreign", "Horror", "Sci-Fi/Fantasy", "Thriller", "Shorts", "Shows", "Trailers" ]
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let lastIndex = NSIndexPath(forRow: tableData.indexOf(recordSearchSettings.videoType)!, inSection: indexPath.section)
        tableView.cellForRowAtIndexPath(lastIndex)!.accessoryType = .None
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
        recordSearchSettings.videoType = tableData[indexPath.row]
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellVideoCategories")
        if indexPath.row == tableData.indexOf(recordSearchSettings.videoType)! {
            cell!.accessoryType = .Checkmark
        }else {
            cell!.accessoryType = .None
        }
        cell!.textLabel?.text = tableData[indexPath.row]
        return cell!
    }
    
}