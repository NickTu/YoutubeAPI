//
//  CommonFunction.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/15.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

extension String {
    func matchPattern(patternStr:String)->Bool {
        var isMatch:Bool = false
        do {
            let regex = try NSRegularExpression(pattern: patternStr, options: [.CaseInsensitive])
            let result = regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count))
            
            if (result != nil)
            {
                isMatch = true
            }
        }
        catch {
            isMatch = false
        }
        return isMatch
    }
}

class CommonFunction {
    
    static func callPlayViewController( viewController:UIViewController, details:Dictionary<NSObject, AnyObject>, type:String, cell:VideoCollectionCell) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let playViewController = storyBoard.instantiateViewControllerWithIdentifier("PlayViewController") as! PlayViewController
        
        if type == "video" {
            playViewController.type = "video"
            playViewController.ID = details["videoID"] as! String
        }else {
            playViewController.type = "playlist"
            playViewController.ID = details["playlistID"] as! String
        }
        playViewController.videoTitle = details["title"] as! String
        playViewController.count = cell.viewCount.text
        
        if details["likeCount"] == nil {
            playViewController.likeNumber = "0"
        } else {
            playViewController.likeNumber = details["likeCount"] as! String
        }
        if details["dislikeCount"] == nil {
            playViewController.unlikeNumber = "0"
        } else {
            playViewController.unlikeNumber = details["dislikeCount"] as! String
        }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        viewController.view.window!.layer.addAnimation(transition, forKey: kCATransition)
        viewController.presentViewController(playViewController, animated: false, completion: nil)
        
    }
    
    static func adjustCollectionViewCellSize(cell:VideoCollectionCell,type:String){
        
        if type == "channel" {
            let height = ( cell.frame.size.height - cell.thumbnail.frame.height )/3
            cell.titleHeight.constant = height*2
            cell.channelTitleHeight.constant = 0
            //cell.viewCountHeight.constant = height
        } else {
            cell.thumbnailHeight.constant = cell.frame.size.height/2
            let height = cell.frame.size.height/8
            /*cell.title.frame.size = CGSizeMake(cell.frame.size.width, height*2)
            cell.channelTitle.frame.size = CGSizeMake(cell.frame.size.width, height*2)
            cell.viewCount.frame.size = CGSizeMake(cell.frame.size.width, height*2)*/
            cell.titleHeight.constant = height*2
            cell.channelTitleHeight.constant = height
        }
        
    }
    
    static func showCellData(title:UILabel,channelTitle:UILabel,thumbnail:UIImageView,videoLength:UILabel, details:Dictionary<NSObject, AnyObject>){
        
        thumbnail.contentMode = .ScaleToFill
        title.textAlignment = .Left
        channelTitle.textAlignment = .Left
        
        
        title.sizeToFit()
        channelTitle.sizeToFit()

        if details["title"] == nil {
            title.text = "No title"
        }else {
            title.text = details["title"] as? String
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
        if details["duration"] == nil {
            
            videoLength.text = ""
            videoLength.backgroundColor = UIColor.clearColor()
            
        }else {
            
            videoLength.adjustsFontSizeToFitWidth = true
            videoLength.layer.borderColor = UIColor.blackColor().CGColor
            videoLength.layer.borderWidth = 1.0
            videoLength.backgroundColor = UIColor.blackColor()
            videoLength.textColor = UIColor.whiteColor()
            
            var patternString = details["duration"] as? String
            patternString = (patternString! as NSString).substringFromIndex(2)
            patternString = (patternString! as NSString).substringToIndex((patternString?.characters.count)! - 1)
            if (patternString?.containsString("M") == true) && (patternString?.containsString("H") == true) {
                
                var patternStringArray = patternString?.componentsSeparatedByString("H")
                let hour = patternStringArray!.first
                patternStringArray = patternStringArray!.last!.componentsSeparatedByString("M")
                var minute = patternStringArray!.first
                var sec = patternStringArray!.last
                
                if minute?.characters.count == 1 {
                    minute = "0" + minute!
                }
                if sec?.characters.count == 1 {
                    sec = "0" + sec!
                }
                
                patternString = hour! + ":" + minute! + ":" + sec!
                //print("indexPath.row = \(indexPath.row) patternString = \(hour! + ":" + minute! + ":" + sec!)")
                
            } else if (patternString?.containsString("M") == true) && (patternString?.containsString("H") == false) {
                
                let patternStringArray = patternString!.componentsSeparatedByString("M")
                
                if patternStringArray.count == 1 {
                    
                    patternString = patternStringArray.first! + ":00"
                    //print("indexPath.row = \(indexPath.row) patternString = \(patternStringArray.first! + ":00")")
                    
                }else {
                    
                    let minute = patternStringArray.first
                    var sec = patternStringArray.last
                    
                    if sec?.characters.count == 1 {
                        sec = "0" + sec!
                    }
                    
                    patternString = minute! + ":" + sec!
                    //print("indexPath.row = \(indexPath.row) patternString = \(minute! + ":" + sec!)")
                }
                
            } else if (patternString?.containsString("M") == false) && (patternString?.containsString("H") == true) {
                
                let patternStringArray = patternString!.componentsSeparatedByString("H")
                let hour = patternStringArray.first
                var sec = patternStringArray.last
                
                if sec?.characters.count == 1 {
                    sec = "0" + sec!
                }
                
                patternString = hour! + ":" + sec!
                //print("indexPath.row = \(indexPath.row) patternString = \(hour! + ":" + sec!)")
                
            } else if (patternString?.containsString("M") == false) && (patternString?.containsString("H") == false) {
                
                if patternString?.characters.count == 1 {
                    patternString = "00:0" + patternString!
                }else {
                    patternString = "00:" + patternString!
                }
                //print("indexPath.row = \(indexPath.row) patternString = \("00:" + patternString!)")
                
            }
            
            videoLength.text = patternString
        }
        
    }
    
    static func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.timeoutIntervalForResource = 5
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            //print("completionHandler")
            //let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //print("dispatch_async")
                if response != nil {
                    completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
                    //print("response.statusCode = \( (response as! NSHTTPURLResponse).statusCode ) error = \(error)")
                }else {
                    completion(data: data, HTTPStatusCode: 0, error: error)
                    //print("response = nil error = \(error)")
                }
            })
        })
        
        task.resume()
    }
    
    

    
}
