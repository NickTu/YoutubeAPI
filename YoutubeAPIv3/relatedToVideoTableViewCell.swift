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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
