//
//  ViewController.swift
//  CZCycleScrollView
//
//  Created by guaker on 2019/11/12.
//  Copyright © 2019 giantcro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CZCycleScrollViewDelegate {
    
    var bannerView: CZCycleScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bannerView = CZCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 16 * 9))
        self.bannerView.delegate = self
        self.view.addSubview(self.bannerView)
        
        //请求数据
        self.requestData()
    }
    
    //MARK: - CZCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: CZCycleScrollView, didSelectItemAt index: Int) {
          print("点击图片\(index)")
      }
    
    func requestData() {
        //设置数据
        self.bannerView.imageArray = ["Image1", "Image2", "Image3", "Image4", "Image5"]
    }
    
    //MARK: - system
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //解决viewWillAppear时出现时轮播图卡在一半的问题
        if (self.bannerView.scrollView.contentOffset.x > UIScreen.main.bounds.width) {
            self.bannerView.scrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * 2, y: 0)
        }
    }

}

