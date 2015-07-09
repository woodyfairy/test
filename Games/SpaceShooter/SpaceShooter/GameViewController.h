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
@property (weak, nonatomic) IBOutlet UIView *ViewUI;
@property (weak, nonatomic) IBOutlet GameControllerView *LeftControllerView;
@property (weak, nonatomic) IBOutlet GameControllerView *RightControllerView;

@end
