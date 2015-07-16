//
//  PlayerSprite.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/3.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerSprite : SKShapeNode

+(PlayerSprite *) create;

@property (assign, nonatomic) float maxSpeed;
@property (assign, nonatomic) int maxLight;
@property (strong, nonatomic) SKEmitterNode *emitter;
@property (assign, nonatomic) float fireInterval;
@property (assign, nonatomic) int fireLevel;
@property (assign, nonatomic) int fireDamage;
@property (assign, nonatomic) BOOL isInvincible;
@end
