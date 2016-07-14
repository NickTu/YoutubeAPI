//
//  relatedToVideoTableViewCell.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/10.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class relatedToVideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var videoLength: UILabel!
    @IBOutlet weak var channelTitleHeight: NSLayoutConstraint!
    
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
