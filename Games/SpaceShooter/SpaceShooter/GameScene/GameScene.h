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
@property (assign) BOOL playing;
@property (assign) CFTimeInterval preTime;
@property (assign, nonatomic) CGSize worldSize;
//UI
@property (strong, nonatomic) SKSpriteNode *backgroundNode;
@property (strong, nonatomic) SKShapeNode *worldPanel;
@property (weak, nonatomic) GameControllerView *leftController;
@property (weak, nonatomic) GameControllerView *rightController;
@property (weak, nonatomic) UILabel *scoreLabel;
@property (weak, nonatomic) UILabel *multipleLabel;
@property (weak, nonatomic) UIImageView *playerIcon;
@property (weak, nonatomic) UILabel *livesLabel;
@property (weak, nonatomic) UILabel *bombsLabel;
@property (weak, nonatomic) UIButton *pauseBtn;
@property (weak, nonatomic) UIButton *bombBtn;
-(void) updateUI;
@property (assign, nonatomic) long score;
@property (assign, nonatomic) int multiple;
@property (assign, nonatomic) short lives;
@property (assign, nonatomic) short bombs;

@property (strong, nonatomic) SKSpriteNode *colorCover;
-(void) flashColor:(UIColor *)color;

@property (strong, nonatomic) PlayerSprite *player;
@property (strong, nonatomic) SpawnController *spawnController;
@property (strong, nonatomic) NSMutableArray *arrayEnemies;
@property (strong, nonatomic) NSMutableArray *arrayBlackHoles;
@property (strong, nonatomic) NSMutableArray *arrayPoints;
//@property (strong, nonatomic) NSMutableArray *arrayGolds;

-(void) start;
-(void) end;
-(void) clean;
-(void)useBomb;

-(void)invincibleWithTime:(float)seconds;

@end
