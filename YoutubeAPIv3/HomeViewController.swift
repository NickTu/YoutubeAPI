//
//  HomeViewController.swift
//  YoutubeAPI
//
//  Created by 涂安廷 on 2016/5/29.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!    
    @IBOutlet weak var item: UINavigationItem!

    var apiKey = "AIzaSyDJFb3a04UYWc0NSdJv07SQ-wf8TFgyI6Y"
    var collectionDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    let youtubeNetworkAddress = "https://www.googleapis.com/youtube/v3/"
    var activityIndicator: UIActivityIndicatorView!
    var pageToken:String!
    var hasNextPage:Bool!
    var isScrollSearch:Bool!
    var isDidLoad:Bool!
    var taskArray:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self        
        collectionView.registerNib(UINib(nibName: "VideoCollectionCellXib",bundle: nil), forCellWithReuseIdentifier: "idVideoCollectionCell")
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2-25, y: navigationBar.frame.size.height + 20, width: 50, height: 50)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        recordSearchSettings.isChangeRegionCode = false
        isDidLoad = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setRegionButton()
        if recordSearchSettings.isChangeRegionCode == true || isDidLoad == true{
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
    
    func setRegionButton(){
        
        let button: UIButton = UIButton(type: .Custom)
        
        button.setImage(UIImage(named: recordSearchSettings.regionCode), forState: .Normal)
        button.addTarget(self, action: #selector(changeRegion), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        item.rightBarButtonItem = barButton
        
    }
    
    func changeRegion(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let regionViewController = storyBoard.instantiateViewControllerWithIdentifier("RegionViewController") as! RegionViewController
        presentViewController(regionViewController, animated: true, completion: nil)
        
    }
    
    func cleanDataAndStartSearch(){
        collectionDataArray.removeAll(keepCapacity: false)
        collectionViewTop.constant = activityIndicator.frame.height
        search()
    }
    
    func endSearch(){
        self.activityIndicator.stopAnimating()
        collectionViewTop.constant = 0
        self.collectionView.reloadData()
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let playViewController = storyBoard.instantiateViewControllerWithIdentifier("PlayViewController") as! PlayViewController
        let details = collectionDataArray[indexPath.row]
        playViewController.type = "video"
        playViewController.ID = details["videoID"] as! String
        presentViewController(playViewController, animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idVideoCollectionCell", forIndexPath: indexPath) as! VideoCollectionCell
        let title = cell.title as UILabel
        let channelTitle = cell.channelTitle as UILabel
        let thumbnail = cell.thumbnail as UIImageView
        let viewCount = cell.viewCount as UILabel
        let videoLength = cell.videoLength as UILabel
        let details = collectionDataArray[indexPath.row]
        
        viewCount.sizeToFit()
        viewCount.textAlignment = .Left
        if details["viewCount"] == nil {
            viewCount.text = "No viewCount"
        } else {
            viewCount.text = "viewCount = " + (details["viewCount"] as? String)!
        }
        
        CommonFunction.showCellData(title,channelTitle: channelTitle,thumbnail: thumbnail,videoLength: videoLength,details: details)
        
        let height = (cell.frame.size.height - thumbnail.frame.size.height)/3
        title.frame.size = CGSizeMake(cell.frame.size.width, height)
        channelTitle.frame.size = CGSizeMake(cell.frame.size.width, height)
        viewCount.frame.size = CGSizeMake(cell.frame.size.width, height)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/2-10, collectionView.frame.height/3)
    }
    
    func search(){
        
        print("Home search")
        var urlStringPageToken:String!
        
        if self.pageToken.characters.count > 0 {
            urlStringPageToken = "&pageToken=\(self.pageToken)"
        }else {
            urlStringPageToken = ""
        }
        
        var urlString = youtubeNetworkAddress + "videos?&part=snippet,statistics,contentDetails&chart=mostPopular&maxResults=50&key=\(apiKey)&regionCode=\(recordSearchSettings.regionCode)" + urlStringPageToken
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        print("Home urlString = \(urlString)")
        let targetURL = NSURL(string: urlString)
        
        CommonFunction.performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in

            if HTTPStatusCode == 200 && error == nil {

                do {
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
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
                    
                    print("Home search total count = \(totalCount)")
                    
                    for i in 0 ..< items.count {
                        let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
                        let contentDetailsDict = items[i]["contentDetails"] as! Dictionary<NSObject, AnyObject>
                        var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                        videoDetailsDict["title"] = snippetDict["title"]
                        videoDetailsDict["channelTitle"] = snippetDict["channelTitle"]
                        videoDetailsDict["viewCount"] = items[i]["statistics"]!["viewCount"]
                        videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["medium"] as! Dictionary<NSObject, AnyObject>)["url"]
                        videoDetailsDict["videoID"] = items[i]["id"] as! String
                        videoDetailsDict["duration"] = contentDetailsDict["duration"] as! String
                        
                        self.collectionDataArray.append(videoDetailsDict)
                    }
                    self.endSearch()
                } catch {
                    print(error)
                }
                
            } else if HTTPStatusCode == 0 && error != nil {
                
                print("Home search End search error = \(error)")
                self.hasNextPage = true
                self.pageToken = ""
                self.isScrollSearch = false
                self.endSearch()
                
            } else {
                print("Home search HTTP Status Code = \(HTTPStatusCode)")
                print("Home search Error while loading channel videos: \(error)")
            }
            
        })
        
    }
    
}