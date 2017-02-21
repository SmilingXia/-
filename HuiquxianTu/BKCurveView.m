//
//  BKCurveView.m
//  BangKao
//
//  Created by xia on 2017/2/14.
//  Copyright © 2017年 肖杰. All rights reserved.
//
//设置颜色
#define BKCOLOR(x, y, z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

#define labWith 15


#import "BKCurveView.h"

@interface BKCurveView(){
    CGSize selfbounds;
}

@property (nonatomic, strong) UIView *layerHenxian;
@property (nonatomic, strong) UIView *layerShuxian;
//用于绘制形状的 CALayer 的子类
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) CABasicAnimation *animation;

@end

@implementation BKCurveView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //不管先画2条线
        selfbounds = self.bounds.size;
        [self layerPath];
    }
    return self;
}

//画坐标系
- (void)huaZhuobiaoXi{
    
    self.layerShuxian = [[UIView alloc] init];
    self.layerShuxian.frame = CGRectMake(labWith,0,2,selfbounds.height*0.6);
    self.layerShuxian.backgroundColor = BKCOLOR(207, 207, 207);
    [self addSubview:self.layerShuxian];
    
    self.layerHenxian = [[UIView alloc] init];
    self.layerHenxian.frame = CGRectMake(labWith, selfbounds.height*0.6, selfbounds.width - labWith*2, 2);
    self.layerHenxian.backgroundColor = BKCOLOR(207, 207, 207);
    [self addSubview:self.layerHenxian];
}

//
- (void)layerPath{
    //初始化 shapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.lineWidth = 2;
    self.shapeLayer.strokeColor = BKCOLOR(0, 163, 255).CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.shapeLayer];
}

- (void)setXAxisMutabArray:(NSMutableArray *)xAxisMutabArray{
    _xAxisMutabArray = xAxisMutabArray;
}


- (void)setYAxisMutabArray:(NSMutableArray *)yAxisMutabArray{
    _yAxisMutabArray = yAxisMutabArray;
    //取出数组中最大值
    int maxValue = [[_yAxisMutabArray valueForKeyPath:@"@max.intValue"] intValue];
    
    //画坐标系
    [self huaZhuobiaoXi];
    //画左部
    if (maxValue != 0) {
        [self loadYtimeLab:maxValue];
    }else{
        [self loadYtimeLab:(int)_yAxisMutabArray.count];
    }
    
    //画底部
    [self loadXtimeLab];
}

- (void)loadYtimeLab:(int)maxValue{
    self.shapeLayer.path = nil;
    int bijiaoMaxValue = maxValue;
    int pathInt;
    int valueText;
    NSArray *segmentedArray=  [self segmentedWithTotalNumber:maxValue andNumberOfstages:10 andParity:YES];
    if ([[segmentedArray objectAtIndex:0] intValue] > 0) {
        maxValue = [[segmentedArray objectAtIndex:0] intValue];
    }
    int meiciJiadeValue = [[segmentedArray objectAtIndex:1] intValue];
    if (meiciJiadeValue != 0 && maxValue != 0) {
        if (bijiaoMaxValue > maxValue * meiciJiadeValue) {
            maxValue =  maxValue + 1;
        }
        pathInt =  maxValue * meiciJiadeValue;
        valueText = maxValue * meiciJiadeValue;
    }else{
        pathInt = maxValue;
        valueText = maxValue;
    }
    //这里开始画 -- y轴的一个间距
    float yJianjuH = self.layerShuxian.frame.size.height/maxValue;
    for (int y = 0; y <= maxValue; y++) {
        //x得到一个点作为Lab的x位置 y=0  ,y = xJianju*x;
        UILabel *yLab = [[UILabel alloc] init];
        yLab.frame = CGRectMake(CGRectGetMinX(self.layerShuxian.frame) - labWith, yJianjuH*y - yJianjuH/2, labWith, yJianjuH);
        yLab.tag = 2000+valueText;
        yLab.textColor = [UIColor blackColor];
        yLab.textAlignment = NSTextAlignmentCenter;
        yLab.font = [UIFont systemFontOfSize:10.0f];
        yLab.text = [NSString stringWithFormat:@"%d",valueText];
        [self addSubview:yLab];
        //x轴线条准备
        UIView *xXiantiao = [[UIView alloc] init];
        xXiantiao.frame = CGRectMake(labWith,yJianjuH*y,selfbounds.width - labWith*2, 1);
        //画虚线
        [self drawDashLine:xXiantiao lineLength:4 lineSpacing:2 lineColor:BKCOLOR(218, 218, 218)];
        [self addSubview:xXiantiao];
        [self.layer insertSublayer:self.shapeLayer above:xXiantiao.layer];
        valueText = valueText - meiciJiadeValue;
    }
    //折线路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //找坐标点
    int valueX = 0;
    float xJianjuWpath = self.layerHenxian.frame.size.width/(_xAxisMutabArray.count - 1);
    float layerH = self.layerShuxian.frame.size.height;
    float yJianjuHpath = layerH/pathInt;
    
    //三次曲线的开始点与结束点
    CGPoint startPoint;
    CGPoint endPoint;
    
    for (NSString *valueY in _yAxisMutabArray) {
        NSLog(@"当前的坐标是：(%d,%d)",valueX,[valueY intValue]);
        float dangqianY;
        if ([valueY intValue] == 0) {
            dangqianY = 0;
        }else{
            dangqianY = yJianjuHpath*[valueY intValue];
        }
        if (valueX == 0) {
            [path moveToPoint:CGPointMake(labWith, layerH - dangqianY)];
            startPoint = CGPointMake(labWith, layerH - dangqianY);
        }
 
        endPoint = CGPointMake(valueX*xJianjuWpath + labWith, layerH - dangqianY);
        
        [path addCurveToPoint:endPoint controlPoint1:CGPointMake((endPoint.x-startPoint.x)/2+startPoint.x, startPoint.y) controlPoint2:CGPointMake((endPoint.x-startPoint.x)/2+startPoint.x, endPoint.y)];
        
        
        [path addLineToPoint:CGPointMake(valueX*xJianjuWpath + labWith, layerH - dangqianY)];
        
        startPoint = CGPointMake(valueX*xJianjuWpath + labWith, layerH - dangqianY);
        valueX ++;
    }
    self.shapeLayer.path = path.CGPath;
    [self shapeLayerAnimation];
}

