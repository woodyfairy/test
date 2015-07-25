//
//  SpawnController.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/9.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "SpawnController.h"
#import "Common.h"
#import "SoundController.h"
#import "BlackHole.h"
#import "EnemyBase.h"
#import "Enemy_Triangle.h"
#import "Enemy_Box.h"
#import "Enemy_Circle.h"
#import "Enemy_5Side.h"
#import "Enemy_Arrow.h"
#import "Enemy_3star.h"
#import "Enemy_Sakura.h"

enum LevelSpawnType{
    LevelSpawnType_one = 1, //单个刷新
    LevelSpawnType_group = 2, //组刷新
    LevelSpawnType_coner = 3, //四边或四角刷新
    LevelSpawnType_blackHole = 5, //黑洞
    LevelSpawnType_rotation = 7, //旋转发射
};

#define TEST_ONE_SPAWN NO
#define TEST_ONE_SPAWN_LEVEL 5

@interface SpawnController()
@property (assign) CFTimeInterval mainTimer; //升级计时
@property (assign) float upLevelTime; //升级所需时间

//角落刷新
@property (assign) EnemyType conerSpawnType;
@property (assign) float conerSpawnTimer;
@property (assign) int conerSpawnNum;

//旋转刷新
@property (assign) EnemyType rotationSpawnType;
@property (assign) float rotationSpawnTimer;
@property (assign) int rotationSpwanNum;
@property (assign) int rotationSpwanDirectionNum;
@property (assign) CGPoint rotationSpawnPosition;
@property (assign) float rotaionSpawnAngular;
@end

@implementation SpawnController
-(instancetype)initWithLevel:(int)level Scene:(GameScene *)scene{
    if ([self init]) {
        _currentLevel = level;
        _maxLevel = 8;
        _currentScene = scene;
        _arrayTimers = [[NSMutableArray alloc] init];
        _arrayRefreshNeed = [[NSMutableArray alloc] init];
        [self updateLevel];
        return self;
    }
    return nil;
}
-(void) updateLevel{
    while (self.arrayTimers.count < self.currentLevel) {
        [self.arrayTimers addObject:[NSNumber numberWithFloat:0]];
    }
    while (self.arrayRefreshNeed.count < self.currentLevel) {
        [self.arrayRefreshNeed addObject:[NSNumber numberWithFloat:0]];
        [self resetRefreshTimeForLevel:self.arrayRefreshNeed.count];
    }
    
    //升下一级所需时间
    if (_currentLevel == 1) {
        self.upLevelTime = 10;
    }else if (_currentLevel == 2){
        self.upLevelTime = 10;
    }else if (_currentLevel == 3) {
        self.upLevelTime = 30;
    }else if (_currentLevel == 4) {
        self.upLevelTime = 45;
    }else if (_currentLevel == 5) {
        self.upLevelTime = 60;
    }
    else{
        self.upLevelTime = 75;
    }
}
-(void) resetRefreshTimeForLevel:(NSUInteger)level{
    float value;
    if (level == LevelSpawnType_one) {
        value = 1 + self.currentLevel/2;//单体
    }else if (level == LevelSpawnType_group){
        value = 1.f + 0.5 * (_maxLevel - self.currentLevel) + getIntRadom(3); //组
    }else if (level == LevelSpawnType_coner){
        value = 5 + (_maxLevel - self.currentLevel)*2 + getIntRadom(8); //四角或者四边
    }else if (level == LevelSpawnType_blackHole){
        value = 10 + _maxLevel - self.currentLevel + getIntRadom(10); //黑洞
    }else if (level == LevelSpawnType_rotation){
        value = 15 + (_maxLevel - self.currentLevel)*3 + getIntRadom(15); //旋转发射
    }
    [self.arrayRefreshNeed replaceObjectAtIndex:level-1 withObject:[NSNumber numberWithFloat:value]];
}

