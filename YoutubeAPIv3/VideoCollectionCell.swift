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
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var videoLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.contentMode = .ScaleToFill
        title.textAlignment = .Left
        channelTitle.textAlignment = .Left
        viewCount.textAlignment = .Left
        videoLength.layer.borderColor = UIColor.blackColor().CGColor
        videoLength.layer.borderWidth = 1.0
        videoLength.backgroundColor = UIColor.blackColor()
        videoLength.textColor = UIColor.whiteColor()
    }
    
}