- (void)shapeLayerAnimation{
    //动画执行
    self.animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    self.animation.fromValue = @0;
    self.animation.toValue = @1;
    self.animation.duration = 1;
    [self.shapeLayer addAnimation:self.animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

- (void)loadXtimeLab{
    //最大只能为10，不然不好看 -- 记录一个可变变量， 一个不变
    int variable = (int)_xAxisMutabArray.count;
    NSArray *segmentedArray=  [self segmentedWithTotalNumber:variable andNumberOfstages:6 andParity:NO];
    if ([[segmentedArray objectAtIndex:0] intValue] > 0) {
        variable = [[segmentedArray objectAtIndex:0] intValue];
    }
    int meiciJiadeValue = [[segmentedArray objectAtIndex:1] intValue];
    //这里开始画 -- x轴的一个间距 - 大段间距
    float xJianjuW = self.layerHenxian.frame.size.width/variable;
    //这是小的间距
    float xJianjuWpath = self.layerHenxian.frame.size.width/(_xAxisMutabArray.count - 1);
    
    for (int x = 0 ; x <= variable; x++) {
        //x得到一个点作为Lab的x位置 y=0  ,x = xJianju*x;
        UILabel *xLab = [[UILabel alloc] init];
        xLab.tag = 1000+x;
        xLab.textColor = BKCOLOR(175, 175, 175);
        xLab.textAlignment = NSTextAlignmentCenter;
        xLab.font = [UIFont systemFontOfSize:10.0f];
        xLab.frame = CGRectMake(x*meiciJiadeValue*xJianjuWpath - xJianjuW/2 + labWith, CGRectGetMaxY(self.layerHenxian.frame) + 5, xJianjuW, 20);
        [self addSubview:xLab];
        
        if (meiciJiadeValue == 0) {
            xLab.text = [self geShihuaString:[_xAxisMutabArray objectAtIndex:x]];
        }else{
            //判断最后一段是否刚好多
            if (x*meiciJiadeValue > _xAxisMutabArray.count - 1) {
                xLab.text = [self geShihuaString:[_xAxisMutabArray objectAtIndex:_xAxisMutabArray.count - 1]];
                //计算总的多出不能整除的小段数
                int duochuDuan = x*meiciJiadeValue - ((int)_xAxisMutabArray.count - 1);
                xLab.frame = CGRectMake(x*meiciJiadeValue*xJianjuWpath - duochuDuan*xJianjuWpath - xJianjuW/2 + labWith, CGRectGetMaxY(self.layerHenxian.frame) + 5, xJianjuW, 20);
                //view.frame = CGRectMake(x*meiciJiadeValue*xJianjuWpath - duochuDuan*xJianjuWpath + 50, 0, 1, self.layerShuxian.frame.size.height);
            }else{
                xLab.text = [self geShihuaString:[_xAxisMutabArray objectAtIndex:x*meiciJiadeValue]];
            }
        }
    }
}

- (NSArray *)segmentedWithTotalNumber:(int)number andNumberOfstages:(int)segment andParity:(BOOL)isParity{
    if (isParity) {
        if (number%2 != 0) {
            number = number + 1;
        }
    }
    //商 -- 倍数；
    int heliShang = 1;
    if (number > segment) {
        if (number%segment != 0) {
            heliShang = number/segment + 1;
        }else{
            heliShang = number/segment;
        }
        float feng = (float)number/heliShang;
        //向上取整
        int quzheng = ceil(feng);
        return [[NSString stringWithFormat:@"%d,%d",quzheng,heliShang] componentsSeparatedByString:@","];
    }else{
        return [[NSString stringWithFormat:@"%d,%d",number,heliShang] componentsSeparatedByString:@","];
    }
}


/**
 ** 功能 ： 画虚线
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


/**
 *  格式化字符串
 *  取日期的月与日
 */
- (NSString *)geShihuaString:(NSString *)dataString{
    dataString = [dataString substringFromIndex:5];
    
    if ([dataString containsString:@"-"]) {
        dataString= [dataString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    return dataString;
}


@end
