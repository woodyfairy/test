//
//  SpawnController.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/9.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"

@interface SpawnController : NSObject
@property (assign) int currentLevel;
@property (assign, readonly) int maxLevel;
@property (weak, readonly) GameScene *currentScene;
-(instancetype)initWithLevel:(int)level Scene:(GameScene *)scene;
-(void)updateWithDelta:(NSTimeInterval)delta;

@end
