//
//  ZZGantChart.h
//  ZZGantChart_Example
//
//  Created by Max on 2021/11/16.
//  Copyright © 2021 zzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZGantDataTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZGantChart : UIView

///// 苏醒图表的颜色
//@property(nonatomic,strong) UIColor *awakeColor;
///// 苏醒图表的颜色
//@property(nonatomic,strong) UIColor *looseSleepColor;
///// 苏醒图表的颜色
//@property(nonatomic,strong) UIColor *moveEyesColor;
///// 苏醒图表的颜色
//@property(nonatomic,strong) UIColor *lightSleepColor;
///// 苏醒图表的颜色
//@property(nonatomic,strong) UIColor *deepSleepColor;
/// 气泡的宽度
@property(nonatomic,assign) CGFloat bubbleWidth;
/// 气泡的高度
@property(nonatomic,assign) CGFloat bubbleHeight;
/// 气泡圆角
@property(nonatomic,assign) CGFloat bubbleRadius;
/// 气泡三角尖的高度
@property(nonatomic,assign) CGFloat bubbleTriangleHeight;
/// 气泡最大Y值
@property(nonatomic,assign,readonly) CGFloat bubbleMaxY;
/// 数据源
@property(nonatomic,strong) NSArray<NSDictionary*> *sourceArr;
- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray <UIColor *>*)colors NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
