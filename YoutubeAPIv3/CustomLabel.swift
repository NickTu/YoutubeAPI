//
//  CustomLabel.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/16.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class CustomLabel:UILabel{
    
    override func drawTextInRect(rect: CGRect) {
        print("drawTextInRect")
        let edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
    
}
