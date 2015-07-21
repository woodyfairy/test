//
//  ShopViewController.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/18.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "ShopViewController.h"
#import "DataController.h"
#import "PowerUpConfigManager.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayBtns = [[NSMutableArray alloc] initWithObjects:self.btn1, self.btn2, self.btn3, self.btn4, self.btn5, nil];
    self.arrayLabels = [[NSMutableArray alloc] initWithObjects:self.label1, self.label2, self.label3, self.label4, self.label5, nil];
    
    for (int i = 0; i < self.arrayLabels.count; i ++) {
        UILabel *label = [self.arrayLabels objectAtIndex:i];
        NSString *locString = [NSString stringWithFormat:@"shop_%d", i+1];
        [label setText: NSLocalizedString(locString, @"")];
        
        UIButton *btn = [self.arrayBtns objectAtIndex:i];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.restoreBtn setTitle:NSLocalizedString(@"shop_resotre", @"") forState:UIControlStateNormal];
}
-(void)btnClick:(UIButton *)sender{
    int index = (int)sender.tag;
    NSString *iapID = [[[PurchaseManager instanse] arrayIapIDs] objectAtIndex:index];
    [[PurchaseManager instanse] payWithIapID:iapID onView:self.view];
}
- (IBAction)restore:(id)sender {
    [[PurchaseManager instanse] restoreOnView:self.view];
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


//内购管理
@implementation PurchaseManager
static PurchaseManager *instanse = nil;
+(PurchaseManager *)instanse{
    if (instanse == nil) {
        instanse = [[PurchaseManager alloc] init];
    }
    return instanse;
}
-(void)start{
    self.availableProducts = [[NSMutableArray alloc] init];
    self.arrayIapIDs = [[NSMutableArray alloc] initWithObjects:@"star_1", @"star_2", @"star_3", @"star_4", @"power_all", nil];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self requestAllProducts];
}

- (void)requestAllProducts{
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:self.arrayIapIDs]];
    [request setDelegate:self];
    [request start];
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [self.availableProducts removeAllObjects];
    NSArray *arr = response.products;
    for (SKProduct *product in arr) {
        NSLog(@"=====Product=====");
        NSLog(@"ProductID:%@", product.productIdentifier);
        NSLog(@"ProductTitle:%@", product.localizedTitle);
        NSLog(@"ProductDescription:%@", product.localizedDescription);
        NSLog(@"ProductPrice:%@", product.price);
        
        [self.availableProducts addObject:product];
    }
}

