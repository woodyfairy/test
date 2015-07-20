//
//  PowerUpViewController.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/18.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "PowerUpViewController.h"
#import "DataController.h"
#import "PowerUpConfigManager.h"

@interface PowerUpViewController ()<UIAlertViewDelegate>

@end

@implementation PowerUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayBtns = [[NSMutableArray alloc] initWithObjects:self.btn0, self.btn1, self.btn2, self.btn3, self.btn4, self.btn5, self.btn6, self.btn7, nil];
    self.arrayNameLabels = [[NSMutableArray alloc] initWithObjects:self.nameLabel0, self.nameLabel1, self.nameLabel2, self.nameLabel3, self.nameLabel4, self.nameLabel5, self.nameLabel6, self.nameLabel7, nil];
    self.arrayLvlLabels = [[NSMutableArray alloc] initWithObjects:self.lvlLabel0, self.lvlLabel1, self.lvlLabel2, self.lvlLabel3, self.lvlLabel4, self.lvlLabel5, self.lvlLabel6, self.lvlLabel7, nil];
    for (UIButton *btn in self.arrayBtns) {
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self updateView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDetailView)];
    [self.detailView addGestureRecognizer:tap];
    [self.detail_costTag setText: NSLocalizedString(@"powerUp_cost", @"")];
}
-(NSArray *)getUserPowerUpLevles{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    UserData *userData = [[DataController instance] getUserData];
    [arr addObject:userData.powerUp0Level];
    [arr addObject:userData.powerUp1Level];
    [arr addObject:userData.powerUp2Level];
    [arr addObject:userData.powerUp3Level];
    [arr addObject:userData.powerUp4Level];
    [arr addObject:userData.powerUp5Level];
    [arr addObject:userData.powerUp6Level];
    [arr addObject:userData.powerUp7Level];
    return arr;
}

-(void) updateView{
    NSArray *arrLevels = [self getUserPowerUpLevles];
    for (int i = 0; i < self.arrayBtns.count; i ++) {
        PowerUpConfig *config = [[PowerUpConfigManager instance] getConfigByIndex:i];
        UILabel *nameLabel = [self.arrayNameLabels objectAtIndex:i];
        UILabel *lvlLabel = [self.arrayLvlLabels objectAtIndex:i];
        [nameLabel setText:config.name];
        int curLevel = [[arrLevels objectAtIndex:i] intValue];
        if (config.maxLevel == 1) {
            if (curLevel == 0) {
                [lvlLabel setText:NSLocalizedString(@"config_disable", @"")];
                [lvlLabel setTextColor:[UIColor redColor]];
            }else{
                [lvlLabel setText:NSLocalizedString(@"config_active", @"")];
                [lvlLabel setTextColor:[UIColor greenColor]];
            }
        }else{
            [lvlLabel setText:[NSString stringWithFormat:@"%d/%d", curLevel, config.maxLevel]];
            if (curLevel == 0) {
                [lvlLabel setTextColor:[UIColor redColor]];
            }else if (curLevel == config.maxLevel){
                [lvlLabel setTextColor:[UIColor greenColor]];
            }else{
                [lvlLabel setTextColor:[UIColor orangeColor]];
            }
        }
        UIButton *btn = [self.arrayBtns objectAtIndex:i];
        if (curLevel == 0) {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"powerUp%d_n", i + 1]] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"powerUp%d", i + 1]] forState:UIControlStateNormal];
        }
    }
    
    UserData *userData = [[DataController instance] getUserData];
    [self.starLabel setText:[NSString stringWithFormat:@"%d", userData.currentStar.intValue]];
}

