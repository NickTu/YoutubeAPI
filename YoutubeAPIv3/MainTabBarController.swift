//
//  MainTabBarController.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/14.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import Foundation

class MainTabbarController:UITabBarController,UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if viewController.isKindOfClass(SearchViewController) {
            (viewController as! SearchViewController).againSearch = false
        }
        
    }
    
}