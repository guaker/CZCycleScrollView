//
//  CZCycleScrollView.swift
//  CZCycleScrollView
//
//  Created by guaker on 2019/11/20.
//  Copyright © 2019 giantcro. All rights reserved.
//

import UIKit

class CZCycleScrollView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var imageArray = [String]() {
        didSet {
            self.pageControl.numberOfPages = self.imageArray.count
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: false)
        }
    }
    
    var collectionView: UICollectionView!
    
    var pageControl: UIPageControl!
    var timer: Timer?
    var curPage = 1 //当前显示位置
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.collectionView)
        
        self.collectionView.register(CZCycleScrollViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        
        //分页
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30))
        self.pageControl.currentPageIndicatorTintColor = .red
        self.pageControl.pageIndicatorTintColor = .white
        self.pageControl.isUserInteractionEnabled = false
        self.addSubview(self.pageControl)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageArray.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageIndex = self.imageIndex(indexPath.row)
       
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CZCycleScrollViewCell
        
        cell.imageView.image = UIImage(named: self.imageArray[imageIndex])
        
        
        return cell
        
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
//        if scrollView.contentOffset.x > self.bounds.width * CGFloat(self.imageArray.count) {
//            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
//                                             at: .left,
//                                             animated: false)
//        }
//
//            //如果scrollView当前偏移位置x小于等于0
//        else if scrollView.contentOffset.x < self.bounds.width {
//            self.collectionView.scrollToItem(at: IndexPath.init(row: self.imageArray.count - 1, section: 0),
//                                             at: .left,
//                                             animated: false)
//        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
          if scrollView.contentOffset.x > self.bounds.width * CGFloat(self.imageArray.count) {
              self.curPage = 0
          }
            
              //如果scrollView当前偏移位置x小于等于0
          else if scrollView.contentOffset.x < self.bounds.width {
              self.curPage = self.imageArray.count - 1
          } else {
              self.curPage = Int(scrollView.contentOffset.x / self.bounds.width) - 1
          }
          
          self.pageControl.currentPage = self.curPage
      }
    
    
    
    func imageIndex(_ row: Int) -> Int {
        if row == self.imageArray.count + 1 {
            return 0
        } else if row == 0 {
            return self.imageArray.count - 1
        } else {
            return row - 1
        }
    }
    
    
  
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
