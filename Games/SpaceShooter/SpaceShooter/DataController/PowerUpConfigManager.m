//
//  PowerUpConfigManager.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/18.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "PowerUpConfigManager.h"

@implementation PowerUpConfig
@end

@implementation PowerUpConfigManager
static PowerUpConfigManager *instance = nil;
+(PowerUpConfigManager *)instance{
    if (instance == nil) {
        instance = [[PowerUpConfigManager alloc] init];
        [instance initConfigData];
    }
    return instance;
}
-(void)initConfigData{
    self.arrayConfigs = [[NSMutableArray alloc] init];
    
    PowerUpConfig *config = nil;
    //攻击成长
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config1_name", @"")];
    [config setMaxLevel:5];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config1_des0", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config1_des1", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config1_des2", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config1_des3", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config1_des4", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config1_des5", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:100]];
    [config.cost addObject:[NSNumber numberWithInt:300]];
    [config.cost addObject:[NSNumber numberWithInt:1000]];
    [config.cost addObject:[NSNumber numberWithInt:3000]];
    [config.cost addObject:[NSNumber numberWithInt:5000]];
    //生命成长
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config2_name", @"")];
    [config setMaxLevel:3];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config2_des0", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config2_des1", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config2_des2", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config2_des3", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:500]];
    [config.cost addObject:[NSNumber numberWithInt:1000]];
    [config.cost addObject:[NSNumber numberWithInt:3000]];
    //生命恢复
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config3_name", @"")];
    [config setMaxLevel:3];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config3_des0", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config3_des1", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config3_des2", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config3_des3", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:2000]];
    [config.cost addObject:[NSNumber numberWithInt:5000]];
    [config.cost addObject:[NSNumber numberWithInt:10000]];
    //炸弹成长
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config4_name", @"")];
    [config setMaxLevel:3];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config4_des0", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config4_des1", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config4_des2", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config4_des3", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:500]];
    [config.cost addObject:[NSNumber numberWithInt:1000]];
    [config.cost addObject:[NSNumber numberWithInt:3000]];
    //炸弹恢复
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config5_name", @"")];
    [config setMaxLevel:3];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config5_des0", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config5_des1", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config5_des2", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config5_des3", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:2000]];
    [config.cost addObject:[NSNumber numberWithInt:5000]];
    [config.cost addObject:[NSNumber numberWithInt:10000]];
    //自动使用炸弹
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config6_name", @"")];
    [config setMaxLevel:3];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config6_des0", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:7500]];
    //移动速度
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config7_name", @"")];
    [config setMaxLevel:3];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config7_des0", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config7_des1", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config7_des2", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config7_des3", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:500]];
    [config.cost addObject:[NSNumber numberWithInt:2500]];
    [config.cost addObject:[NSNumber numberWithInt:5000]];
    //拾取半径
    config = nil;
    config = [[PowerUpConfig alloc] init];
    [self.arrayConfigs addObject:config];
    [config setIconName:@""];
    [config setName:NSLocalizedString(@"config8_name", @"")];
    [config setMaxLevel:3];
    [config setDescriptions:[[NSMutableArray alloc] init]];
    [config.descriptions addObject:NSLocalizedString(@"config8_des0", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config8_des1", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config8_des2", @"")];
    [config.descriptions addObject:NSLocalizedString(@"config8_des3", @"")];
    [config setCost:[[NSMutableArray alloc] init]];
    [config.cost addObject:[NSNumber numberWithInt:2000]];
    [config.cost addObject:[NSNumber numberWithInt:5000]];
    [config.cost addObject:[NSNumber numberWithInt:8000]];
    
}
-(PowerUpConfig *)getConfigByIndex:(int)index{
    return [self.arrayConfigs objectAtIndex:index];
}


@end
