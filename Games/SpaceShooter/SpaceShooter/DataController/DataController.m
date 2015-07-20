//
//  DataController.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/10.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "DataController.h"
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@implementation DataController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


static DataController *instance = nil;
+(DataController *)instance{
    if (instance == nil) {
        instance = [[DataController alloc] init];
        [instance initData];
    }
    return instance;
}
-(void)initData{
    _modelName = @"UserModel";
    _sqliteName = @"UserData.sqlite";
    _tableName = @"UserData";
    
    //启动后注册GameCenter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLaunch) name:UIApplicationDidFinishLaunchingNotification object:nil];
    //激活后看是否有未完成的上报分数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appActive) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

static UserData *gettedData = nil;
-(UserData *)getUserData{
    if (gettedData != nil) {
        return gettedData;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"fetch UserData ERROR:%@", error.localizedDescription);
        return nil;
    }
    if (fetchedObjects.count == 0) {
        UserData *userData = [NSEntityDescription insertNewObjectForEntityForName:self.tableName inManagedObjectContext:context];
        gettedData = userData;
        [self saveContext];
        return userData;
    }
    
    gettedData = [fetchedObjects lastObject];
    return gettedData;
}


//保存数据
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Data ERROR!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.sqliteName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Game Center
-(void) appLaunch{
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *vc, NSError *error) {
        if (error == nil) {
            //成功处理
            NSLog(@"GameCenterAuthenticate成功");
//            NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
//            NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
//            NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
//            NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
//            NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
        }else {
            //错误处理
            NSLog(@"GameCenterERROR%@",error);
            
        }
    }];
}
-(void) appActive{
    //程序active
    //是否有上传失败的分数
    NSNumber *scoreError = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_ERROR_KEY];
    if (scoreError && scoreError.boolValue) {
        UserData *userData = [self getUserData];
        [self reportScore:userData.topScore.longLongValue forLeaderboardIdentifier:LeaderboardIdentifier_Score];
    }
    //是否有上传失败的星星数
    NSNumber *starError = [[NSUserDefaults standardUserDefaults] objectForKey:STAR_ERROR_KEY];
    if (starError && starError.boolValue) {
        UserData *userData = [self getUserData];
        [self reportScore:userData.totalStar.longLongValue forLeaderboardIdentifier:LeaderboardIdentifier_Star];
    }
}
- (void) authenticationChanged{
    if ([GKLocalPlayer localPlayer].isAuthenticated)
    {
        // Insert code here to handle a successful authentication
    }else{
        // Insert code here to clean up any outstanding Game Center-related classes.
    }
}
-(void) reportScore:(int64_t)score forLeaderboardIdentifier:(NSString*)identifier{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    scoreReporter.value = score;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"reportScoreERROR:%@",error);
            if ([identifier isEqual:LeaderboardIdentifier_Score]) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:SCORE_ERROR_KEY];
            }else if ([identifier isEqual:LeaderboardIdentifier_Star]){
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:STAR_ERROR_KEY];
            }
        }else{
            //上传成功
            NSLog(@"reportScoreSuccess");
            if ([identifier isEqual:LeaderboardIdentifier_Score]) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:SCORE_ERROR_KEY];
            }else if ([identifier isEqual:LeaderboardIdentifier_Star]){
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:STAR_ERROR_KEY];
            }
        }
    }];
}


@end
