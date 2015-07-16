//
//  GameViewController.h
//  SpaceShooter
//

//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameControllerView.h"
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet SKView *gameView;
@property (strong, nonatomic) GameScene *gameScene;
@property (weak, nonatomic) IBOutlet UIView *ViewUI;
@property (weak, nonatomic) IBOutlet GameControllerView *LeftControllerView;
@property (weak, nonatomic) IBOutlet GameControllerView *RightControllerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *multipleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerIcon;
@property (weak, nonatomic) IBOutlet UILabel *livesLabel;
@property (weak, nonatomic) IBOutlet UILabel *bombsLabel;

@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
- (IBAction)pauseClicked:(id)sender;
-(void)pause;
-(void)resume;
@property (weak, nonatomic) IBOutlet UIButton *bombBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bombBtnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bombLabelTopConstraint;
- (IBAction)useBomb:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *pauseView;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseHomeBtn;
- (IBAction)resumeClicked:(id)sender;
- (IBAction)pauseHomeClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *gameOverView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *gameOverEffectView;
@property (weak, nonatomic) IBOutlet UILabel *gameOverScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameOverStarLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gameOverScoreNew;
@property (weak, nonatomic) IBOutlet UIButton *gameOverStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameOverHomeBtn;
- (IBAction)gameOverClickStart:(id)sender;
- (IBAction)gameOverClickHome:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *homeEffectView;
@property (weak, nonatomic) IBOutlet UIButton *homeStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *homePowerupBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeShopBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeRankingBtn;
- (IBAction)homeStartClick:(id)sender;
- (IBAction)homePowerupClick:(id)sender;
- (IBAction)homeShopClick:(id)sender;
- (IBAction)homeRankingClick:(id)sender;
@property (strong, nonatomic) SKEmitterNode *homeBackEffect;


@end
