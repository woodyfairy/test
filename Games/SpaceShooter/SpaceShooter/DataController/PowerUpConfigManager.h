//
//  PowerUpConfigManager.h
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/18.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

//玩家所有的升级默认为0（未升级）
//config
@interface PowerUpConfig : NSObject
@property (strong, nonatomic) NSString *iconName;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int maxLevel;
@property (strong, nonatomic) NSMutableArray *descriptions; //array for nsstring 描述包括0级（初始未升级）－最高级
@property (strong, nonatomic) NSMutableArray *cost; //array for NSNumer 消耗对应当前的等级（比如没升级的时候为0，消耗查第0个）
@end

//manager
@interface PowerUpConfigManager : NSObject
+(PowerUpConfigManager *)instance;
@property (strong, nonatomic) NSMutableArray *arrayConfigs;
-(PowerUpConfig *) getConfigByIndex:(int) index;
@end