//
//  GameScene.h
//  SpaceShooter
//

//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameControllerView.h"
#import "PlayerSprite.h"

@interface GameScene : SKScene <GameControllerDelegate, SKPhysicsContactDelegate>
+(GameScene *)instance;
@property (assign, nonatomic) CGSize worldSize;
@property (strong, nonatomic) SKShapeNode *worldPanel;
@property (weak, nonatomic) GameControllerView *leftController;
@property (weak, nonatomic) GameControllerView *rightController;

@property (strong, nonatomic) PlayerSprite *player;

@end
