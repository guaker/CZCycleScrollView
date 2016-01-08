//
//  CZCycleScrollView.m
//  CZCycleScrollView
//
//  Created by guaker on 15/12/29.
//  Copyright © 2015年 guaker. All rights reserved.
//

#import "CZCycleScrollView.h"

#define c_width         (self.bounds.size.width)
#define c_height        (self.bounds.size.height)
#define c_padding       10 //图片之间的间隔
#define c_time_interval 3 //定时器时间

@implementation CZCycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, c_width + c_padding, c_height)];
        _scrollView.contentSize = CGSizeMake((c_width + c_padding) * 3, 0);
        _scrollView.contentOffset = CGPointMake(c_width + c_padding, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, c_height - 30, c_width, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
        
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    
    //设置分页控件的总页数
    _pageControl.numberOfPages = imageArray.count;
    
    //设置scrollView可点
    _scrollView.scrollEnabled = YES;
    
    //刷新图片
    [self reloadData];
    
    //开启定时器
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:c_time_interval
                                     target:self
                                   selector:@selector(timerScrollImage)
                                   userInfo:nil
                                    repeats:YES];
    
    //添加到当前线程中，设置UITrackingRunLoopMode，在页面中点击UI时候不会阻塞定时器
    [[NSRunLoop currentRunLoop] addTimer:_timer
                                 forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode
                             beforeDate:[NSDate date]];
}

//刷新图片
- (void)reloadData
{
    //设置页数
    _pageControl.currentPage = _curPage;
    
    //根据当前页取出图片
    [self getDisplayImagesWithCurpage:_curPage];
    
    //从scrollView上移除所有的subview
    NSArray *subViews = _scrollView.subviews;
    if(subViews.count > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //创建imageView
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((c_width + c_padding) * i, 0, c_width, c_height)];
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        
        //tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tap];
        
        //设置图片
        id curImage = _curImageArray[i];
        if ([curImage isKindOfClass:[UIImage class]]) {
            imageView.image = _curImageArray[i];
        } else if ([curImage isKindOfClass:[NSString class]]) {
            //链接字符串
        } else if ([curImage isKindOfClass:[NSURL class]]) {
            //链接地址
        }
    }
}

//获取图片
- (void)getDisplayImagesWithCurpage:(NSInteger)page
{
    //取出开头和末尾图片在图片数组里的下标
    NSInteger front = page - 1;
    NSInteger last = page + 1;
    
    //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
    if (page == 0) {
        front = self.imageArray.count - 1;
    }
    
    //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
    if (page == self.imageArray.count - 1) {
        last = 0;
    }
    
    //如果当前图片数组不为空，则移除所有元素
    if ([_curImageArray count] > 0) {
        [_curImageArray removeAllObjects];
    }
    
    //当前图片数组添加图片
    [_curImageArray addObject:self.imageArray[front]];
    [_curImageArray addObject:self.imageArray[page]];
    [_curImageArray addObject:self.imageArray[last]];
}

//定时器的方法
- (void)timerScrollImage
{
    //刷新图片
    [self reloadData];
    
    //设置scrollView偏移位置
    [_scrollView setContentOffset:CGPointMake((c_width + c_padding) * 2, 0)
                         animated:YES];
}

//tap图片的方法
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(czCycleScrollView:selectedImageViewAtIndex:)]) {
        [_delegate czCycleScrollView:self
            selectedImageViewAtIndex:_curPage];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
    if (scrollView.contentOffset.x >= (c_width + c_padding) * 2) {
        _curPage++;
        
        //如果页数超过数组边界，则设置为0
        if (_curPage == self.imageArray.count) {
            _curPage = 0;
        }
    }
    
    //如果scrollView当前偏移位置x小于等于0
    else if (scrollView.contentOffset.x <= 0) {
        _curPage--;
        
        //如果页数小于数组边界，则设置为数组最后一张图片下标
        if (_curPage == -1) {
            _curPage = self.imageArray.count - 1;
        }
    } else {
        return;
    }
    
    //刷新图片
    [self reloadData];
    
    //设置scrollView偏移位置
    [scrollView setContentOffset:CGPointMake(c_width + c_padding, 0)];
}

//scrollView结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置scrollView偏移位置
    [scrollView setContentOffset:CGPointMake(c_width + c_padding, 0)
                        animated:YES];
}

@end
