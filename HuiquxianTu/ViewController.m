//
//  ViewController.m
//  HuiquxianTu
//
//  Created by xia on 2017/2/21.
//  Copyright © 2017年 cn.bkw. All rights reserved.
//

#import "ViewController.h"
#import "BKCurveView.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *xArray;
@property (nonatomic, strong) NSArray *yArray;
@property (nonatomic, strong) BKCurveView *bkCurveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建数组
    self.xArray = @[@"2017-01-23", @"2017-01-24", @"2017-01-25",
                        @"2017-01-26", @"2017-01-27", @"2017-01-28",
                        @"2017-01-29", @"2017-01-30", @"2017-01-31",
                        @"2017-02-01", @"2017-02-02", @"2017-02-03",
                        @"2017-02-04", @"2017-02-05", @"2017-02-06",
                        @"2017-02-07", @"2017-02-08", @"2017-02-09",
                        @"2017-02-10", @"2017-02-11", @"2017-02-12",
                        @"2017-02-13", @"2017-02-14", @"2017-02-15",
                        @"2017-02-16", @"2017-02-17", @"2017-02-18",
                        @"2017-02-19", @"2017-02-20", @"2017-02-21"];
    self.yArray = @[@"5",@"6",@"12",@"11",@"44",@"23",@"76",@"33",
                        @"22",@"11",@"67",@"44",@"33",@"44",@"22",@"11",
                        @"66",@"77",@"15",@"34",@"23",@"11",@"44",@"3",
                        @"21",@"54",@"65",@"32",@"12",@"26",];
    
    
    UIButton *kaiShi = [[UIButton alloc] init];
    kaiShi.frame = CGRectMake(self.view.frame.size.width/2 - 25, self.view.frame.size.width/4 - 15, 50, 30);
    kaiShi.backgroundColor = [UIColor darkGrayColor];
    [kaiShi setTitle:@"开始" forState:UIControlStateNormal];
    [kaiShi addTarget:self action:@selector(kaiShiButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kaiShi];
    
    self.bkCurveView = [[BKCurveView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/2, self.view.frame.size.width - 20, self.view.frame.size.height/2)];
    [self.view addSubview:self.bkCurveView];
}

- (void)kaiShiButtonOnclick:(UIButton *)sender{
    //这里如果重复执行首先得把原来的view清空
    //移除曲线趋势图中的子视图
    [self.bkCurveView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.bkCurveView.xAxisMutabArray = (NSMutableArray *)self.xArray;
    self.bkCurveView.yAxisMutabArray = (NSMutableArray *)self.yArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
