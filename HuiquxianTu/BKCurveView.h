//
//  BKCurveView.h
//  BangKao
//
//  Created by xia on 2017/2/14.
//  Copyright © 2017年 肖杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKCurveView : UIView

@property (nonatomic, strong) NSMutableArray *xAxisMutabArray;
@property (nonatomic, strong) NSMutableArray *yAxisMutabArray;

/**
 *  功能：计算间隔数
 *  1.传入数的总数
 *  2.传入需要的段数
 *  3.是否进行奇数偶数的操作 yes操作 - no不操作
 *  4.返回 - 合理的段数 - 间隔数  (0段数 1间隔数)
 */
- (NSArray *)segmentedWithTotalNumber:(int)number andNumberOfstages:(int)segment andParity:(BOOL)isParity;

@end
