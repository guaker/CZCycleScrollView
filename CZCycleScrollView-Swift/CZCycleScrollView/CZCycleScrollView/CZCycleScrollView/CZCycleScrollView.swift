//
//  CZCycleScrollView.swift
//  BoneForDoctor
//
//  Created by chenzhen on 2017/4/26.
//  Copyright © 2017年 YuanTe. All rights reserved.
//

import UIKit
//import SDWebImage

//代理
@objc protocol CZCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: CZCycleScrollView, didSelectItemAt index: Int)
}

class CZCycleScrollView: UIView, UIScrollViewDelegate {
    
    weak var delegate: CZCycleScrollViewDelegate?
    
    //[String]自己改成model类型
    var imageArray = [String]() {
        didSet {
            if self.imageArray.isEmpty == false {
                //设置分页控件总页数
                self.pageControl.numberOfPages = self.imageArray.count
                
                //打开srollView
                self.scrollView.isScrollEnabled = true
                
                //刷新图片
                self.reloadData()
                
                //开启定时器
                if self.timer != nil {
                    self.timer!.invalidate()
                    self.timer = nil
                }
                
                //定时器时间可设置成常量
                self.timer = Timer(timeInterval: 6,
                                   target: self,
                                   selector: #selector(autoCycleScroll(timer:)),
                                   userInfo: nil,
                                   repeats: true)
                
                //添加到当前线程中，设置UITrackingRunLoopMode，在页面中点击UI时候不会阻塞定时器
                RunLoop.current.add(self.timer!, forMode: .default)
                RunLoop.current.run(mode: .tracking, before: Date())
            }
        }
    }
    
    var scrollView: UIScrollView!
    
    private var pageControl: UIPageControl!
    private var firstImageView: UIImageView!
    private var secondImageView: UIImageView!
    private var thirdImageView: UIImageView!
    
    private var timer: Timer?
    
    private var curPage = 0 //当前显示的图片位置
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //背景
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.contentSize = CGSize(width: self.bounds.width * 3, height: 0)
        self.scrollView.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        
        //分页
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30))
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.currentPageIndicatorTintColor = .red
        self.pageControl.pageIndicatorTintColor = .white
        self.pageControl.hidesForSinglePage = false
        self.addSubview(self.pageControl)
        
        //图片1
        self.firstImageView = UIImageView(image: UIImage(named: "placeholder_banner"))
        self.firstImageView.frame = CGRect(origin: .zero, size: self.bounds.size)
        self.firstImageView.contentMode = .scaleAspectFill
        self.firstImageView.clipsToBounds = true
        self.firstImageView.isUserInteractionEnabled = true
        self.firstImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage(tap:))))
        self.scrollView.addSubview(self.firstImageView)
        
        //图片2
        self.secondImageView = UIImageView(image: UIImage(named: "placeholder_banner"))
        self.secondImageView.frame = CGRect(origin: CGPoint(x: self.bounds.width, y: 0), size: self.bounds.size)
        self.secondImageView.contentMode = .scaleAspectFill
        self.secondImageView.clipsToBounds = true
        self.secondImageView.isUserInteractionEnabled = true
        self.secondImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage(tap:))))
        self.scrollView.addSubview(self.secondImageView)
        
        //图片3
        self.thirdImageView = UIImageView(image: UIImage(named: "placeholder_banner"))
        self.thirdImageView.frame = CGRect(origin: CGPoint(x: self.bounds.width * 2, y: 0), size: self.bounds.size)
        self.thirdImageView.contentMode = .scaleAspectFill
        self.thirdImageView.clipsToBounds = true
        self.thirdImageView.isUserInteractionEnabled = true
        self.thirdImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage(tap:))))
        self.scrollView.addSubview(self.thirdImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
        if scrollView.contentOffset.x >= self.bounds.width * 2 {
            self.curPage += 1
            
            //如果页数超过数组边界，则设置为0
            if self.curPage >= self.imageArray.count {
                self.curPage = 0
            }
        }
            
            //如果scrollView当前偏移位置x小于等于0
        else if scrollView.contentOffset.x <= 0 {
            self.curPage -= 1
            
            //如果页数小于数组边界，则设置为数组最后一张图片下标
            if self.curPage == -1 {
                self.curPage = self.imageArray.count - 1
            }
        } else {
            return
        }
        
        //刷新图片
        self.reloadData()
        
        //设置scrollView偏移位置
        scrollView.setContentOffset(CGPoint(x: self.bounds.width, y: 0), animated: false)
    }
    
    //scrollView结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: self.bounds.width, y: 0), animated: true)
    }
    
    //MARK: - private
    /// 定时器的方法
    ///
    /// - Parameter timer: 定时器
    @objc private func autoCycleScroll(timer: Timer) {
        self.scrollView.setContentOffset(CGPoint(x: self.bounds.width * 2, y: 0), animated: true)
    }
    
    /// tap图片
    ///
    /// - Parameter tap: tap手势
    @objc private func tapImage(tap: UITapGestureRecognizer) {
        self.delegate?.cycleScrollView(self, didSelectItemAt: self.curPage)
    }
    
    /// 刷新数据
    private func reloadData() {
        if self.imageArray.isEmpty == false {
            self.pageControl.currentPage = self.curPage
            
            //根据当前页取出图片
            let curDataArray = self.displayData(page: self.curPage)
                        
            //设置图片
            self.firstImageView.image = UIImage(named: curDataArray[0])
            self.secondImageView.image = UIImage(named: curDataArray[1])
            self.thirdImageView.image = UIImage(named: curDataArray[2])
            
//            self.firstImageView.sd_setImage(with: URL(string: curDataArray[0].image), placeholderImage: UIImage(named: "placeholder_banner"))
//            self.secondImageView.sd_setImage(with: URL(string: curDataArray[1].image), placeholderImage: UIImage(named: "placeholder_banner"))
//            self.thirdImageView.sd_setImage(with: URL(string: curDataArray[2].image), placeholderImage: UIImage(named: "placeholder_banner"))
        }
    }
    
    /// 当前显示的数据
    ///
    /// - Parameter page: 当前页
    /// - Returns: 当前展示的三条数据，自己传model，和self.imageArray类型一致
    private func displayData(page: Int) -> [String] {
        //取出开头和末尾图片在图片数组里的下标
        var front = page - 1
        var last = page + 1
        
        //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
        if (page == 0) {
            front = self.imageArray.count - 1
        }
        
        //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
        if (page == self.imageArray.count - 1) {
            last = 0
        }
        
        return [self.imageArray[front],
                self.imageArray[page],
                self.imageArray[last]]
    }
    
}
