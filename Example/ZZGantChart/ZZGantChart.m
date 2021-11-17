//
//  ZZGantChart.m
//  ZZGantChart_Example
//
//  Created by Max on 2021/11/16.
//  Copyright © 2021 zzb. All rights reserved.
//

#import "ZZGantChart.h"
#import "ZZGantDataTool.h"

@interface ZZGantChart()
@property(nonatomic,strong) NSArray<UIColor * > *sectionColors;
@property(nonatomic,assign,readwrite) CGFloat bubbleMaxY;
@property(nonatomic,strong) CATextLayer *valueLayer;
/// 气泡土城
@property(nonatomic,strong) CAShapeLayer *bubbleLayer;

/// 虚线图层
@property(nonatomic,strong) CAShapeLayer *dashLine;

/// 数据源
@property(nonatomic,strong) NSArray<NSDictionary*> *sourceArr;
/// 单位（一分钟）在图像上所占用的宽度
@property(nonatomic,assign) CGFloat unitWidth;
@end

@implementation ZZGantChart

-(CATextLayer *)valueLayer{
    if(!_valueLayer){
        _valueLayer = [CATextLayer layer];
        //set text attributes
        _valueLayer.foregroundColor = [UIColor whiteColor].CGColor;
//        _valueLayer.backgroundColor = [UIColor redColor].CGColor;
        _valueLayer.alignmentMode = kCAAlignmentCenter;
        _valueLayer.wrapped = YES;
        //choose a font
        UIFont *font = [UIFont systemFontOfSize:15];
        //set layer font
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        _valueLayer.font = fontRef;
        _valueLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        
        _valueLayer.string = @"深度睡眠\n03:46-03:53";
    }
    return _valueLayer;
}

-(CAShapeLayer *)dashLine{
    if(!_dashLine){
        _dashLine = [CAShapeLayer layer];
        CGRect shapeRect = CGRectMake(0.0f, 0.0f, 1.0f, self.frame.size.height);
        [_dashLine setBounds:shapeRect];
        [_dashLine setPosition:CGPointMake(0, 0)];
        [_dashLine setFillColor:[[UIColor clearColor] CGColor]];
        [_dashLine setStrokeColor:[[UIColor redColor] CGColor]];
        [_dashLine setLineWidth:1.0f];
        [_dashLine setLineJoin:kCALineJoinRound];
        [_dashLine setLineDashPattern:[NSArray arrayWithObjects:
                                       [NSNumber numberWithInt:5],
                                       [NSNumber numberWithInt:5],nil]];
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, self.frame.size.height - _bubbleMaxY);
        [_dashLine setPath:path];
        CGPathRelease(path);
        _dashLine.hidden = true;
    }
    return _dashLine;
}

/// 气泡
-(CAShapeLayer *)bubbleLayer{
    if(!_bubbleLayer){
        _bubbleLayer = [[CAShapeLayer alloc] init];
//        _bubbleLayer.strokeColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        _bubbleLayer.fillColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        UIBezierPath *bezier = [[UIBezierPath alloc] init];
        bezier.lineWidth = 1;
        bezier.lineCapStyle = kCGLineCapRound;
        bezier.lineJoinStyle = kCGLineJoinRound;
        
        [bezier moveToPoint:CGPointMake(_bubbleWidth, _bubbleHeight - _bubbleRadius)];
        [bezier addArcWithCenter:CGPointMake(_bubbleWidth - _bubbleRadius, _bubbleHeight - _bubbleRadius) radius:_bubbleRadius startAngle:0 endAngle:M_PI/2 clockwise:true];
//        [bezier addLineToPoint:CGPointMake(_bubbleWidth/2 - 5, _bubbleHeight)];
//        [bezier addLineToPoint:CGPointMake(_bubbleWidth/2, _bubbleHeight + _bubbleTriangleHeight)];
//        [bezier addLineToPoint:CGPointMake(_bubbleWidth/2 + 5, _bubbleHeight)];
        [bezier addArcWithCenter:CGPointMake(_bubbleRadius, _bubbleHeight - _bubbleRadius) radius:_bubbleRadius startAngle:M_PI/2 endAngle:M_PI clockwise:true];
        [bezier addArcWithCenter:CGPointMake(_bubbleRadius, _bubbleRadius) radius:_bubbleRadius startAngle:M_PI endAngle:M_PI*3/2 clockwise:true];
        [bezier addArcWithCenter:CGPointMake(_bubbleWidth - _bubbleRadius, _bubbleRadius) radius:_bubbleRadius startAngle:M_PI*3/2 endAngle:M_PI*2 clockwise:true];

        [bezier closePath];
        _bubbleLayer.path = bezier.CGPath;
        _bubbleLayer.hidden = true;
    }
    return _bubbleLayer;
}

-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame colors:@[[UIColor redColor]]];
}

- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray <UIColor *>*)colors{
    if (self == [super initWithFrame:frame]) {
        _bubbleWidth = 150;
        _bubbleHeight = 50;
        _bubbleRadius = 10;
        _bubbleTriangleHeight = 5;
        _bubbleMaxY = _bubbleHeight + _bubbleTriangleHeight;
        _sectionColors = colors;
        [self configUI];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    fallSleepTime = []
        NSString * dateStr = @"2021-11-14 01:55:00";
        NSDate * date = [format dateFromString:dateStr];
        _sourceArr = [ZZGantDataTool handleData:@"" fallSleepTime:date];
        _unitWidth = self.frame.size.width / _sourceArr.count;
    }
    return self;
}

