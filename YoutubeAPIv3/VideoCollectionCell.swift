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
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var channelTitleHeight: NSLayoutConstraint!    
    @IBOutlet weak var thumbnailHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
}
