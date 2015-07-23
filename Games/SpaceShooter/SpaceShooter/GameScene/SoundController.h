//
//  SoundController.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/23.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundController : NSObject <AVAudioPlayerDelegate>
+(SoundController *)instance;

-(BOOL)soundIsON;
-(void)setSoungON:(BOOL)on;

@property (retain, nonatomic)NSMutableArray *arrSoundPlayers;
@property (retain, nonatomic)AVAudioPlayer *BGMPlayer;

-(void)playBackground:(NSString *)name;
-(void)pauseBackground;
-(void)resumeBackground;
-(void)stopBackground;
-(BOOL)isPlayingBackground;

-(void)playSound:(NSString *)name;

@end
