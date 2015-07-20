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
@property (nonatomic, retain) NSNumber * powerUp0Level; //火力升级
@property (nonatomic, retain) NSNumber * powerUp1Level; //生命增加
@property (nonatomic, retain) NSNumber * powerUp2Level; //生命获取
@property (nonatomic, retain) NSNumber * powerUp3Level; //炸弹增加
@property (nonatomic, retain) NSNumber * powerUp4Level; //炸弹获取
@property (nonatomic, retain) NSNumber * powerUp5Level; //自动炸弹
@property (nonatomic, retain) NSNumber * powerUp6Level; //增加移速
@property (nonatomic, retain) NSNumber * powerUp7Level; //拾取范围

@end
