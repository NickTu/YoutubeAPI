//
//  MainLiveViewController.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/2.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class MainLiveViewController: UIViewController {
    
    
    @IBOutlet weak var liveView: UIView!
    var controllerArray: [UIViewController] = []
    let parameters: [CAPSPageMenuOption] = [
        .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
        .ViewBackgroundColor(UIColor.whiteColor()),
        .SelectionIndicatorColor(UIColor.blackColor()),
        .BottomMenuHairlineColor(UIColor.whiteColor()),
        .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
        .MenuHeight(40.0),
        .MenuItemWidth(90.0),
        .CenterMenuItems(true)
    ]

    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let controller1 : LiveViewController = LiveViewController(nibName: "LiveViewController", bundle: nil)
        controller1.title = "Sports"
        controller1.videoType = "17" //Sports
        controllerArray.append(controller1)
        let controller2 : LiveViewController = LiveViewController(nibName: "LiveViewController", bundle: nil)
        controller2.title = "News"
        controller2.videoType = "25" // News & Politics
        controllerArray.append(controller2)
        let controller3 : LiveViewController = LiveViewController(nibName: "LiveViewController", bundle: nil)
        controller3.title = "Gaming"
        controller3.videoType = "20" // Gaming
        controllerArray.append(controller3)
        let controller4 : LiveViewController = LiveViewController(nibName: "LiveViewController", bundle: nil)
        controller4.title = "Music"
        controller4.videoType = "10" // Music
        controllerArray.append(controller4)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        recordSearchSettings.liveViewHeight = liveView.frame.height
        super.viewDidAppear(animated)
        if pageMenu == nil {
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.bounds.width, self.view.bounds.height), pageMenuOptions: parameters)
        
            self.addChildViewController(pageMenu!)
            self.liveView.addSubview(pageMenu!.view)
        
            pageMenu!.didMoveToParentViewController(self)
        }
        
    }

}
