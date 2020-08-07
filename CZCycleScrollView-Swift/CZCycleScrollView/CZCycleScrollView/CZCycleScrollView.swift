//
//  CZCycleScrollView.swift
//  BoneForDoctor
//
//  Created by apple on 2017/4/26.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
//import SDWebImage

//代理
@objc protocol CZCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: CZCycleScrollView, didSelectItemAt index: Int)
}

class CZCycleScrollView: UIView, UIScrollViewDelegate {
    
    weak var delegate: CZCycleScrollViewDelegate?
    
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
    
    private var titleLabel: UILabel!
    private var pageControl: UIPageControl!
    
    private var imageView0: UIImageView!
    private var imageView1: UIImageView!
    private var imageView2: UIImageView!
    
    private var timer: Timer?
    
    private var curPage = 0 //当前显示的图片位置
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupSubviews()
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
            
            self.imageView0.image = UIImage(named: curDataArray[0])
            self.imageView1.image = UIImage(named: curDataArray[1])
            self.imageView2.image = UIImage(named: curDataArray[2])
            
            //设置图片
//            self.imageView0.sd_setImage(with: URL(string: curDataArray[0].imageUrl), placeholderImage: UIImage(named: "placeholder_image"))
//            self.imageView1.sd_setImage(with: URL(string: curDataArray[1].imageUrl), placeholderImage: UIImage(named: "placeholder_image"))
//            self.imageView2.sd_setImage(with: URL(string: curDataArray[2].imageUrl), placeholderImage: UIImage(named: "placeholder_image"))
            
            //设置标题
//            self.titleLabel.text = curDataArray[1].bannerName
            self.titleLabel.text = "自行替换标题或删除布局"
        }
    }
    
    /// 当前显示的数据
    ///
    /// - Parameter page: 当前页
    /// - Returns: 当前展示的三条数据
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
    
    /// UI
    private func setupSubviews() {
        //背景
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.contentSize = CGSize(width: self.bounds.width * 3, height: 0)
        self.scrollView.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        
        //图片0
        self.imageView0 = UIImageView()
        self.imageView0.frame = CGRect(origin: .zero, size: self.bounds.size)
        self.imageView0.contentMode = .scaleAspectFill
        self.imageView0.clipsToBounds = true
        self.imageView0.isUserInteractionEnabled = true
        self.imageView0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage(tap:))))
        self.scrollView.addSubview(self.imageView0)
        
        //图片1
        self.imageView1 = UIImageView()
        self.imageView1.frame = CGRect(origin: CGPoint(x: self.bounds.width, y: 0), size: self.bounds.size)
        self.imageView1.contentMode = .scaleAspectFill
        self.imageView1.clipsToBounds = true
        self.imageView1.isUserInteractionEnabled = true
        self.imageView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage(tap:))))
        self.scrollView.addSubview(self.imageView1)
        
        //图片2
        self.imageView2 = UIImageView()
        self.imageView2.frame = CGRect(origin: CGPoint(x: self.bounds.width * 2, y: 0), size: self.bounds.size)
        self.imageView2.contentMode = .scaleAspectFill
        self.imageView2.clipsToBounds = true
        self.imageView2.isUserInteractionEnabled = true
        self.imageView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage(tap:))))
        self.scrollView.addSubview(self.imageView2)
        
        //autoLayout
        //标题背景
        let titleView = UIView()
        titleView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        titleView.isUserInteractionEnabled = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleView)
        
        //标题
        self.titleLabel = UILabel()
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(self.titleLabel)
        
        //分页
        self.pageControl = UIPageControl()
        self.pageControl.currentPageIndicatorTintColor = .red
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.setContentCompressionResistancePriority(.required, for: .horizontal) //抗压缩
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(self.pageControl)
        
        //设置分页的autoLayout
        let viewsDictionary: [String: UIView] = ["pageControl": self.pageControl,
                                                 "titleView": titleView,
                                                 "titleLabel": titleLabel]
        
        //横向约束 Horizontal
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[titleView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        titleView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-10@999-[titleLabel][pageControl]-10-|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        //纵向约束 Vertical
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[titleView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        titleView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[pageControl]|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        titleView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-10-[titleLabel]-10-|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
