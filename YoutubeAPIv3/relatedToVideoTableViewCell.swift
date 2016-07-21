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
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    
    @IBOutlet weak var viewCountButtom: NSLayoutConstraint!
    @IBOutlet weak var viewCountTop: NSLayoutConstraint!
    @IBOutlet weak var channelTitleTop: NSLayoutConstraint!
    @IBOutlet weak var channelTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
