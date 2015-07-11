//
//  SpawnController.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/9.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "SpawnController.h"
#import "Common.h"
#import "EnemyBase.h"
#import "Enemy_Triangle.h"
#import "Enemy_Box.h"
#import "Enemy_Circle.h"
#import "Enemy_5Side.h"

@interface SpawnController()
@property (assign) CFTimeInterval mainTimer;

//角落刷新
@property (assign) EnemyType conerSpawnType;
@property (assign) float conerSpawnTimer;
@property (assign) int conerSpawnNum;
@end

@implementation SpawnController
-(instancetype)initWithLevel:(int)level Scene:(GameScene *)scene{
    if ([self init]) {
        _currentLevel = level;
        _maxLevel = 3;
        _currentScene = scene;
        _arrayTimers = [[NSMutableArray alloc] init];
        [self updateLevel];
        return self;
    }
    return nil;
}
-(void) updateLevel{
    while (self.arrayTimers.count < self.currentLevel) {
        [self.arrayTimers addObject:[NSNumber numberWithFloat:0]];
    }
}

-(void)updateWithDelta:(NSTimeInterval)delta{
    //等级增长
    self.mainTimer += delta;
    //NSLog(@"timer:%f",self.timer);
    if (self.mainTimer >= 30) {
        //NSLog(@"spawn!!!");
        self.mainTimer = 0;
        if (_currentLevel < _maxLevel) {
            _currentLevel ++;
            [self updateLevel];
        }
    }
    
    //每个刷新计时
    for (int i = 0; i < _currentLevel; i ++) {
        float timerValue = [[self.arrayTimers objectAtIndex:i] floatValue] + delta;
        if (i == 0) {
            //第一种刷新:随机刷单体
            float freshTime = 1 + self.currentLevel/2;
            if (timerValue >= freshTime) {
                timerValue = 0;
                [self spawnAEnemyWithType:(EnemyType)(1 + getIntRadom(3)) withPosition:[self getRandomPos]];
                //test
                //[self spawnAEnemyWithType:EnemyType_5Side withPosition:[self getRandomPos]];
            }
        }else if (i == 1){
            //第二种刷新:随机刷一个组
            float freshTime = self.currentLevel;
            if (timerValue >= freshTime) {
                timerValue = 0;
                [self spawnAGrouByType:(EnemyType)(1 + getIntRadom(2))];
            }
        }
        else if (i == 2){
            //第二种刷新:四个角刷新大量的一种
            float freshTime = 15;
            if (timerValue >= freshTime) {
                timerValue = 0;
                
                self.conerSpawnType = 3 + getIntRadom(1);
                self.conerSpawnNum = 10 + self.currentLevel * 2;
                self.conerSpawnTimer = 0;
            }
            if (self.conerSpawnNum > 0) {
                self.conerSpawnTimer += delta;
                if (self.conerSpawnTimer >= 0.1f) {
                    self.conerSpawnTimer = 0;
                    self.conerSpawnNum --;
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(-self.currentScene.worldSize.width/2 + 80 - getRandom()*60 , -self.currentScene.worldSize.height/2 + 80 - getRandom()*60)];
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(-self.currentScene.worldSize.width/2 + 80 - getRandom()*60 , self.currentScene.worldSize.height/2 - 80 + getRandom()*60)];
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(self.currentScene.worldSize.width/2 - 80 + getRandom()*60 , -self.currentScene.worldSize.height/2 + 80 - getRandom()*60)];
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(self.currentScene.worldSize.width/2 - 80 + getRandom()*60 , self.currentScene.worldSize.height/2 - 80 + getRandom()*60)];
                }
            }
        }
        [self.arrayTimers replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:timerValue]];
    }
}
-(CGPoint) getRandomPos{
    float inset = 20;
    float width = self.currentScene.worldSize.width - inset * 2;
    float height = self.currentScene.worldSize.height - inset * 2;
    return CGPointMake(getRandom() * width - width/2, getRandom() * height - height/2);
}

-(EnemyBase *)createEnemyByType:(EnemyType)type{
    EnemyBase *enemy = nil;
    if (type == EnemyType_Triangle) {
        enemy = [Enemy_Triangle create];
    }else if (type == EnemyType_Box){
        enemy = [Enemy_Box create];
    }else if (type == EnemyType_Circle){
        enemy = [Enemy_Circle create];
    }else if (type == EnemyType_5Side){
        enemy = [Enemy_5Side create];
    }
    return enemy;
}

-(void)spawnAEnemyWithType:(EnemyType)type withPosition:(CGPoint)position{
    EnemyBase *enemy = [self createEnemyByType:type];
    if (enemy == nil) {
        NSLog(@"Enemy=nil!!! type:%d", type);
        abort();
    }
    [enemy setZRotation:getRandom() * M_PI * 2];
    [enemy spawnInScene:self.currentScene onPosition:position];
    [self.currentScene.arrayEnemies addObject:enemy];
    [self.currentScene.worldPanel addChild:enemy];
}

-(void)spawnAGrouByType:(EnemyType)type{
    SKNode *node = [[SKNode alloc] init];
    int count = 3 + getIntRadom(2);
    float radius = 12;
    float angular = M_PI_2;
    for (int i = 0; i < count; i++) {
        EnemyBase *enemy = [self createEnemyByType:type];
        [enemy setZRotation: angular];
        [enemy spawnInGroup:node onPosition:CGPointMake(cosf(angular) * radius, sinf(angular) * radius)];
        [self.currentScene.arrayEnemies addObject:enemy];
        [node addChild:enemy];
        angular += M_PI * 2 / count;
    }
    [self.currentScene.worldPanel addChild:node];
    [node setPosition:[self getRandomPos]];
    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    [node runAction:[SKAction repeatActionForever:action]];
}

@end
