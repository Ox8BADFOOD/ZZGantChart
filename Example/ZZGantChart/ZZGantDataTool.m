//
//  ZZGantDataTool.m
//  ZZGantChart_Example
//
//  Created by Max on 2021/11/17.
//  Copyright © 2021 zzb. All rights reserved.
//

#import "ZZGantDataTool.h"

@implementation ZZGantDataTool

+(NSArray<NSDictionary *> *) handleData:(NSString *)dataString fallSleepTime:(NSDate *)fallSleepTime{
    dataString = @"11111010201002102122002101110212210100110100011111101210121211102101100101121010212101101101110121121010010101000111211012012101100201110111211100100101210020110011110002111110011001010110110201210201011111000010112121101010112111012202122112100110202201200221021120122010111121011011100112111201211101112112212121121111";
   
    // 多少分钟
    NSInteger minutesCount = dataString.length;
    NSMutableArray * oneArr = [NSMutableArray array];
    NSString *cacheStr = @"";
    for (int i = 0 ; i < minutesCount; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString * tempStr = [dataString substringWithRange:range];
//        [totalArr addObject:tempStr];
        
        if ([tempStr isEqualToString:cacheStr]) {
            // 连续
            NSMutableDictionary *dic = [oneArr.lastObject mutableCopy];
            dic[@"range"] = @([dic[@"range"] intValue] + 1);
            dic[@"end"] = @([dic[@"star"] intValue] + [dic[@"range"] intValue]);
            dic[@"timeEnd"] = [self getTimeFromTimestamp:([fallSleepTime timeIntervalSince1970] + (i+1)*60)],
            oneArr[oneArr.count - 1] = dic;
        }else{
            // 不连续
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSInteger starTimeIndex = i - 1 > 0 ? i - 1 : 0;
            NSMutableDictionary *dic = [@{
                @"val":tempStr,
                @"star":@(i),
                @"end":@(i + 1),
                // 正数代表有颜色的，负数代表跳过的
                @"range":@1,
                @"timeStar": [self getTimeFromTimestamp:([fallSleepTime timeIntervalSince1970] + i*60)],
                @"timeEnd": [self getTimeFromTimestamp:([fallSleepTime timeIntervalSince1970] + (i+1)*60)]
            } mutableCopy];
            switch ([tempStr intValue]) {
                case 0:
                    dic[@"str"] = @"深度睡眠";
                    break;
                case 1:
                    dic[@"str"] = @"浅度睡眠";
                    break;
                case 2:
                    dic[@"str"] = @"快速眼动";
                    break;
                case 3:
                    dic[@"str"] = @"失眠";
                    break;
                case 4:
                    dic[@"str"] = @"苏醒";
                    break;
                default:
                    break;
            }
            [oneArr addObject:dic];
        }
//        NSLog(@"第%ld个%@",i,tempStr);
        
        cacheStr = tempStr;
    }
    NSLog(@"%@",oneArr);
    return oneArr;
}

/// 将对时间戳转换为NSDate类
/// @param stamp 时间戳
+ (NSString *)getTimeFromTimestamp:(NSTimeInterval)stamp{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:stamp];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}
@end
