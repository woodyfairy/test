//
//  UserData.h
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/18.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserData : NSManagedObject

@property (nonatomic, retain) NSNumber * topScore;
@property (nonatomic, retain) NSNumber * totalStar;
@property (nonatomic, retain) NSNumber * currentStar;
@property (nonatomic, retain) NSNumber * powerUp0Level;
@property (nonatomic, retain) NSNumber * powerUp1Level;
@property (nonatomic, retain) NSNumber * powerUp2Level;
@property (nonatomic, retain) NSNumber * powerUp3Level;
@property (nonatomic, retain) NSNumber * powerUp4Level;
@property (nonatomic, retain) NSNumber * powerUp5Level;
@property (nonatomic, retain) NSNumber * powerUp6Level;
@property (nonatomic, retain) NSNumber * powerUp7Level;

@end
