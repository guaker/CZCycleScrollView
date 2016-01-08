//
//  CZCycleScrollView.h
//  CZCycleScrollView
//
//  Created by guaker on 15/12/29.
//  Copyright © 2015年 guaker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CZCycleScrollViewDelegate;

@interface CZCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView   *_scrollView;
    UIPageControl  *_pageControl;
    NSTimer        *_timer;
    
    NSMutableArray *_curImageArray; //当前显示的图片数组
    NSInteger      _curPage; //当前显示的图片位置
}

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, weak) id<CZCycleScrollViewDelegate> delegate;

@end

@protocol CZCycleScrollViewDelegate <NSObject>

- (void)czCycleScrollView:(CZCycleScrollView *)czCycleScrollView selectedImageViewAtIndex:(NSInteger)index;

@end
