//
//  DataController.h
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/10.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserData.h"

#define LeaderboardIdentifier_Score @"LeaderboardIdentifier_Score"
#define LeaderboardIdentifier_Star @"LeaderboardIdentifier_Star"

#define SCORE_ERROR_KEY @"SCORE_ERROR_KEY"
#define STAR_ERROR_KEY @"STAR_ERROR_KEY"

@interface DataController : NSObject
+(DataController *)instance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSString *modelName;
@property (readonly, strong, nonatomic) NSString *sqliteName;
@property (readonly, strong, nonatomic) NSString *tableName;
- (void)saveContext;

-(UserData *)getUserData;
-(void) reportScore:(int64_t)score forLeaderboardIdentifier:(NSString*)identifier;

@end
