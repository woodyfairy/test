//
//  BlackHole.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/12.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface BlackHole : SKSpriteNode
+(BlackHole *)create;
@property (assign) int score;
@property (assign) int health; //受到多少伤害破掉
@property (assign) int absorbedEnemies; //吸收掉的敌人，吸收掉敌人的血量加到自身上
@property (assign) int getDamage; //当前收到的伤害，大于needDamage+absorbedEnemies时打破
@property (assign) float strength; //0.5-1;有多大

@property (strong) SKEmitterNode *emitter;
@property (strong) SKFieldNode *field;

@property (weak, nonatomic) GameScene *currentScene;
-(void) spawnInScene:(GameScene *) scene withStrength:(float)strength;
-(CGPoint) getRandomPos;

-(void) destroy;

@end
