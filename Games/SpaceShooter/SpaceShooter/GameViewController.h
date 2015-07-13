//
//  GameViewController.h
//  SpaceShooter
//

//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameControllerView.h"
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet SKView *gameView;
@property (weak, nonatomic) IBOutlet UIView *ViewUI;
@property (weak, nonatomic) IBOutlet GameControllerView *LeftControllerView;
@property (weak, nonatomic) IBOutlet GameControllerView *RightControllerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *multipleLabel;
@property (weak, nonatomic) IBOutlet UILabel *livesLabel;
@property (weak, nonatomic) IBOutlet UILabel *bombsLabel;

@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
- (IBAction)pauseClicked:(id)sender;
-(void)pause;
-(void)resume;

@property (weak, nonatomic) IBOutlet UIView *pauseView;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
- (IBAction)resumeClicked:(id)sender;


@end