-(void)updateWithDelta:(NSTimeInterval)delta{
    //等级增长
    self.mainTimer += delta;
    //NSLog(@"timer:%f",self.timer);
    
    if (self.mainTimer >= self.upLevelTime) {
        //NSLog(@"spawn!!!");
        self.mainTimer = 0;
        if (_currentLevel < _maxLevel) {
            _currentLevel ++;
            [self updateLevel];
        }
    }
    
    //每个刷新计时
    for (int i = 0; i < _currentLevel; i ++) {
        if (TEST_ONE_SPAWN && TEST_ONE_SPAWN_LEVEL != i+1) {
            continue;
        }
        float timerValue = [[self.arrayTimers objectAtIndex:i] floatValue] + delta;
        float freshTime = [[self.arrayRefreshNeed objectAtIndex:i] floatValue];
        if (i+1 == LevelSpawnType_one) {
            //第一种刷新:随机刷单体
            if (timerValue >= freshTime) {
                timerValue = 0;
                [self resetRefreshTimeForLevel:i+1];
                [self spawnAEnemyWithType:(EnemyType)(1 + getIntRadom(4)) withPosition:[self getRandomPos]];
                //test
                //[self spawnAEnemyWithType:EnemyType_5Side withPosition:[self getRandomPos]];
            }
        }else if (i+1 == LevelSpawnType_group){
            //第二种刷新:随机刷一个组
            if (timerValue >= freshTime) {
                timerValue = 0;
                [self resetRefreshTimeForLevel:i+1];
                [self spawnAGrouByType:(EnemyType)(1 + getIntRadom(2))];
            }
        }
        else if (i+1 == LevelSpawnType_coner){
            //第三种刷新:四个角刷新大量的一种 //或者四个边的箭头
            if (timerValue >= freshTime) {
                timerValue = 0;
                [self resetRefreshTimeForLevel:i+1];
                int random = getIntRadom(8); //0－8的随机数，奇数刷新四角、偶数刷新四边、0都刷新
                if (random == 0 || random % 2 == 1) {
                    //四角刷新
                    if (self.currentLevel >= 6) {
                        self.conerSpawnType = 3 + getIntRadom(2);
                    }else{
                        self.conerSpawnType = 3 + getIntRadom(1);
                    }
                    self.conerSpawnNum = 10 + self.currentLevel * 2;
                    self.conerSpawnTimer = 0;
                    //声音
                    float allTime = self.conerSpawnNum * 0.1f + 1.f;
                    int times = allTime / 0.26f;
                    if (times < 1) {
                        times = 1;
                    }
                    [[SoundController instance] playSound:@"spawnLoop" WithPlayTimes:times];
                }
                if (random % 2 == 0){
                    //四边刷新
                    [[SoundController instance] playSound:@"spawn"];
                    int freshEdge = getIntRadom(3); //0-3 出现的边是哪个
                    for (int i = 0; i < 4; i ++) {
                        BOOL spawn = getIntRadom(1);//0/1这边是否刷新
                        if (i == 0) {
                            spawn = YES;//第1条边肯定刷新
                        }else if (i == 1 && _currentLevel < 4) {
                            spawn = NO;//第2条边在等级小于4时不会刷
                        }else if (i == 2 && _currentLevel < 6) {
                            spawn = NO;//第3条边在等级小于4时不会刷
                        }else if (i == 3 && _currentLevel < 8) {
                            spawn = NO;//第4条边在等级小于5时不会刷
                        }
                        if (spawn) {
                            float inset = 30;
                            float step = 50;
                            if (freshEdge == 0 || freshEdge == 2) {
                                //上下两边刷新
                                float startX, endX, x;
                                int rangeRand = getIntRadom(2);
                                if (rangeRand == 0) {
                                    startX = - self.currentScene.worldSize.width/2 + inset;
                                    endX = self.currentScene.worldSize.width/2 - inset;
                                }else if (rangeRand == 1){
                                    startX = - self.currentScene.worldSize.width/2 + inset;
                                    endX = 0;
                                }else{
                                    startX = 0;
                                    endX = self.currentScene.worldSize.width/2 - inset;
                                }
                                x = startX;
                                while (x <= endX) {
                                    CGPoint pos;
                                    float angular;
                                    if (freshEdge == 0) {
                                        pos = CGPointMake(x, self.currentScene.worldSize.height/2 - inset);
                                        angular = -M_PI_2;
                                    }else{
                                        pos = CGPointMake(x, -self.currentScene.worldSize.height/2 + inset);
                                        angular = M_PI_2;
                                    }
                                    Enemy_Arrow *enemy = (Enemy_Arrow *)[self spawnAEnemyWithType:EnemyType_Arrow withPosition:pos];
                                    [enemy setZRotation:angular];
                                    [enemy setDirection:MoveDirection_vertical];
                                    x += step;
                                }
                            }else{
                                //左右两边刷新
                                float startY, endY, y;
                                int rangeRand = getIntRadom(2);
                                if (rangeRand == 0) {
                                    startY = - self.currentScene.worldSize.height/2 + inset;
                                    endY = self.currentScene.worldSize.height/2 - inset;
                                }else if (rangeRand == 1){
                                    startY = - self.currentScene.worldSize.height/2 + inset;
                                    endY = 0;
                                }else{
                                    startY = 0;
                                    endY = self.currentScene.worldSize.height/2 - inset;
                                }
                                y = startY;
                                while (y <= endY) {
                                    CGPoint pos;
                                    float angular;
                                    if (freshEdge == 1) {
                                        pos = CGPointMake(-self.currentScene.worldSize.width/2 + inset, y);
                                        angular = 0;
                                    }else{
                                        pos = CGPointMake(self.currentScene.worldSize.width/2 - inset, y);
                                        angular = M_PI;
                                    }
                                    Enemy_Arrow *enemy = (Enemy_Arrow *)[self spawnAEnemyWithType:EnemyType_Arrow withPosition:pos];
                                    [enemy setZRotation:angular];
                                    [enemy setDirection:MoveDirection_horizontal];
                                    y += step;
                                }
                            }
                        }
                        
                        freshEdge ++;
                        if (freshEdge >= 4) {
                            freshEdge = 0;
                        }
                    }
                }
            }
            //四角刷新单次计时
            if (self.conerSpawnNum > 0) {
                self.conerSpawnTimer += delta;
                if (self.conerSpawnTimer >= 0.1f) {
                    self.conerSpawnTimer = 0;
                    self.conerSpawnNum --;
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(-self.currentScene.worldSize.width/2 + 80 - getRandom()*60 , -self.currentScene.worldSize.height/2 + 80 - getRandom()*60)];
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(-self.currentScene.worldSize.width/2 + 80 - getRandom()*60 , self.currentScene.worldSize.height/2 - 80 + getRandom()*60)];
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(self.currentScene.worldSize.width/2 - 80 + getRandom()*60 , -self.currentScene.worldSize.height/2 + 80 - getRandom()*60)];
                    [self spawnAEnemyWithType:self.conerSpawnType withPosition:CGPointMake(self.currentScene.worldSize.width/2 - 80 + getRandom()*60 , self.currentScene.worldSize.height/2 - 80 + getRandom()*60)];
                }
            }
        }else if (i+1 == LevelSpawnType_blackHole) {
            //第4种刷新：黑洞
            if (timerValue >= freshTime) {
                [[SoundController instance] playSound:@"spawnBlackHole"];
                timerValue = 0;
                [self resetRefreshTimeForLevel:i+1];
                int maxCount = MIN(self.currentLevel - 2, 6);
                if (self.currentScene.arrayBlackHoles.count >= maxCount) {
                    return;
                }
                BlackHole *bh = [BlackHole create];
                [bh spawnInScene:self.currentScene withStrength:(0.5f + getRandom()*0.5f)];
                for (BlackHole *oldHole in self.currentScene.arrayBlackHoles) {
                    while ( getDistanceByTwoPosition(oldHole.position, bh.position) < 300 ) {
                        [bh setPosition:[bh getRandomPos]];
                    }
                }
                [bh setZPosition:0];
                [self.currentScene.worldPanel addChild:bh];
                [self.currentScene.arrayBlackHoles addObject:bh];
            }
        }else if (i+1 == LevelSpawnType_rotation){
            //第5种，旋转
            if (timerValue >= freshTime) {
                timerValue = 0;
                int randType = getIntRadom(5);
                if (randType == 0) {
                    self.rotationSpawnType = EnemyType_5Side;//0 1/6
                }else if (randType <= 2){
                    self.rotationSpawnType = EnemyType_3star;//1-2 2/6
                }else{
                    self.rotationSpawnType = EnemyType_Sakura;//3-5 3/6
                }
                self.rotationSpawnTimer = 0;
                self.rotationSpwanNum = 10 + self.currentLevel * 2;
                self.rotationSpwanDirectionNum = 3 + getIntRadom(1);
                self.rotationSpawnPosition = [self getRandomPosWithInset:200];;
                self.rotaionSpawnAngular = getRandom() * M_PI * 2;
                //声音
                float allTime = self.rotationSpwanNum * 0.13f + 1.f;
                int times = allTime / 0.26f;
                if (times < 1) {
                    times = 1;
                }
                [[SoundController instance] playSound:@"spawnLoop" WithPlayTimes:times];
            }
            if (self.rotationSpwanNum > 0) {
                self.rotaionSpawnAngular += 1.25f * delta;
                self.rotationSpawnTimer += delta;
                if (self.rotationSpawnTimer >= 0.13f) {
                    self.rotationSpawnTimer = 0;
                    self.rotationSpwanNum --;
                    for (int i = 0; i < self.rotationSpwanDirectionNum; i ++) {
                        float ang = self.rotaionSpawnAngular + M_PI * 2 / self.rotationSpwanDirectionNum * i;
                        CGPoint pos = CGPointMake(self.rotationSpawnPosition.x + cosf(ang) * 25, self.rotationSpawnPosition.y + sinf(ang) * 25);
                        EnemyBase *enemy = [self spawnAEnemyWithType:self.rotationSpawnType withPosition:pos];
                        enemy.moveAngular = ang;
                        enemy.moveSpeed = 180;
                        if (self.rotationSpawnType == EnemyType_Sakura) {
                            Enemy_Sakura *sakura = (Enemy_Sakura *)enemy;
                            sakura.state = MoveState_speedDown;
                            sakura.moveSpeed = 400;
                        }
                    }
                }
            }
        }
        [self.arrayTimers replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:timerValue]];
    }
}
-(CGPoint) getRandomPos{
    float inset = 20;
    float width = self.currentScene.worldSize.width - inset * 2;
    float height = self.currentScene.worldSize.height - inset * 2;
    return CGPointMake(getRandom() * width - width/2, getRandom() * height - height/2);
}
-(CGPoint) getRandomPosWithInset:(float)inset{
    float width = self.currentScene.worldSize.width - inset * 2;
    float height = self.currentScene.worldSize.height - inset * 2;
    return CGPointMake(getRandom() * width - width/2, getRandom() * height - height/2);
}

