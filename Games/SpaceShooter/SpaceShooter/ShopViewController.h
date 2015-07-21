//
//  ShopViewController.h
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/18.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopViewController : UIViewController
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@property (weak, nonatomic) IBOutlet UIButton *restoreBtn;
- (IBAction)restore:(id)sender;


@property (strong, nonatomic) NSMutableArray *arrayBtns;
@property (strong, nonatomic) NSMutableArray *arrayLabels;


@end


#import <StoreKit/StoreKit.h>
//内购管理
@interface PurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
+(PurchaseManager *)instanse;
-(void)start;
@property (strong, nonatomic) NSMutableArray *arrayIapIDs;

@property (retain, nonatomic) NSMutableArray *availableProducts;
@property (weak, nonatomic, readonly) UIView *showingView;
- (void)requestAllProducts;
- (void)payWithIapID:(NSString *)iapID onView:(UIView *)view;
- (void)restoreOnView:(UIView *)view;
//- (BOOL)checkUnfinishedTransaction;
//- (void)removeUnfinishedTransaction:(NSString *)iapID;

@end