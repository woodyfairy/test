//
//  SoundController.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/23.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "SoundController.h"

@implementation SoundController
static SoundController *instance = nil;
+(SoundController *)instance{
    if (instance == nil) {
        instance = [[SoundController alloc] init];
        instance.arrSoundPlayers = [[NSMutableArray alloc] init];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BGM_ON"] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"BGM_ON"];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SOUND_ON"] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"SOUND_ON"];
        }
    }
    return instance;
}

-(BOOL)soundIsON{
    return [self SoundON];
}
-(void)setSoungON:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:on] forKey:@"BGM_ON"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:on] forKey:@"SOUND_ON"];
}

-(BOOL)BgmON{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BGM_ON"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"BGM_ON"] boolValue]) {
        return YES;
    }
    return NO;
}
-(BOOL)SoundON{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SOUND_ON"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"SOUND_ON"] boolValue]) {
        return YES;
    }
    return NO;
}

-(void)playBackground:(NSString *)name{
    if ([self BgmON] == NO) {
        return;
    }
    
    if (self.BGMPlayer) {
        [self.BGMPlayer stop];
        self.BGMPlayer = nil;
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"mp3"];
    NSError *err = nil;
    self.BGMPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
    //self.BGMPlayer.delegate = self;
    self.BGMPlayer.numberOfLoops = -1;
    self.BGMPlayer.volume = 0.3f;
    if (err) {
        NSLog(@"play sound ERROR:%@",[err localizedDescription]);
    }
    
    [self.BGMPlayer prepareToPlay];
    self.BGMPlayer.meteringEnabled = NO;
    [self.BGMPlayer play];
}
-(void)pauseBackground{
    if ([self BgmON] && self.BGMPlayer) {
        [self.BGMPlayer pause];
    }
}
-(void)resumeBackground{
    if ([self BgmON] && self.BGMPlayer) {
        [self.BGMPlayer play];
    }
}
-(void)stopBackground{
    if (self.BGMPlayer) {
        [self.BGMPlayer stop];
        self.BGMPlayer = nil;
    }
}
-(BOOL)isPlayingBackground{
    if (self.BGMPlayer && self.BGMPlayer.isPlaying) {
        return YES;
    }
    return NO;
}

-(void)playSound:(NSString *)name{
    if ([self SoundON] == NO) {
        return;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"wav"];
    NSError *err = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
    player.volume = 0.5f;
    [self.arrSoundPlayers addObject:player];
    player.delegate = self;
    if (err) {
        NSLog(@"play sound ERROR:%@",[err localizedDescription]);
    }
    
    [player prepareToPlay];
    player.meteringEnabled = NO;
    [player play];
    
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if ([player isEqual:self.BGMPlayer]) {
        //nothing
    }else {
        [self.arrSoundPlayers removeObject:player];
    }
}

@end









