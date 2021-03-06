//
//  GameViewController.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/6/30.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "GameViewController.h"
#import "Common.h"
#import "DataController.h"
#import "PowerUpViewController.h"
#import "SoundController.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.gameView;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    //skView.showsFields = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.gameScene = [GameScene unarchiveFromFile:@"GameScene"];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFit;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.gameScene setSize:CGSizeMake(1024, 768)];
    }else{
        if ([[UIScreen mainScreen] currentMode].size.height == 960) {
            [self.gameScene setSize:CGSizeMake(960, 640)];
        }else{
            [self.gameScene setSize:CGSizeMake(1136, 640)];
        }
    }
    
    //controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.LeftControllerView setMinRange:2];
        [self.LeftControllerView setMaxRange:40];
        [self.RightControllerView setMinRange:4];
        [self.RightControllerView setMaxRange:40];
    }else{
        [self.LeftControllerView setMinRange:3];
        [self.LeftControllerView setMaxRange:60];
        [self.RightControllerView setMinRange:6];
        [self.RightControllerView setMaxRange:60];
    }
    
    
    //炸弹按钮
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.bombBtnTopConstraint setConstant:-300];
        [self.bombLabelTopConstraint setConstant:290];
    }
    
    // Present the scene.
    self.gameScene.leftController = self.LeftControllerView;
    self.gameScene.rightController = self.RightControllerView;
    [self.scoreLabel setFont:[UIFont fontWithName:UIFontName size:17]];
    [self.multipleLabel setFont:[UIFont fontWithName:UIFontName size:12]];
    [self.livesLabel setFont:[UIFont fontWithName:UIFontName size:17]];
    [self.bombsLabel setFont:[UIFont fontWithName:UIFontName size:17]];
    self.gameScene.scoreLabel = self.scoreLabel;
    self.gameScene.multipleLabel = self.multipleLabel;
    self.gameScene.playerIcon = self.playerIcon;
    self.gameScene.livesLabel = self.livesLabel;
    self.gameScene.bombsLabel = self.bombsLabel;
    [self.gameScene.leftController setDelegate:self.gameScene];
    [self.gameScene.rightController setDelegate:self.gameScene];
    self.gameScene.pauseBtn = self.pauseBtn;
    self.gameScene.bombBtn = self.bombBtn;
    [skView presentScene:self.gameScene];
    
    //打断前暂停
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //暂停界面
    [self.pauseView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2f]];
    UIView *visualEffectView = [[UIView alloc] init];
    [visualEffectView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5f]];
    //UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [visualEffectView setClipsToBounds:YES];
    [visualEffectView.layer setCornerRadius:15];
    visualEffectView.frame = self.pauseView.bounds;
    [self.pauseView addSubview:visualEffectView];
    [self.pauseView sendSubviewToBack:visualEffectView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = nil;
    constraint = [NSLayoutConstraint constraintWithItem:visualEffectView
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.pauseView
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:75];
    [self.pauseView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:visualEffectView
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.pauseView
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-75];
    [self.pauseView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:visualEffectView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.pauseView
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0f
                                               constant:50];
    [self.pauseView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:visualEffectView
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.pauseView
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:-50];
    [self.pauseView addConstraint:constraint];
    
    //gameOverView
    [self.gameOverEffectView setClipsToBounds:YES];
    [self.gameOverEffectView.layer setCornerRadius:15];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGameOverViewWithNotification:) name:@"GameOverNotification" object:nil];
    
    //homeView
    [self.homeEffectView setClipsToBounds:YES];
    [self.homeEffectView.layer setCornerRadius:15];
    [self showHome];
}
-(void)willResignActive{
    [self pause];
    [[SoundController instance] pauseBackground];
}
-(void)didBecomeActive{
    [[SoundController instance] resumeBackground];
}

//游戏UI
- (IBAction)pauseClicked:(id)sender {
    [self pause];
}

