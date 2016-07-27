//
//  LiveViewController.swift
//  YoutubeAPI
//
//  Created by 涂安廷 on 2016/6/30.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class LiveViewController: UIViewController,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    @IBOutlet var videoType:String!
    
    var searchSuccessCount = 0
    var successCount = 0
    var apiKey = "AIzaSyDJFb3a04UYWc0NSdJv07SQ-wf8TFgyI6Y"
    var collectionDataArray: Dictionary<String,Dictionary<NSObject, AnyObject>> = [:]
    var keyVideoId:Array<String> = []
    let youtubeNetworkAddress = "https://www.googleapis.com/youtube/v3/"
    var activityIndicator: UIActivityIndicatorView!
    var pageToken:String!
    var hasNextPage:Bool!
    var isScrollSearch:Bool!
    var isDidLoad:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "VideoCollectionCellXib",bundle: nil), forCellWithReuseIdentifier: "idVideoCollectionCell")
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.frame = CGRect(x: self.view.bounds.width/4, y: 0, width: 50, height: 50)
        view.addSubview(activityIndicator)
        common.isSearch = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        if common.isSearch == true {
            common.isSearch = false
            isDidLoad = false
            pageToken = ""
            hasNextPage = false
            isScrollSearch = false
            cleanDataAndStartSearch()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if NSThread.currentThread().executing {
            NSThread.currentThread().cancel()
        }
        if NSThread.mainThread().executing {
            NSThread.mainThread().cancel()
        }
    }
    
    func cleanDataAndStartSearch(){
        self.collectionView.scrollEnabled = false
        keyVideoId.removeAll(keepCapacity: false)
        collectionDataArray.removeAll(keepCapacity: false)
        collectionViewTop.constant = activityIndicator.frame.height
        searchLive()
    }
    
    func endSearch(){
        self.activityIndicator.stopAnimating()
        collectionViewTop.constant = 0        
        self.collectionView.reloadData()
        collectionView.setContentOffset(CGPointZero, animated: true)
        self.collectionView.scrollEnabled = true
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
            searchLive()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idVideoCollectionCell", forIndexPath: indexPath) as! VideoCollectionCell
        let title = cell.title as UILabel
        let channelTitle = cell.channelTitle as UILabel
        let thumbnail = cell.thumbnail as UIImageView
        let videoLength = cell.videoLength as UILabel
        let count = cell.viewCount as UILabel
        let details = collectionDataArray[keyVideoId[indexPath.row]]!
        
        if details["concurrentViewers"] == nil {
            count.text = "0 個同步觀看"
        } else {
            count.text = (details["concurrentViewers"] as? String)! + " 個同步觀看"
        }
        count.textAlignment = .Left
        
        CommonFunction.adjustCollectionViewCellSize(cell,type: "video")
        CommonFunction.showCellData(title,channelTitle: channelTitle,thumbnail: thumbnail,videoLength: videoLength,details: details)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {        
        return CGSizeMake(collectionView.frame.width/2-10, common.liveViewHeight/3)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let details = collectionDataArray[keyVideoId[indexPath.row]]!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VideoCollectionCell
        CommonFunction.callPlayViewController( self, details:details, type:"video", cell:cell )
    }
    
    func getNumberOfDaysInMonth(date: NSDate ) -> NSInteger {
        let calendar = NSCalendar.currentCalendar()
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        return range.length
    }
    
    func searchLive(){
        
        print("Live searchLive")
        activityIndicator.startAnimating()
        var urlString:String
        var urlStringPageToken:String!
        var urlStringVideoType:String!
        
        self.successCount = 0
        self.searchSuccessCount = 0
        
        if videoType == nil {
            urlStringVideoType = ""
        }else {
            urlStringVideoType = "&videoCategoryId=\(self.videoType)"
        }
        
        if self.pageToken.characters.count == 0 {
            urlStringPageToken = ""
        }else {
            urlStringPageToken = "&pageToken=\(self.pageToken)"
        }
        
        urlString = youtubeNetworkAddress + "search?&part=snippet&maxResults=50&order=viewCount&type=video&key=\(apiKey)&eventType=live&regionCode=\(countryRegion.regionCode)" + urlStringPageToken + urlStringVideoType
        print("Live searchLive urlString = \(urlString)")
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let targetURL = NSURL(string: urlString)
        
        CommonFunction.performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            
            if HTTPStatusCode == 200 && error == nil {
                // 將 JSON 資料轉換成字典物件
                do {
                    
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    self.searchSuccessCount = items.count
                    
                    let totalCount = (resultsDict["pageInfo"] as! Dictionary<NSObject, AnyObject> )["totalResults"]
                    
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
                    
                    print("Live search total count = \(totalCount)")
                    
                    for i in 0 ..< items.count {
                        let videoId = (items[i]["id"] as! Dictionary<NSObject, AnyObject>)[ (recordSearchSettings.type!) + "Id"] as! String
                        self.getDetails( videoId )
                    }
                    
                    if items.count == 0 {
                        self.endSearch()
                    }
                    
                } catch {
                    print(error)
                }
                
            } else {
                print("Live searchLive HTTP Status Code = \(HTTPStatusCode)")
                print("Live searchLive Error while search live videos: \(error)")
                self.hasNextPage = true
                self.pageToken = ""
                self.isScrollSearch = false
                self.collectionDataArray.removeAll(keepCapacity: false)
                self.endSearch()
            }
            
        })
        
    }
    
    
    func getDetails(id: String) {
        
        //print("Live getDetails")
        var urlString: String!
        
        urlString = youtubeNetworkAddress + "videos?&part=snippet,liveStreamingDetails&key=\(apiKey)&id=\(id)"
        //print("Live getDetails urlString = \(urlString)")
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let targetURL = NSURL(string: urlString)
        
        CommonFunction.performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in

            if HTTPStatusCode == 0 && error != nil {
                //print("self.successCount = \(self.successCount) searchSuccessCount = \(self.searchSuccessCount)")
                self.searchSuccessCount -= 1
                if self.successCount == self.searchSuccessCount {
                    self.endSearch()
                }
            } else if HTTPStatusCode == 200 && error == nil {
                
                do {
                    // 將 JSON 資料轉換成字典
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    // 從傳回的資料中取得第一筆字典記錄（通常也只會有一筆記錄）
                    let items: AnyObject! = resultsDict["items"] as AnyObject!
                    if items.count == 1 {
                        let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
                        //print("firstItemDict = \(firstItemDict)")
                        // 取得包含所需資料的 snippet 字典
                        let snippetDict = firstItemDict["snippet"] as! Dictionary<NSObject, AnyObject>
                        
                        // 建立新的字典，只儲存我們想要知道的數值
                        var videoDetailsDict: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
                        videoDetailsDict["title"] = snippetDict["title"]
                        videoDetailsDict["channelTitle"] = snippetDict["channelTitle"]
                        videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["url"]
                        videoDetailsDict["concurrentViewers"] = (firstItemDict["liveStreamingDetails"] as! Dictionary<NSObject, AnyObject>)["concurrentViewers"]
                        
                        videoDetailsDict["videoID"] = id
                        
                        self.keyVideoId.append( id )
                        self.collectionDataArray[ id ] = videoDetailsDict
                        
                        self.successCount += 1
                        if self.successCount == self.searchSuccessCount {
                            self.endSearch()
                        }
                    }else {
                        self.collectionView.reloadData()
                    }
                    
                } catch {
                    print("Error = \(error)")
                }
                
            } else {
                print("Live getDetails HTTP Status Code = \(HTTPStatusCode)")
                print("Live getDetails Error while loading channel details: \(error)")
            }
            
        })
    }
    
}
