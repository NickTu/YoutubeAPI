//
//  SearchViewController.swift
//  YoutubeAPI
//
//  Created by 涂安廷 on 2016/5/29.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var videoCategories: UIBarButtonItem!
    @IBOutlet weak var searchSettings: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchViewConstraint: NSLayoutConstraint!
    
    @IBAction func cancelSearch(sender: UIButton) {
        searchTest = ""
        searchBar.text = ""
        sender.hidden = true
        searchViewConstraint.constant = 0
        searchBar.resignFirstResponder()
    }
    
    var searchTest:String!
    var apiKey = "AIzaSyDJFb3a04UYWc0NSdJv07SQ-wf8TFgyI6Y"
    var collectionDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    var idArray:Array<String> = []
    let youtubeNetworkAddress = "https://www.googleapis.com/youtube/v3/"
    let videoTypeDictionary = [ "All":"0", "Film & Animation":"1", "Autos & Vehicles":"2", "Music":"10", "Pets & Animals":"15", "Sports":"17", "Short Movies":"18", "Travel & Events":"19", "Gaming":"20", "Videoblogging":"21", "People & Blogs":"22", "Comedy":"23", "Entertainment":"24", "News & Politics":"25", "Howto & Style":"26", "Education":"27", "Science & Technology":"28", "Movies":"30", "Anime/Animation":"31", "Action/Adventure":"32", "Classics":"33", "Documentary":"35", "Drama":"36", "Family":"37", "Foreign":"38", "Horror":"39", "Sci-Fi/Fantasy":"40", "Thriller":"41", "Shorts":"42", "Shows":"43", "Trailers":"44" ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "VideoCollectionCellXib",bundle: nil), forCellWithReuseIdentifier: "idVideoCollectionCell")
        searchBar.delegate = self
        cancelSearchButton.hidden = true
        searchViewConstraint.constant = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        collectionDataArray.removeAll(keepCapacity: false)
        self.collectionView.reloadData()
        search(searchBar.text!)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchViewConstraint.constant = cancelSearchButton.frame.size.width
        cancelSearchButton.hidden = false
        searchBar.frame.size.width = view.bounds.width - cancelSearchButton.frame.size.width
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchViewConstraint.constant = 0
        cancelSearchButton.hidden = true
        searchBar.frame.size.width = view.bounds.width
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idVideoCollectionCell", forIndexPath: indexPath) as! VideoCollectionCell
        let title = cell.title as UILabel
        let thumbnail = cell.thumbnail as UIImageView
        let viewCount = cell.viewCount as UILabel
        let details = collectionDataArray[indexPath.row]
        title.text = details["title"] as? String
        viewCount.text = "viewCount = " + (details["viewCount"] as? String)!
        thumbnail.image = UIImage(data: NSData(contentsOfURL: NSURL(string: (details["thumbnail"] as? String)!)!)!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/2-5, collectionView.frame.height/3)
    }
        
    func search(searchTest:String){
        var urlString:String
        var urlStringVideoCategoryId:String!
        var urlStringVideoDurationDimensionDefinition:String!
        if recordSearchSettings.videoType == "All" {
            urlStringVideoCategoryId = ""
            
        }else {
            urlStringVideoCategoryId = "&videoCategoryId=\(videoTypeDictionary[recordSearchSettings.videoType]!)"
        }
        if recordSearchSettings.type == "video" {
            urlStringVideoDurationDimensionDefinition = "&videoDuration=\(recordSearchSettings.videoDuration)&videoDimension=\(recordSearchSettings.videoDimension)&videoDefinition=\(recordSearchSettings.videoDefinition)"
        }else {
            urlStringVideoDurationDimensionDefinition = ""
        }
        
        urlString = youtubeNetworkAddress + "search?&part=snippet&maxResults=50&q=\(searchTest)&type=\(recordSearchSettings.type)&key=\(apiKey)&order=\(recordSearchSettings.order)&regionCode=TW" + urlStringVideoCategoryId + urlStringVideoDurationDimensionDefinition
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let targetURL = NSURL(string: urlString)
        
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                // 將 JSON 資料轉換成字典物件
                do {
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // 取得所有的搜尋結果項目（ items 陣列）
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    // 以迴圈迭代處理所有的搜尋結果，並且只保留所需的資料
                    for i in 0 ..< items.count {
                        self.getVideoDetails( (items[i]["id"] as! Dictionary<NSObject, AnyObject>)[ (recordSearchSettings.type!) + "Id"] as! String)
                    }
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
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            })
        })
        
        task.resume()
    }
    
    func getVideoDetails(idVideo: String) {

        var urlString: String!
        if recordSearchSettings.videoType == "All" {
            urlString = youtubeNetworkAddress + "\(recordSearchSettings.type!)s?&part=snippet,statistics&maxResults=50&key=\(apiKey)&regionCode=TW&id=\(idVideo)"
        }else {
            urlString = youtubeNetworkAddress + "\(recordSearchSettings.type!)s?&part=snippet,statistics&maxResults=50&key=\(apiKey)&regionCode=TW&id=\(idVideo)&videoCategoryId=\(videoTypeDictionary[recordSearchSettings.videoType]!)"
        }
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let targetURL = NSURL(string: urlString)
        
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    // 將 JSON 資料轉換成字典
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // 從傳回的資料中取得第一筆字典記錄（通常也只會有一筆記錄）
                    let items: AnyObject! = resultsDict["items"] as AnyObject!
                    let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
                    
                    // 取得包含所需資料的 snippet 字典
                    let snippetDict = firstItemDict["snippet"] as! Dictionary<NSObject, AnyObject>
                    
                    // 建立新的字典，只儲存我們想要知道的數值
                    var videoDetailsDict: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
                    videoDetailsDict["title"] = snippetDict["title"]
                    videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                    videoDetailsDict["viewCount"] = items[0]["statistics"]!!["viewCount"]
                    
                    self.collectionDataArray.append(videoDetailsDict)
                    self.collectionView.reloadData()
                    
                } catch {
                    print("Error = \(error)")
                }
                
            } else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel details: \(error)")
            }
            
        })
    }
    
}