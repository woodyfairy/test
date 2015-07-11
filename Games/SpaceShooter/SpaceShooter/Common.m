//
//  Common.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/7.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Common.h"
#define ARC4RANDOM_MAX      0x100000000

@implementation Common
@end

float getRandom(){
    return (float)arc4random()/ARC4RANDOM_MAX;
}
int getIntRadom(int max){
    return arc4random() % (max + 1);
}