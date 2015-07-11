//
//  EnemyBase.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/9.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

typedef enum {
    EnemyType_Triangle = 1, //固定不动
    EnemyType_Box = 2, //向玩家移动
    EnemyType_Circle = 3, //向玩家加速
    EnemyType_5Side = 4, //向一个方向
}EnemyType;


@interface EnemyBase : SKSpriteNode
@property (assign, readonly) BOOL isActive;//是否激活？（在刷新阶段、组群中不激活）
@property (assign) float moveSpeed;
@property (assign) float moveAngular;
@property (assign) int score;
@property (assign) int health;
@property (assign) EnemyType type;
//刷在场景中
@property (weak, nonatomic) GameScene *currentScene;
-(void) spawnInScene:(GameScene *) scene onPosition:(CGPoint) pos;
//刷在场景中
@property (weak) SKNode *group;
-(void) spawnInGroup:(SKNode *)group onPosition:(CGPoint) pos;
-(void) breakInGroup:(SKNode *)group toScene:(GameScene *)scene;
//
-(void) spawn;

//子类必须实现的方法
+(instancetype) create;
-(void) createPhysicBody;//给自己加物理
-(void) initData;//初始化各种数据
-(void)updateWithDelta:(NSTimeInterval)delta;
@end


