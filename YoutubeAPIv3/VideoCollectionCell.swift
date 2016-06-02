//
//  VideoCollectionCell.swift
//  YoutubeAPI
//
//  Created by 涂安廷 on 2016/5/29.
//  Copyright © 2016年 涂安廷. All rights reserved.
//


import UIKit

class VideoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!  
    @IBOutlet weak var viewCount: UILabel!
    //@IBOutlet weak var top: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.textAlignment = .Center
        //self.top.constant = thumbnail.frame.size.height
    }
    
}