- (void)payWithIapID:(NSString *)iapID onView:(UIView *)view{
    _showingView = view;
    if (self.availableProducts.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Items Error" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    SKProduct *product = nil;
    for (SKProduct *pro in self.availableProducts) {
        if ([pro.productIdentifier isEqual:iapID]) {
            product = pro;
            break;
        }
    }
    if (product) {
        //开启遮挡
        [self addCover];
        
        NSLog(@"buyingProduct:%@", product.productIdentifier);
        [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:product]];
    }else{
        //没有可用
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Error" message:@"Wrong Item" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)restoreOnView:(UIView *)view{
    _showingView = view;
    //开启遮挡
    [self addCover];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                //移出遮挡
                [self removeCover];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                //移出遮挡
                [self removeCover];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                //移出遮挡
                [self removeCover];
            default:
                break;
        }
    }
}
#define SAVED_UNFINISHED_TRANSACTION @"SAVED_UNFINISHED_TRANSACTION"
- (void) completeTransaction: (SKPaymentTransaction *)transaction {
//    NSString *receipt = [GTMBase64 stringByEncodingData:transaction.transactionReceipt];
    NSString *iapID = transaction.payment.productIdentifier;
//    NSLog(@"recepit:%@", receipt);
//    NSLog(@"productID:%@", iapID);
    
    //成功后先保存订单信息，防止与服务器通信出问题。
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:iapID forKey:@"SaveIapID"];
//    [dic setObject:receipt forKey:@"SavedReceipt"];
//    
//    NSMutableArray *arrSavedTrans = [[NSMutableArray alloc] init];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]) {
//        [arrSavedTrans addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]];
//    }
//    [arrSavedTrans addObject:dic];
//    [[NSUserDefaults standardUserDefaults] setObject:arrSavedTrans forKey:SAVED_UNFINISHED_TRANSACTION];
//    //要在与服务器通信后找到这个订单并删除
//    
//    
//    //[[NSNotificationCenter defaultCenter] postNotificationName:CHARGE_SUCCESS_NOTIFICATION object:nil userInfo:dic];
//    //验证内购
    [self paySuccessWithIapID:iapID];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction {
    NSString *iapID = transaction.payment.productIdentifier;
    [self paySuccessWithIapID:iapID];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) paySuccessWithIapID:(NSString *)iapID{
    UserData *userData = [[DataController instance] getUserData];
    if ([iapID isEqual:@"power_all"]) {
        userData.powerUp0Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:0].maxLevel];
        userData.powerUp1Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:1].maxLevel];
        userData.powerUp2Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:2].maxLevel];
        userData.powerUp3Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:3].maxLevel];
        userData.powerUp4Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:4].maxLevel];
        userData.powerUp5Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:5].maxLevel];
        userData.powerUp6Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:6].maxLevel];
        userData.powerUp7Level = [NSNumber numberWithShort:[[PowerUpConfigManager instance] getConfigByIndex:7].maxLevel];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"THANKS!" message:NSLocalizedString(@"shop_allPowerSuccess", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        int stars = 0;
        if ([iapID isEqual:@"star_1"]) {
            stars = 2000;
        }else if ([iapID isEqual:@"star_2"]){
            stars = 5000;
        }else if ([iapID isEqual:@"star_3"]){
            stars = 20000;
        }else if ([iapID isEqual:@"star_4"]){
            stars = 50000;
        }
        userData.currentStar = [NSNumber numberWithInt:userData.currentStar.intValue + stars];
        userData.totalStar = [NSNumber numberWithLongLong:userData.totalStar.longLongValue + stars];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"THANKS!" message:[NSString stringWithFormat:NSLocalizedString(@"shop_starsSuccess", @""), stars] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [[DataController instance] saveContext];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:transaction.error.localizedFailureReason
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
static UIView *cover = nil;
static UIActivityIndicatorView *indicator = nil;
-(void)addCover{
    UIViewController *viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if (cover == nil) {
        cover = [[UIView alloc] initWithFrame:viewController.view.bounds];
        [cover setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5f]];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [cover addSubview:indicator];
        [indicator setCenter:CGPointMake(cover.bounds.size.width/2, cover.bounds.size.height/2)];
        [indicator startAnimating];
    }
    if (self.showingView) {
        [self.showingView addSubview:cover];
        [cover setFrame:self.showingView.bounds];
    }else{
        [viewController.view addSubview:cover];
        [cover setFrame:viewController.view.bounds];
    }
    [indicator setCenter:CGPointMake(cover.bounds.size.width/2, cover.bounds.size.height/2)];
    
    [cover setAlpha:0];
    [UIView animateWithDuration:0.3f animations:^{
        [cover setAlpha:1];
    }];
}
-(void)removeCover{
    [UIView animateWithDuration:0.3f animations:^{
        [cover setAlpha:0];
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}
/*
- (BOOL)checkUnfinishedTransaction{
    NSMutableArray *arrSavedTrans = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]) {
        [arrSavedTrans addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]];
    }
    
    if ([arrSavedTrans count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unfinished Transaction" message:@"You can continue to complete the transaction" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [alert setTag:2];
        [alert show];
        return YES;
    }
    return NO;
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            //重试
            NSMutableArray *arrSavedTrans = [[NSMutableArray alloc] init];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]) {
                [arrSavedTrans addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]];
            }
            if ([arrSavedTrans count] > 0) {
                NSDictionary *dic = [arrSavedTrans objectAtIndex:0];
                //[[NSNotificationCenter defaultCenter] postNotificationName:CHARGE_SUCCESS_NOTIFICATION object:nil userInfo:dic];
            }
        }
    }
}
- (void)removeUnfinishedTransaction:(NSString *)iapID{
    NSMutableArray *arrSavedTrans = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]) {
        [arrSavedTrans addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_UNFINISHED_TRANSACTION]];
    }
    for (int i = (int)[arrSavedTrans count] - 1; i >= 0; i --) {
        NSDictionary *dic = [arrSavedTrans objectAtIndex:i];
        NSString *savedID = [dic objectForKey:@"SaveIapID"];
        if ([savedID isEqual:iapID]) {
            [arrSavedTrans removeObject:dic];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:arrSavedTrans forKey:SAVED_UNFINISHED_TRANSACTION];
}
*/
@end



























