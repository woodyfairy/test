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

@interface SpawnController()
@property (assign) CFTimeInterval timer;
@end

@implementation SpawnController
-(instancetype)initWithLevel:(int)level Scene:(GameScene *)scene{
    if ([self init]) {
        _currentLevel = level;
        _maxLevel = 50;
        _currentScene = scene;
        return self;
    }
    return nil;
}

-(void)updateWithDelta:(NSTimeInterval)delta{
    self.timer += delta;
    //NSLog(@"timer:%f",self.timer);
    if (self.timer >= 2) {
        //NSLog(@"spawn!!!");
        self.timer = 0;
        Enemy_Triangle *enemy = [Enemy_Triangle create];
        [enemy spawnInScene:self.currentScene onPosition:[self getRandomPos]];
        [self.currentScene.arrayEnemies addObject:enemy];
        [self.currentScene.worldPanel addChild:enemy];
    }
}
-(CGPoint) getRandomPos{
    float inset = 10;
    float width = self.currentScene.worldSize.width - inset * 2;
    float height = self.currentScene.worldSize.height - inset * 2;
    return CGPointMake(getRandom() * width - width/2, getRandom() * height - height/2);
}

@end
