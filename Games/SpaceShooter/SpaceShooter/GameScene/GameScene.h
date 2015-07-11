//
//  GameScene.h
//  SpaceShooter
//

//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameControllerView.h"
#import "PlayerSprite.h"
@class SpawnController;

@interface GameScene : SKScene <GameControllerDelegate, SKPhysicsContactDelegate>
@property (assign, nonatomic) CGSize worldSize;
@property (strong, nonatomic) SKShapeNode *worldPanel;
@property (weak, nonatomic) GameControllerView *leftController;
@property (weak, nonatomic) GameControllerView *rightController;
@property (weak, nonatomic) UILabel *scoreLabel;
@property (weak, nonatomic) UILabel *multipleLabel;
@property (weak, nonatomic) UILabel *livesLabel;
@property (weak, nonatomic) UILabel *bombsLabel;
-(void) updateUI;
@property (assign, nonatomic) long score;
@property (assign, nonatomic) int multiple;
@property (assign, nonatomic) short lives;
@property (assign, nonatomic) short bombs;

@property (strong, nonatomic) PlayerSprite *player;
@property (strong, nonatomic) SpawnController *spawnController;
@property (strong, nonatomic) NSMutableArray *arrayEnemies;

@end