-(void)pause{
    if (self.gameScene.playing) {
        SKView * skView = (SKView *)self.gameView;
        [skView setPaused:YES];
        
        //显示暂停界面
        self.pauseView.hidden = NO;
        self.pauseView.alpha = 0;
        [self.resumeBtn setEnabled:NO];
        //[self.homeBtn setEnabled:NO];
        [UIView animateWithDuration:1 animations:^{
            self.pauseView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.resumeBtn setEnabled:YES];
            //[self.homeBtn setEnabled:YES];
        }];
        
        if ([[SoundController instance] soundIsON]) {
            [self.pauseSoundBtn setImage:[UIImage imageNamed:@"soundBtn_on"] forState:UIControlStateNormal];
        }else{
            [self.pauseSoundBtn setImage:[UIImage imageNamed:@"soundBtn_off"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)useBomb:(id)sender {
    [self.gameScene useBomb];
}

//暂停界面
- (IBAction)resumeClicked:(id)sender {
    [self resume];
}
-(void)resume{
    SKView * skView = (SKView *)self.gameView;
    [skView setPaused:NO];
    GameScene *scene = (GameScene *)skView.scene;
    scene.preTime = 0;
    //隐藏暂停界面
    self.pauseView.hidden = YES;
    
    //    self.gameView.scene.speed = 0.3f;
    //    self.gameView.scene.physicsWorld.speed = 0.3f;
}
- (IBAction)pauseHomeClick:(id)sender {
    [self.pauseView setHidden:YES];
    [self showHome];
}

- (IBAction)pauseSoundBtnClick:(id)sender {
    BOOL on = ! [[SoundController instance] soundIsON];
    [[SoundController instance] setSoungON: on];
    if (on) {
        [self.pauseSoundBtn setImage:[UIImage imageNamed:@"soundBtn_on"] forState:UIControlStateNormal];
        [[SoundController instance] playBackground:@"BattleBackground"];
    }else{
        [self.pauseSoundBtn setImage:[UIImage imageNamed:@"soundBtn_off"] forState:UIControlStateNormal];
        [[SoundController instance] stopBackground];
    }
}

//gameoverView
-(void)showGameOverViewWithNotification:(NSNotification *)notification{
    self.gameOverView.hidden = NO;
    [self.gameOverScoreLabel setText:[NSString stringWithFormat:@"SCORE:%lld", self.gameScene.score]];
    NSNumber *newRecord = [notification.userInfo objectForKey:@"NewRecordKey"];
    if (newRecord.boolValue) {
        [self.gameOverScoreNew setHidden:NO];
    }else{
        [self.gameOverScoreNew setHidden:YES];
    }
    [self.gameOverStarLabel setText:[NSString stringWithFormat:@"+%d", self.gameScene.multiple]];
}
- (IBAction)gameOverClickStart:(id)sender {
    [self.gameScene start];
    [self.gameOverView setHidden:YES];
}

- (IBAction)gameOverClickHome:(id)sender {
    [self.gameOverView setHidden:YES];
    [self showHome];
}

//主界面
-(void) showHome{
    [self.homeView setHidden:NO];
    //[self.homeView setHidden:YES];
    
    UserData *userData = [[DataController instance] getUserData];
    if (userData.topScore.longLongValue == 0) {
        [self.historyScoreLabel setHidden:YES];
    }else{
        [self.historyScoreLabel setText:[NSString stringWithFormat:@"%@:%lld", NSLocalizedString(@"historyTopScore", @""), userData.topScore.longLongValue]];
        [self.historyScoreLabel setHidden:NO];
    }
    
    
    //清空
    [self.gameScene clean];
    
    [self.gameScene end];
    [self.gameView setPaused:NO];
    
    //bgm
    [[SoundController instance] playBackground:@"HomeBackground"];
    if ([[SoundController instance] soundIsON]) {
        [self.homeSoundBtn setImage:[UIImage imageNamed:@"soundBtn_on"] forState:UIControlStateNormal];
    }else{
        [self.homeSoundBtn setImage:[UIImage imageNamed:@"soundBtn_off"] forState:UIControlStateNormal];
    }
    
//    self.homeBackEffect = [SKEmitterNode nodeWithFileNamed:@"HomeBackEffect"];
//    [self.gameScene addChild:self.homeBackEffect];
//    [self.homeBackEffect setPosition:CGPointMake(CGRectGetMidX(self.gameScene.frame), CGRectGetMidY(self.gameScene.frame))];
//    [self viewWillLayoutSubviews];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.homeBackEffect) {
        float widthRatio = self.homeEffectView.frame.size.width/self.homeView.frame.size.width;
        float heightRatio = self.homeEffectView.frame.size.height/self.homeView.frame.size.height;
        [self.homeBackEffect setParticlePositionRange:CGVectorMake(self.gameScene.size.width * widthRatio, self.gameScene.size.height * heightRatio)];
    }
}
-(void) hideHome{
    [self.homeView setHidden:YES];
    [self.homeBackEffect removeFromParent];
    self.homeBackEffect = nil;
}
- (IBAction)homeStartClick:(id)sender {
    [self hideHome];
    [self.gameScene start];
}

- (IBAction)homePowerupClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PowerUpViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"PowerUp"];
    
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (IBAction)homeShopClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PowerUpViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"Shop"];
    
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (IBAction)homeRankingClick:(id)sender {
    GKGameCenterViewController *viewController = [[GKGameCenterViewController alloc] init];
    viewController.gameCenterDelegate = self;
    viewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    [viewController setLeaderboardIdentifier: LeaderboardIdentifier_Score];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)homeSoundBtnClick:(id)sender {
    BOOL on = ! [[SoundController instance] soundIsON];
    [[SoundController instance] setSoungON: on];
    if (on) {
        [self.homeSoundBtn setImage:[UIImage imageNamed:@"soundBtn_on"] forState:UIControlStateNormal];
        [[SoundController instance] playBackground:@"HomeBackground"];
    }else{
        [self.homeSoundBtn setImage:[UIImage imageNamed:@"soundBtn_off"] forState:UIControlStateNormal];
        [[SoundController instance] stopBackground];
    }
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    NSLog(@"gameCenterViewControllerDidFinish");
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
