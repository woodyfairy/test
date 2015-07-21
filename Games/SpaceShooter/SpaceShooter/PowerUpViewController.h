//
//  PowerUpViewController.h
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/18.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerUpViewController : UIViewController
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel0;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel0;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel3;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel4;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel5;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel5;

@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel6;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel6;

@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel7;
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel7;

@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (strong) NSMutableArray *arrayBtns;
@property (strong) NSMutableArray *arrayNameLabels;
@property (strong) NSMutableArray *arrayLvlLabels;

@property (assign) int showingIndex;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *detailView;
@property (weak, nonatomic) IBOutlet UIImageView *detail_iconImage;
@property (weak, nonatomic) IBOutlet UILabel *detail_descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detail_starImage;
@property (weak, nonatomic) IBOutlet UILabel *detail_costTag;
@property (weak, nonatomic) IBOutlet UILabel *detail_costLabel;
@property (weak, nonatomic) IBOutlet UIButton *detail_buyBtn;
- (IBAction)buy:(id)sender;


@end