-(void)btnClicked:(UIButton *)btn{
    int index = (int)btn.tag;
    self.showingIndex = index;
    [self updateDetailView];
}
-(void)updateDetailView{
    int index = self.showingIndex;
    
    NSArray *arrLevels = [self getUserPowerUpLevles];
    PowerUpConfig *config = [[PowerUpConfigManager instance] getConfigByIndex:index];
    int level = [[arrLevels objectAtIndex:index] intValue];
    int curStar = [[DataController instance] getUserData].currentStar.intValue;
    
    [self.detailView setHidden:NO];
    [self.detail_iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"powerUp%d", index + 1]]];
    [self.detail_descriptionLabel setText:[config.descriptions objectAtIndex:level]];
    if (level == config.maxLevel) {
        [self.detail_costTag setHidden:YES];
        [self.detail_starImage setHidden:YES];
        [self.detail_costLabel setHidden:YES];
        [self.detail_buyBtn setHidden:YES];
    }else{
        [self.detail_costTag setHidden:NO];
        [self.detail_starImage setHidden:NO];
        [self.detail_costLabel setHidden:NO];
        [self.detail_buyBtn setHidden:NO];
        [self.detail_costLabel setText:[NSString stringWithFormat:@"%d", [[config.cost objectAtIndex:level] intValue]]];
        if (curStar >= [[config.cost objectAtIndex:level] intValue]) {
            [self.detail_costLabel setTextColor:[UIColor greenColor]];
            [self.detail_buyBtn setTag:index];
        }else{
            [self.detail_costLabel setTextColor:[UIColor redColor]];
            [self.detail_buyBtn setTag:-1];
        }
    }
}
-(void)closeDetailView{
    [self.detailView setHidden:YES];
}

- (IBAction)buy:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int index = (int)btn.tag;
    if (index == -1) {
        //金币不够
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"powerUp_notEnough", @"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"powerUp_cancel", @"") otherButtonTitles:NSLocalizedString(@"powerUp_gotoShop", @""), nil];
        [alert setTag:1];
        [alert show];
    }else{
        //确认购买
        PowerUpConfig *config = [[PowerUpConfigManager instance] getConfigByIndex:self.showingIndex];
        int level = [[[self getUserPowerUpLevles] objectAtIndex:self.showingIndex] intValue];
        int cost = [[config.cost objectAtIndex:level] intValue];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"powerUp_confirmTitle", @"") message:[NSString stringWithFormat:NSLocalizedString(@"powerUp_confirmDes", @""), cost] delegate:self cancelButtonTitle:NSLocalizedString(@"powerUp_cancel", @"") otherButtonTitles:NSLocalizedString(@"powerUp_confirmYes", @""), nil];
        [alert setTag:2];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        //星星不够的提示
        if (buttonIndex == 1) {
            //去商店
        }
    }else if (alertView.tag == 2) {
        //确认购买
        if (buttonIndex == 1) {
            //购买
            UserData *userData = [[DataController instance] getUserData];
            
            //先扣星
            PowerUpConfig *config = [[PowerUpConfigManager instance] getConfigByIndex:self.showingIndex];
            int level = [[[self getUserPowerUpLevles] objectAtIndex:self.showingIndex] intValue];
            int cost = [[config.cost objectAtIndex:level] intValue];
            userData.currentStar = [NSNumber numberWithInt:userData.currentStar.intValue - cost];
            //再升级，否则扣星按照高等级的扣，就不对了
            if (self.showingIndex == 0) {
                userData.powerUp0Level = [NSNumber numberWithShort:userData.powerUp0Level.shortValue + 1];
            }else if (self.showingIndex == 1) {
                userData.powerUp1Level = [NSNumber numberWithShort:userData.powerUp1Level.shortValue + 1];
            }else if (self.showingIndex == 2) {
                userData.powerUp2Level = [NSNumber numberWithShort:userData.powerUp2Level.shortValue + 1];
            }else if (self.showingIndex == 3) {
                userData.powerUp3Level = [NSNumber numberWithShort:userData.powerUp3Level.shortValue + 1];
            }else if (self.showingIndex == 4) {
                userData.powerUp4Level = [NSNumber numberWithShort:userData.powerUp4Level.shortValue + 1];
            }else if (self.showingIndex == 5) {
                userData.powerUp5Level = [NSNumber numberWithShort:userData.powerUp5Level.shortValue + 1];
            }else if (self.showingIndex == 6) {
                userData.powerUp6Level = [NSNumber numberWithShort:userData.powerUp6Level.shortValue + 1];
            }else if (self.showingIndex == 7) {
                userData.powerUp7Level = [NSNumber numberWithShort:userData.powerUp7Level.shortValue + 1];
            }
            //保存数据
            [[DataController instance] saveContext];
            
            [self updateDetailView];
            [self updateView];
        }
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
