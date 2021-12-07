//
//  ZZViewController.m
//  ZZGantChart
//
//  Created by zzb on 11/16/2021.
//  Copyright (c) 2021 zzb. All rights reserved.
//

#import "ZZViewController.h"
#import <ZZGantChart/ZZGantChart.h>

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect rect = self.view.frame;
//    rect.size.height
    ZZGantChart *chart = [[ZZGantChart alloc] initWithFrame:CGRectMake(10, 200, rect.size.width - 20, 300) colors:
                          @[
                             [UIColor colorWithRed:244/255.0 green:153/255.0 blue:136/255.0 alpha:1.0],
                             [UIColor colorWithRed:243/255.0 green:199/255.0 blue:80/255.0 alpha:1.0],
                             [UIColor colorWithRed:0/255.0 green:211/255.0 blue:180/255.0 alpha:1.0],
                             [UIColor colorWithRed:59/255.0 green:219/255.0 blue:243/255.0 alpha:1.0],
                             [UIColor colorWithRed:67/255.0 green:177/255.0 blue:255/255.0 alpha:1.0]
                             
    ]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    fallSleepTime = []
        NSString * dateStr = @"2021-11-14 01:55:00";
        NSDate * date = [format dateFromString:dateStr];
        chart.sourceArr = [ZZGantDataTool handleData:@"" fallSleepTime:date];
    });
    
    
    [self.view addSubview:chart];
}


@end
