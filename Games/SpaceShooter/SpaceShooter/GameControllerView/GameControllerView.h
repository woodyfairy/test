//
//  GameControllerView.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/2.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@protocol GameControllerDelegate;


@interface GameControllerView : UIView
@property (weak, nonatomic) id<GameControllerDelegate> delegate;
@property (strong, nonatomic) UIImageView *circleBack;
@property (strong, nonatomic) UIImageView *circleArrow;

@property (assign, nonatomic) float minRange;
@property (assign, nonatomic) float maxRange;

@property (assign, nonatomic) float arc; //弧度 0为向右，逆时针为正
@property (assign, nonatomic) float value; //值 0-1

@property (assign, readonly) BOOL isTouching;

@end


@protocol GameControllerDelegate <NSObject>
-(void) GameControllerBeginTouch:(GameControllerView *) controller;
-(void) GameControllerEndTouch:(GameControllerView *) controller;

@end