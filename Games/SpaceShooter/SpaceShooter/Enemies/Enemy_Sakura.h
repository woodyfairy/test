//
//  Enemy_Sakura.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/23.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "EnemyBase.h"

typedef enum{
    MoveState_speedUp,
    MoveState_speedDown,
    MoveState_searching,
}MoveState;

@interface Enemy_Sakura : EnemyBase
@property (assign) MoveState state;

@end
