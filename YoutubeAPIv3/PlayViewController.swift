//
//  PlayViewController.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/6/9.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController,YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBAction func backViewController(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var videoID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("videoID = \(videoID)")
        playerView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        /* playsinline: 是否在全屏模式下播放
         
         */
        let parater = ["playsinline":1]
        playerView.loadWithVideoId(videoID,playerVars: parater)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        print("playerViewDidBecomeReady")
        playerView.playVideo()
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
    
}