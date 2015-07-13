//
//  GameViewController.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/6/30.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "GameViewController.h"
#import "Common.h"
#import "GameScene.h"
#import "GameControllerView.h"

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
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    //skView.showsFields = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [scene setSize:CGSizeMake(1024, 768)];
    }else{
        if ([[UIScreen mainScreen] currentMode].size.height == 960) {
            [scene setSize:CGSizeMake(960, 640)];
        }else{
            [scene setSize:CGSizeMake(1136, 640)];
        }
    }
    
    //controller
    [self.LeftControllerView setMinRange:2];
    [self.LeftControllerView setMaxRange:40];
    [self.RightControllerView setMinRange:4];
    [self.RightControllerView setMaxRange:40];
    
    // Present the scene.
    scene.leftController = self.LeftControllerView;
    scene.rightController = self.RightControllerView;
    [self.scoreLabel setFont:[UIFont fontWithName:UIFontName size:17]];
    [self.multipleLabel setFont:[UIFont fontWithName:UIFontName size:12]];
    [self.livesLabel setFont:[UIFont fontWithName:UIFontName size:17]];
    [self.bombsLabel setFont:[UIFont fontWithName:UIFontName size:17]];
    scene.scoreLabel = self.scoreLabel;
    scene.multipleLabel = self.multipleLabel;
    scene.livesLabel = self.livesLabel;
    scene.bombsLabel = self.bombsLabel;
    [scene.leftController setDelegate:scene];
    [scene.rightController setDelegate:scene];
    [skView presentScene:scene];
    
    //打断前暂停
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:UIApplicationWillResignActiveNotification object:nil];
    
    //暂停界面
    UIView *visualEffectView = [[UIView alloc] init];
    [visualEffectView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5f]];
    //UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [visualEffectView setClipsToBounds:YES];
    [visualEffectView.layer setCornerRadius:10];
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
                                               constant:50];
    [self.pauseView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:visualEffectView
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.pauseView
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-50];
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
}

- (IBAction)pauseClicked:(id)sender {
    [self pause];
}

-(void)pause{
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
- (IBAction)resumeClicked:(id)sender {
    [self resume];
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
