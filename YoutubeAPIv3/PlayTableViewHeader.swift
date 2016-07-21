//
//  PlayTableViewHeader.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/21.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import UIKit

class PlayTableViewHeader:UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var unlikeNumber: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var unlikeImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.backgroundColor = UIColor.clearColor()
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "PlayTableViewHeader", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
}