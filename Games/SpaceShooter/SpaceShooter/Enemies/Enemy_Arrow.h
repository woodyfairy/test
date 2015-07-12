//
//  Enemy_Arrow.h
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/12.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "EnemyBase.h"

typedef enum {
    MoveDirection_horizontal,
    MoveDirection_vertical
}MoveDirection;

@interface Enemy_Arrow : EnemyBase
@property (assign) MoveDirection direction;
@property (strong, nonatomic) SKEmitterNode *emitter;

@end
