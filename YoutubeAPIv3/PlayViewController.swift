//
//  PlayViewController.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/6/9.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController,YTPlayerViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBAction func backViewController(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var apiKey = "AIzaSyDJFb3a04UYWc0NSdJv07SQ-wf8TFgyI6Y"
    var tableViewDataArray: Dictionary<String,Dictionary<NSObject, AnyObject>> = [:]
    let youtubeNetworkAddress = "https://www.googleapis.com/youtube/v3/"
    var activityIndicator: UIActivityIndicatorView!
    var pageToken:String!
    var hasNextPage:Bool!
    var isScrollSearch:Bool!
    var successCount = 0
    var ID: String!
    var type:String!
    var keyVideoId:Array<String> = []
    var searchSuccessCount = 0
    var parater:Dictionary<String,Int> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ID = \(ID)")
        playerView.delegate = self
        pageToken = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "relatedToVideoTableViewCell",bundle: nil), forCellReuseIdentifier: "idRelatedToVideoTableViewCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2-25, y: playerView.frame.size.height + navigationBar.frame.size.height + 20, width: 50, height: 50)
        view.addSubview(activityIndicator)
        cleanDataAndStartSearch()
        /* playsinline: 是否在全屏模式下播放
         */
        parater = ["playsinline":1]
        if type == "video" {
            navigationBar.topItem?.title = "play"
            playerView.loadWithVideoId(ID,playerVars: parater)
        } else if type == "playlist" {
            navigationBar.topItem?.title = "playlist"
            playerView.loadWithPlaylistId(ID, playerVars: parater)
        } else {
            playerView = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        
        if self.playerView != nil {
            playerView.playVideo()
        }
        
    }
    
    func playerView(playerView: YTPlayerView, didPlayTime playTime: Float) {
        //print("playerView didPlayTime")
    }
    
    func playerView(playerView: YTPlayerView, receivedError error: YTPlayerError) {
        //print("playerView receivedError")
    }
    
    func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState) {
        //print("playerView didChangeToState")
    }
    
    func playerView(playerView: YTPlayerView, didChangeToQuality quality: YTPlaybackQuality) {
        //print("playerView didChangeToQuality")
    }
    
    func cleanDataAndStartSearch(){
        tableViewDataArray.removeAll(keepCapacity: false)
        keyVideoId.removeAll(keepCapacity: false)
        self.tableView.scrollEnabled = false
        self.activityIndicator.startAnimating()
        tableViewTop.constant = activityIndicator.frame.height
        search()
    }
    
    func endSearch(){
        self.activityIndicator.stopAnimating()
        self.tableView.scrollEnabled = true
        tableViewTop.constant = 0
        self.tableView.reloadData()
        isScrollSearch = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset /* 當前frame距離整個ScrollView的偏移量 */
        let bounds = scrollView.bounds
        let size = scrollView.contentSize /* 整個ScrollView的size */
        let inset = scrollView.contentInset /* 整個ScrollView的EdgeInsets */
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance = -bounds.size.height*10/3
        
        if y > (h + CGFloat(reload_distance) ) && !self.isScrollSearch && self.hasNextPage{
            self.isScrollSearch = true
            search()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.height/4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        playerView.stopVideo()
        let details = tableViewDataArray[ keyVideoId[indexPath.row] ]!
        ID = details["videoID"] as! String
        if type == "video" {
            playerView.loadWithVideoId(ID,playerVars: parater)
        } else if type == "playlist" {
            playerView.loadWithPlaylistId(ID, playerVars: parater)
        } else {
            playerView = nil
        }
        
        if self.playerView != nil {
            playerView.playVideo()
        }
        
        self.pageToken = ""
        cleanDataAndStartSearch()

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("idRelatedToVideoTableViewCell", forIndexPath: indexPath) as! relatedToVideoTableViewCell
        let title = cell.title as UILabel
        let channelTitle = cell.channelTitle as UILabel
        let thumbnail = cell.thumbnail as UIImageView
        let videoLength = cell.videoLength as UILabel
        let viewCount = cell.viewCount as UILabel
        let details = tableViewDataArray[ keyVideoId[indexPath.row] ]!
        
        if details["viewCount"] == nil {
            viewCount.text = "No viewCount"
        } else {
            viewCount.text = "viewCount = " + (details["viewCount"] as? String)!
        }

        CommonFunction.showCellData(title,channelTitle: channelTitle,thumbnail: thumbnail,videoLength: videoLength,details: details)        
        
        let height = tableView.frame.size.height/12
        title.frame.size = CGSizeMake(cell.frame.size.width, height)
        channelTitle.frame.size = CGSizeMake(cell.frame.size.width, height)
        viewCount.frame.size = CGSizeMake(cell.frame.size.width, height)
        
        return cell
    }
    
    func search(){
        
        var urlStringPageToken:String!
        var urlString:String!
        
        if self.pageToken.characters.count > 0 {
            urlStringPageToken = "&pageToken=\(self.pageToken)"
        }else {
            urlStringPageToken = ""
        }
        self.successCount = 0
        self.searchSuccessCount = 0
        
        if type == "video" {
            urlString = youtubeNetworkAddress + "search?&part=snippet&type=video&maxResults=50&key=\(apiKey)" + urlStringPageToken + "&relatedToVideoId=\(ID)"
        } else {
            urlString = youtubeNetworkAddress + "playlistItems?&part=snippet&maxResults=50&key=\(apiKey)&playlistId=\(ID)" + urlStringPageToken
        }
        
        print("urlString = \(urlString)")
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let targetURL = NSURL(string: urlString)
        
        CommonFunction.performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in

            if HTTPStatusCode == 200 && error == nil {

                do {
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    self.searchSuccessCount = items.count
                    
                    if resultsDict["nextPageToken"] != nil && resultsDict["prevPageToken"] != nil{
                        self.hasNextPage = true
                        self.pageToken = resultsDict["nextPageToken"] as! String
                    }else if resultsDict["nextPageToken"] == nil && resultsDict["prevPageToken"] != nil {
                        self.hasNextPage = false
                        self.pageToken = ""
                    }else if resultsDict["nextPageToken"] != nil && resultsDict["prevPageToken"] == nil {
                        self.hasNextPage = true
                        self.pageToken = resultsDict["nextPageToken"] as! String
                    }
                    
                    for i in 0 ..< items.count {
                        
                        let videoId:String!
                        if self.type == "video" {
                            videoId = (items[i]["id"] as! Dictionary<NSObject, AnyObject>)[ "videoId"] as! String
                        } else {
                            let snippet = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
                            videoId = (snippet["resourceId"] as! Dictionary<NSObject, AnyObject>)[ "videoId"] as! String
                        }
                        self.keyVideoId.append( videoId )
                        self.getVideoDetails( videoId )
                    }
                    
                } catch {
                    print(error)
                }
                
            }else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                self.endSearch()
                if self.type == "video" {
                    print("Error while loading video details: \(error)")
                } else {
                    print("Error while loading playlist details: \(error)")
                }
            }
            
        })
        
    }
    
    func getVideoDetails(id: String) {
        
        var urlString: String!
        
        urlString = youtubeNetworkAddress + "videos?&part=snippet,statistics,contentDetails&key=\(apiKey)&id=\(id)"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let targetURL = NSURL(string: urlString)
        
        CommonFunction.performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    // 將 JSON 資料轉換成字典
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    // 從傳回的資料中取得第一筆字典記錄（通常也只會有一筆記錄）
                    let items: AnyObject! = resultsDict["items"] as AnyObject!
                    if items.count == 1 {
                        let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
                        let snippetDict = firstItemDict["snippet"] as! Dictionary<NSObject, AnyObject>
                        var videoDetailsDict: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
                        let contentDetailsDict = firstItemDict["contentDetails"] as! Dictionary<NSObject, AnyObject>
                        videoDetailsDict["title"] = snippetDict["title"]
                        videoDetailsDict["channelTitle"] = snippetDict["channelTitle"]
                        videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["url"]
                        videoDetailsDict["viewCount"] = (firstItemDict["statistics"] as! Dictionary<NSObject, AnyObject>)["viewCount"]
                        
                        videoDetailsDict["videoID"] = id
                        videoDetailsDict["duration"] = contentDetailsDict["duration"] as! String
                        
                        self.tableViewDataArray[ id ] = videoDetailsDict
                        
                        self.successCount += 1
                        if self.successCount == self.searchSuccessCount {
                            self.endSearch()
                        }
                    }else {
                        print("items.count = \(items.count)")
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("Error = \(error)")
                }
                
            } else {
                
                print("HTTP Status Code = \(HTTPStatusCode)")
                self.endSearch()
                if self.type == "video" {
                    print("Error while loading video details: \(error)")
                } else {
                    print("Error while loading playlist details: \(error)")
                }
                
            }
            
        })
    }


    
}