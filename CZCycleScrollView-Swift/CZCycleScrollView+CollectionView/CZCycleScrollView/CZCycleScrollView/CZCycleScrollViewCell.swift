//
//  CZCycleScrollViewCell.swift
//  CZCycleScrollView
//
//  Created by guaker on 2019/11/20.
//  Copyright © 2019 giantcro. All rights reserved.
//

import UIKit

class CZCycleScrollViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(image: UIImage.init(named: "placeholder_banner"))
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
