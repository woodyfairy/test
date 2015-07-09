//
//  DataController.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/10.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "DataController.h"

@implementation DataController
static DataController *instance = nil;
+(DataController *)instance{
    if (instance == nil) {
        instance = [[DataController alloc] init];
    }
    return instance;
}
//-(NSString *)log{
//    return @"log";
//}

@end