//在场景创建
-(EnemyBase *)spawnAEnemyWithType:(EnemyType)type withPosition:(CGPoint)position{
    EnemyBase *enemy = [self createEnemyByType:type];
    if (enemy == nil) {
        NSLog(@"Enemy=nil!!! type:%d", type);
        abort();
    }
    [enemy setZRotation:getRandom() * M_PI * 2];
    [enemy spawnInScene:self.currentScene onPosition:position];
    [self.currentScene.arrayEnemies addObject:enemy];
    [self.currentScene.worldPanel addChild:enemy];
    return enemy;
}
-(EnemyBase *)createEnemyByType:(EnemyType)type{
    EnemyBase *enemy = nil;
    if (type == EnemyType_Triangle) {
        enemy = [Enemy_Triangle create];
    }else if (type == EnemyType_Box){
        enemy = [Enemy_Box create];
    }else if (type == EnemyType_Circle){
        enemy = [Enemy_Circle create];
    }else if (type == EnemyType_5Side){
        enemy = [Enemy_5Side create];
    }else if (type == EnemyType_3star){
        enemy = [Enemy_3star create];
    }else if (type == EnemyType_Arrow){
        enemy = [Enemy_Arrow create];
    }else if (type == EnemyType_Sakura){
        enemy = [Enemy_Sakura create];
    }
    return enemy;
}

//在组中创建
-(void)spawnAGrouByType:(EnemyType)type{
    SKNode *node = [[SKNode alloc] init];
    int count = 3 + getIntRadom(2);
    float radius = 12;
    float angular = M_PI_2;
    for (int i = 0; i < count; i++) {
        EnemyBase *enemy = [self createEnemyByType:type];
        [enemy setZRotation: angular];
        [enemy spawnInGroup:node onPosition:CGPointMake(cosf(angular) * radius, sinf(angular) * radius)];
        [self.currentScene.arrayEnemies addObject:enemy];
        [node addChild:enemy];
        angular += M_PI * 2 / count;
    }
    [self.currentScene.worldPanel addChild:node];
    [node setPosition:[self getRandomPos]];
    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    [node runAction:[SKAction repeatActionForever:action]];
}

@end
