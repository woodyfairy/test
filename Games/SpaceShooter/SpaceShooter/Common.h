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
    PhysicType_player = 1 << 1, //玩家
    PhysicType_bullet = 1 << 2, //子弹
    PhysicType_enermy = 1 << 3, //敌人
    PhysicType_point = 1 << 4, //拾取的点，增长倍数
    PhysicType_gold = 1 << 5, //拾取金币
    
    PhysicType_all = UINT32_MAX,
};

enum FieldType{
    FieldType_none = 0,
    FieldType_player = 1, //玩家的引力，吸引点和金币
    FieldType_blackHole = 1 << 1, //黑洞
    
    FieldType_all = UINT32_MAX,
};

#define UIFontName @"STHeitiTC-Light"// @"Verdana"//

@interface Common : NSObject

@end

float getRandom(); //0-1
int getIntRadom(int max); //0-max