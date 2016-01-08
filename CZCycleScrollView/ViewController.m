//
//  ViewController.m
//  CZCycleScrollView
//
//  Created by guaker on 15/12/29.
//  Copyright © 2015年 guaker. All rights reserved.
//

#import "ViewController.h"
#import "CZCycleScrollView.h"

@interface ViewController ()<CZCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CZCycleScrollView *cycleScrollView = [[CZCycleScrollView alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.bounds)-40, CGRectGetHeight(self.view.bounds)-40)];
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
    
    NSArray *imageArray = @[[UIImage imageNamed:@"Image01"],
                            [UIImage imageNamed:@"Image02"],
                            [UIImage imageNamed:@"Image03"],
                            [UIImage imageNamed:@"Image04"],
                            [UIImage imageNamed:@"Image05"],
                            [UIImage imageNamed:@"Image06"],
                            [UIImage imageNamed:@"Image07"],
                            [UIImage imageNamed:@"Image08"]];
    cycleScrollView.imageArray = imageArray;
}

- (void)czCycleScrollView:(CZCycleScrollView *)czCycleScrollView selectedImageViewAtIndex:(NSInteger)index
{
    NSLog(@"tap index:%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
