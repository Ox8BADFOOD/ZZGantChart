//
//  ZZViewController.m
//  ZZGantChart
//
//  Created by zzb on 11/16/2021.
//  Copyright (c) 2021 zzb. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZGantChart.h"

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect rect = self.view.frame;
//    rect.size.height
    
    [self.view addSubview:[[ZZGantChart alloc] initWithFrame:CGRectMake(10, 200, rect.size.width - 20, 300) colors:
     @[
        [UIColor colorWithRed:244/255.0 green:153/255.0 blue:136/255.0 alpha:1.0],
        [UIColor colorWithRed:243/255.0 green:199/255.0 blue:80/255.0 alpha:1.0],
        [UIColor colorWithRed:0/255.0 green:211/255.0 blue:180/255.0 alpha:1.0],
        [UIColor colorWithRed:59/255.0 green:219/255.0 blue:243/255.0 alpha:1.0],
        [UIColor colorWithRed:67/255.0 green:177/255.0 blue:255/255.0 alpha:1.0]
        
      ]]];
}


@end
