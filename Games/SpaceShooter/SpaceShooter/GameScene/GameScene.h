//
//  GameScene.h
//  SpaceShooter
//

//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameControllerView.h"
@class PlayerSprite;
@class SpawnController;

@interface GameScene : SKScene <GameControllerDelegate, SKPhysicsContactDelegate>
@property (assign, nonatomic) CGSize worldSize;
@property (strong, nonatomic) SKShapeNode *worldPanel;
@property (weak, nonatomic) GameControllerView *leftController;
@property (weak, nonatomic) GameControllerView *rightController;

@property (strong, nonatomic) PlayerSprite *player;
@property (strong, nonatomic) SpawnController *spawnController;
@property (strong, nonatomic) NSMutableArray *arrayEnemies;

@end
