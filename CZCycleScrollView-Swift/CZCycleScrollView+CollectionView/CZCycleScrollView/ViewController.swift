//
//  ViewController.swift
//  CZCycleScrollView
//
//  Created by guaker on 2019/11/20.
//  Copyright © 2019 giantcro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bannerView: CZCycleScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bannerView = CZCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 16 * 9))
        self.view.addSubview(self.bannerView)
        
        self.requestData()
    }
    
    func requestData() {
        //设置数据
        self.bannerView.imageArray = ["Image1", "Image2", "Image3", "Image4", "Image5"]
    }
    
    //MARK: - system
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //解决viewWillAppear时出现时轮播图卡在一半的问题
        if (self.bannerView.collectionView.contentOffset.x > UIScreen.main.bounds.width) {
            self.bannerView.collectionView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * 2, y: 0)
        }
    }


}

