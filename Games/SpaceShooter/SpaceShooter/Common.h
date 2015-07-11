//
//  Common.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/7.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum PhysicType{
    PhysicType_none = 0,
    PhysicType_edge = 1, //边界
    PhysicType_player = 1 << 1,
    PhysicType_bullet = 1 << 2,
    PhysicType_enermy = 1 << 3,
};

@interface Common : NSObject

@end

float getRandom(); //0-1
int getIntRadom(int max); //0-max