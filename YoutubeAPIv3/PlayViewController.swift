//
//  PlayViewController.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/6/9.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBAction func backViewController(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var videoID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(videoID)
        playerView.loadWithVideoId(videoID)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}