-(void)configUI{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    self.dashLine.frame = CGRectMake(_bubbleWidth/2, _bubbleMaxY, 1, self.frame.size.height - _bubbleMaxY);
    [self.layer addSublayer:self.dashLine];
    self.bubbleLayer.frame = CGRectMake(0, 0, _bubbleWidth, _bubbleHeight + _bubbleTriangleHeight);
    [self.layer addSublayer:self.bubbleLayer];
    CGFloat h = [UIFont systemFontOfSize:15].lineHeight*2 + 10;
    CGFloat top = (self.bubbleLayer.frame.size.height - h) / 2.0;
    self.valueLayer.frame = CGRectMake(0, top, self.bubbleLayer.frame.size.width, h) ;
    [self.bubbleLayer addSublayer:self.valueLayer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveLayersEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveLayersEvent:event];
}

-(void)moveLayersEvent:(UIEvent *)event{
    
    _bubbleLayer.hidden = false;
    _dashLine.hidden = false;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
//    NSLog(@"移动到%@",NSStringFromCGPoint(touchPoint));

    CGFloat newX = touchPoint.x - _bubbleWidth/2.0;
    CGFloat minX = _bubbleWidth / 2.0 - _bubbleWidth/2.0;
    CGFloat maxX = self.frame.size.width - _bubbleWidth / 2.0 - _bubbleWidth/2.0;
    
    if (newX < minX) {
        newX = minX;
    }
    if (newX > maxX) {
        newX = maxX;
        
    }
    CGRect frame = _bubbleLayer.frame;
    _bubbleLayer.frame = CGRectMake(newX, frame.origin.y, frame.size.width, frame.size.height);
    
    CGFloat d_newX = touchPoint.x;
    CGFloat d_minX = 0;
    CGFloat d_maxX = self.frame.size.width;
    
    if (d_newX < d_minX) {
        d_newX = d_minX;
    }
    if (d_newX > d_maxX) {
        d_newX = d_maxX;
        
    }
    _dashLine.frame = CGRectMake(d_newX, _bubbleMaxY, frame.size.width, frame.size.height - _bubbleMaxY);
    
    //    _unitWidth
    int indexInUnit = (int)(d_newX/_unitWidth);
    int index = 0;
    for (int i = 0; i < _sourceArr.count; i++) {
        NSDictionary* item = _sourceArr[i];
        if (indexInUnit < [item[@"end"] intValue] && indexInUnit >= [item[@"star"] intValue]){
            index = i;
        }
    }
    NSString *state = _sourceArr[index][@"str"];
    NSString *timeStar = _sourceArr[index][@"timeStar"];
    NSString *timeEnd = _sourceArr[index][@"timeEnd"];
    _valueLayer.string = [NSString stringWithFormat:@"%@\n%@",state,[NSString stringWithFormat:@"%@-%@",timeStar,timeEnd]];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"触摸结束");
//    _bubbleLayer.hidden = true;
}

-(void)drawRect:(CGRect)rect{
    int itemNum = (int)self.sectionColors.count;
    CGFloat lineWidth = 1;
    CGFloat line_space = rect.size.height / (itemNum + 1);
    CGFloat chartStarY = line_space / 2.0;
    // 横线
    for (int i = 1; i <= itemNum; i++) {
        [self drawLineWidth:lineWidth star:CGPointMake(lineWidth, i*line_space) end:CGPointMake(rect.size.width - lineWidth, line_space * i)];
    }
    // 竖线
    for (int i = 0; i < 2; i++) {
        [self drawLineWidth:lineWidth
                       star:CGPointMake(i*rect.size.width, 0) end:CGPointMake(i*rect.size.width,rect.size.height)];
    }
    
    
    for (int i = 0 ; i < _sourceArr.count; i++) {
        NSDictionary * dic = _sourceArr[i];
        NSInteger yIndex = self.sectionColors.count - 1 - [dic[@"val"] intValue];
        [self drawSquareRect:CGRectMake([dic[@"star"] intValue] * _unitWidth,
                                        chartStarY + yIndex*line_space,
                                        _unitWidth * [dic[@"range"] intValue],
                                        line_space)
                       color:_sectionColors[yIndex]];
    }
    
}

-(void)drawSquareRect:(CGRect)rect color:(UIColor *)color{
    CGContextRef context = UIGraphicsGetCurrentContext();
        //背景颜色设置
//        [[UIColor whiteColor] set];
        CGContextFillRect(context, rect);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);

        //方法3 方形起点-终点
        CGContextAddRect(context, rect);
        //填充
        CGContextSetFillColorWithColor(context, color.CGColor);
        //绘制路径及填充模式
        CGContextDrawPath(context, kCGPathFillStroke);
}

/// 画一条直线
/// @param lineWidth 线的宽度
/// @param pointStar 起始点
/// @param pointEnd 结束点
-(void)drawLineWidth:(CGFloat)lineWidth star:(CGPoint)pointStar end:(CGPoint)pointEnd{
    //获得处理的上下文
       CGContextRef context = UIGraphicsGetCurrentContext();
       //线条宽
       CGContextSetLineWidth(context, lineWidth);
       //线条颜色
       CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); //设置线条颜色第一种方法
       //坐标点数组
       CGPoint aPoints[2];
        aPoints[0] = pointStar;//CGPointMake(rect.origin.x, rect.origin.y);
        aPoints[1] = pointEnd;//CGPointMake((rect.origin.x + rect.size.width), rect.origin.y);
       //添加线 points[]坐标数组，和count大小
       CGContextAddLines(context, aPoints, 2);
       //根据坐标绘制路径
       CGContextDrawPath(context, kCGPathStroke);
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
}

-(void)didMoveToWindow{
    [super didMoveToWindow];
}
@end
