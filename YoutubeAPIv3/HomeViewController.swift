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

    var apiKey = "AIzaSyDJFb3a04UYWc0NSdJv07SQ-wf8TFgyI6Y"
    var collectionDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    let youtubeNetworkAddress = "https://www.googleapis.com/youtube/v3/"
    var activityIndicator: UIActivityIndicatorView!
    var pageToken:String!
    var hasNextPage:Bool!
    var isScrollSearch:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "VideoCollectionCellXib",bundle: nil), forCellWithReuseIdentifier: "idVideoCollectionCell")
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2-25, y: navigationBar.frame.size.height + 20, width: 50, height: 50)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        pageToken = ""
        hasNextPage = true
        isScrollSearch = false
        cleanDataAndStartSearch()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        let details = collectionDataArray[indexPath.row]
        
        title.sizeToFit()
        channelTitle.sizeToFit()
        viewCount.sizeToFit()
        /*title.adjustsFontSizeToFitWidth = true
        channelTitle.adjustsFontSizeToFitWidth = true
        viewCount.adjustsFontSizeToFitWidth = true*/
        
        if details["title"] == nil {
            title.text = "No title"
        }else {
            title.text = details["title"] as? String
        }        
        if details["viewCount"] == nil {
            viewCount.text = "No viewCount"
        } else {
            viewCount.text = "viewCount = " + (details["viewCount"] as? String)!
        }
        if details["thumbnail"] == nil {
            thumbnail.image = UIImage(named: "NoImage")
        } else {
            thumbnail.image = UIImage(data: NSData(contentsOfURL: NSURL(string: (details["thumbnail"] as? String)!)!)!)
        }
        if details["channelTitle"] == nil {
            channelTitle.text = "No channelTitle"
        }else {
            channelTitle.text = details["channelTitle"] as? String
        }
        
        let height = (cell.frame.size.height - thumbnail.frame.size.height)/3
        title.frame.size = CGSizeMake(cell.frame.size.width, height)
        channelTitle.frame.size = CGSizeMake(cell.frame.size.width, height)
        viewCount.frame.size = CGSizeMake(cell.frame.size.width, height)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/2-5, collectionView.frame.height/3)
    }
    
    func search(){
        
        var urlStringPageToken:String!
        
        if self.pageToken.characters.count > 0 {
            urlStringPageToken = "&pageToken=\(self.pageToken)"
        }else {
            urlStringPageToken = ""
        }
        
        var urlString = youtubeNetworkAddress + "videos?&part=snippet,statistics&chart=mostPopular&maxResults=50&key=\(apiKey)" + urlStringPageToken
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let targetURL = NSURL(string: urlString)
        
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in

            if HTTPStatusCode == 200 && error == nil {

                do {
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>

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
                        let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
                        var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                        videoDetailsDict["title"] = snippetDict["title"]
                        videoDetailsDict["channelTitle"] = snippetDict["channelTitle"]
                        videoDetailsDict["viewCount"] = items[i]["statistics"]!["viewCount"]
                        videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                        videoDetailsDict["videoID"] = items[i]["id"] as! String
                        
                        self.collectionDataArray.append(videoDetailsDict)
                    }
                    self.endSearch()
                } catch {
                    print(error)
                }
                
            }else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel videos: \(error)")
            }
            
        })
        
    }
    
    func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {        

        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.timeoutIntervalForResource = 10
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            })
        })
        
        task.resume()
    }
    
}