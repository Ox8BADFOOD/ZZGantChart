//
//  ZZGantDataTool.h
//  ZZGantChart_Example
//
//  Created by Max on 2021/11/17.
//  Copyright © 2021 zzb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZGantDataTool : NSObject
+(NSArray<NSDictionary *> *) handleData:(NSString *)dataString fallSleepTime:(NSDate *)fallSleepTime;
@end

NS_ASSUME_NONNULL_END
