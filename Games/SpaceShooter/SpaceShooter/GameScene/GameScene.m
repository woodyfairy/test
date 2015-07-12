//
//  GameScene.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/6/30.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "GameScene.h"
#import "Common.h"
#import "DataController.h"
#import "SpawnController.h"
#import "EnemyBase.h"
#import "BlackHole.h"
#import "Enemy_Black.h"

//test
int startLevel = 1;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    [self setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1]];
    self.physicsWorld.contactDelegate = self;
    self.worldSize = CGSizeMake(1500, 800);
    self.worldPanel = [SKShapeNode shapeNodeWithRectOfSize:self.worldSize];
    [self.worldPanel setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    self.worldPanel.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-self.worldSize.width/2, -self.worldSize.height/2, self.worldSize.width, self.worldSize.height)];
    self.worldPanel.physicsBody.restitution = 0;
    self.worldPanel.physicsBody.friction = 0;
    self.worldPanel.physicsBody.linearDamping = 0;
    self.worldPanel.physicsBody.angularDamping = 0;
    self.worldPanel.physicsBody.dynamic = NO;
    [self.worldPanel setLineWidth:1];
    [self.worldPanel setStrokeColor:[UIColor whiteColor]];
    self.worldPanel.physicsBody.categoryBitMask = PhysicType_edge;
    self.worldPanel.physicsBody.contactTestBitMask = PhysicType_player | PhysicType_enermy;
    self.worldPanel.physicsBody.contactTestBitMask = PhysicType_bullet;
    //NSLog(@"pos:%f,%f", self.worldPanel.position.x, self.worldPanel.position.y);
    [self addChild:self.worldPanel];
    
    //网格
    CGMutablePathRef path = CGPathCreateMutable();
    float step = 50;
    float x = 0;
    while (x + step < self.worldSize.width) {
        x += step;
        CGPathMoveToPoint(path, NULL, x, 0);
        CGPathAddLineToPoint(path, NULL, x, self.worldSize.height);
    }
    float y = 0;
    while (y + step < self.worldSize.height) {
        y += step;
        CGPathMoveToPoint(path, NULL, 0, y);
        CGPathAddLineToPoint(path, NULL, self.worldSize.width, y);
    }
    SKShapeNode *gird = [SKShapeNode shapeNodeWithPath:path];
    [gird setLineWidth:0.5f];
    [gird setStrokeColor:[UIColor colorWithWhite:0 alpha:0.2f]];
    CGPathRelease(path);
    [self.worldPanel addChild:gird];
    [gird setZPosition:-1];
    [gird setPosition:CGPointMake(-self.worldSize.width/2, -self.worldSize.height/2)];
    
    //玩家
    self.player = [PlayerSprite create];
    [self.player setZPosition:0];
    [self.worldPanel addChild:self.player];
    [self.player setPosition:CGPointZero];
    [self.player.emitter setTargetNode:self.worldPanel];
    
    //敌人控制
    self.spawnController = [[SpawnController alloc] initWithLevel:startLevel Scene:self];
    self.arrayEnemies = [[NSMutableArray alloc] init];
    self.arrayBlackHoles = [[NSMutableArray alloc] init];
    self.arrayPoints = [[NSMutableArray alloc] init];
    self.arrayGolds = [[NSMutableArray alloc] init];
    
    //UI
    self.score = 0;
    self.multiple = 1;
    self.lives = 1;
    self.bombs = 1;
    [self updateUI];
}
-(void)updateUI{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score:%ld", self.score]];
    [self.multipleLabel setText:[NSString stringWithFormat:@"X%d", self.multiple]];
    [self.livesLabel setText:[NSString stringWithFormat:@"X%d", self.lives]];
    [self.bombsLabel setText:[NSString stringWithFormat:@"X%d", self.bombs]];
}

-(void)GameControllerBeginTouch:(GameControllerView *)controller{
}
-(void)GameControllerEndTouch:(GameControllerView *)controller{
}

CFTimeInterval preTime = 0;
CFTimeInterval countTime = 0;
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //NSLog(@"time:%f", currentTime);
    
    //玩家控制
    self.player.zRotation = -self.leftController.arc;
    float speed = self.leftController.value * self.player.maxSpeed;
    self.player.physicsBody.velocity = CGVectorMake(cosf(-self.leftController.arc) * speed, sinf(-self.leftController.arc) * speed);
    //[self.player.emitter setParticleBirthRate:(self.leftController.value * self.player.maxLight)];//这里好像还有问题
    int shouldBirth = (int)(self.leftController.value * self.player.maxLight) / 10 * 10;
    if (self.player.emitter.particleBirthRate != shouldBirth) {
        [self.player.emitter setParticleBirthRate:shouldBirth];
    }
    //NSLog(@"brithRage:%f", self.player.emitter.particleBirthRate);
    self.player.emitter.particleRotation = self.player.zRotation + M_PI_2;
    self.player.emitter.emissionAngle = self.player.zRotation + M_PI;
    //NSLog(@"speed:%f,%f", self.player.physicsBody.velocity.dx, self.player.physicsBody.velocity.dy);
//    if (self.player.position.x < -self.worldSize.width/2) {
//        self.player.position = CGPointMake(-self.worldSize.width/2, self.player.position.y);
//    }else if (self.player.position.x > self.worldSize.width/2) {
//        self.player.position = CGPointMake(self.worldSize.width/2, self.player.position.y);
//    }
//    if (self.player.position.y < -self.worldSize.height/2) {
//        self.player.position = CGPointMake(self.player.position.x, -self.worldSize.height/2);
//    }else if (self.player.position.y > self.worldSize.height/2) {
//        self.player.position = CGPointMake(self.player.position.x, self.worldSize.height/2);
//    }
    
    //镜头控制
    CGPoint posInScreen = [self convertPoint:self.player.position fromNode:self.worldPanel];
    if (posInScreen.x < self.size.width/3) {
        self.worldPanel.position = CGPointMake(self.worldPanel.position.x + self.size.width/3 - posInScreen.x, self.worldPanel.position.y);
    }else if (posInScreen.x > self.size.width/3*2){
        self.worldPanel.position = CGPointMake(self.worldPanel.position.x + self.size.width/3*2 - posInScreen.x, self.worldPanel.position.y);
    }
    if (posInScreen.y < self.size.height/5*2) {
        self.worldPanel.position = CGPointMake(self.worldPanel.position.x, self.worldPanel.position.y + self.size.height/5*2 - posInScreen.y);
    }else if (posInScreen.y > self.size.height/5*3){
        self.worldPanel.position = CGPointMake(self.worldPanel.position.x, self.worldPanel.position.y + self.size.height/5*3 - posInScreen.y);
    }
    
    //间隔时间的
    if (preTime != 0) {
        CFTimeInterval delta = currentTime - preTime;
        //NSLog(@"time:%f", delta);
        countTime += delta;
        if (countTime >= self.player.fireInterval) {
            countTime = 0;
            //玩家子弹
            int bulletNum = 1;
            float angRange = 0;
            if (self.player.fireLevel == 1) {
                bulletNum = 3;
                angRange = 0.03f;
            }
            float anguler = self.player.zRotation - angRange/2;
            if (self.rightController.isTouching) {
                anguler = -self.rightController.arc - angRange/2;
            }else{
                self.rightController.arc = -anguler;
            }
            for (int i = 0; i < bulletNum; i ++) {
                SKSpriteNode *bullet = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"fire"]]];
                [bullet setColorBlendFactor:1];
                [bullet setColor:[UIColor colorWithRed:1 green:1 blue:0.75 alpha:1]];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL, -7, 0);
                CGPathAddLineToPoint(path, NULL, -2, 4);
                CGPathAddLineToPoint(path, NULL, 5, 0);
                CGPathAddLineToPoint(path, NULL, -2, -4);
                CGPathMoveToPoint(path, NULL, -7, 0);
                bullet.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
                bullet.physicsBody.categoryBitMask = PhysicType_bullet;
                bullet.physicsBody.collisionBitMask = 0;
                bullet.physicsBody.contactTestBitMask = PhysicType_edge | PhysicType_enermy | PhysicType_blackHole;
                bullet.physicsBody.fieldBitMask = FieldType_all - FieldType_player;
                CGPathRelease(path);
                bullet.zRotation = anguler;
                bullet.position = CGPointMake(self.player.position.x + 15*cos(anguler), self.player.position.y + 15*sin(anguler));
                float speed = 600;
                bullet.physicsBody.velocity = CGVectorMake(speed*cos(anguler), speed*sin(anguler));
                [self.worldPanel addChild:bullet];
                anguler += angRange/2;
            }
        }
        //敌人控制
        if (self.spawnController) {
            [self.spawnController updateWithDelta:delta];
        }
        for (EnemyBase *enemy in self.arrayEnemies) {
            if ([enemy respondsToSelector:@selector(updateWithDelta:)]) {
                [enemy updateWithDelta:delta];
            }
        }
        //test
        //NSLog(@"dataController:%@", [[DataController instance] log]);
    }
    
    preTime = currentTime;
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA == nil || contact.bodyB == nil) {
        //同时有1对n的碰撞已经删掉了
        return;
    }
    if (contact.bodyA.categoryBitMask == PhysicType_player || contact.bodyB.categoryBitMask == PhysicType_player) {
        //玩家碰撞
        SKPhysicsBody *player = nil;
        SKPhysicsBody *other = nil;
        if (contact.bodyA.categoryBitMask == PhysicType_player) {
            player = contact.bodyA;
            other = contact.bodyB;
        }else if (contact.bodyB.categoryBitMask == PhysicType_player) {
            player = contact.bodyB;
            other = contact.bodyA;
        }
        if (other == nil) {
            return;
        }
        if (other.node.physicsBody.categoryBitMask == PhysicType_enermy || other.node.physicsBody.categoryBitMask == PhysicType_blackHole) {
            //玩家碰撞，死掉
            for (int i = (int)self.arrayEnemies.count - 1; i >= 0; i --) {
                EnemyBase *enemy = [self.arrayEnemies objectAtIndex:i];
                if (enemy.group) {
                    SKNode *group = enemy.group;
                    for (EnemyBase *child in group.children) {
                        if ([child.class isSubclassOfClass:[EnemyBase class]]) {
                            CGPoint pos = [self.worldPanel convertPoint:child.position fromNode:group];
                            child.group = nil;
                            [child removeFromParent];
                            [self.worldPanel addChild:child];
                            [child setPosition:pos];
                        }
                    }
                    [group removeFromParent];
                }
                SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"EnemyExplode"];
                emitter.position = [self.worldPanel convertPoint:enemy.position fromNode:enemy.parent];
                [emitter setParticleColorSequence:nil];
                [emitter setParticleColor:enemy.color];
                [self.worldPanel addChild:emitter];
                [emitter runAction:[SKAction waitForDuration:0.5f] completion:^{
                    [emitter removeFromParent];
                }];
                [self.arrayEnemies removeObject:enemy];
                [enemy removeFromParent];
            }
            for (int i = (int)self.arrayPoints.count - 1; i >= 0; i --) {
                SKSpriteNode *point = [self.arrayPoints objectAtIndex:i];
                [point removeFromParent];
                [self.arrayPoints removeObject:point];
            }
            for (int i = (int)self.arrayBlackHoles.count - 1; i >= 0; i --) {
                BlackHole *bh = [self.arrayBlackHoles objectAtIndex:i];
                [bh destroy];
                [self.arrayBlackHoles removeObject:bh];
            }
            self.lives --;
        }else if (other.node.physicsBody.categoryBitMask == PhysicType_point){
            //拾取点点
            [other.node removeFromParent];
            self.multiple ++;
            //现实倍数奖励
            BOOL showMutiple = NO;
            if (self.multiple < 150) {
                if (self.multiple % 10 == 0) {
                    showMutiple = YES;
                }
            }else if (self.multiple < 500){
                if (self.multiple % 50 == 0) {
                    showMutiple = YES;
                }
            }else{
                if (self.multiple % 100 == 0) {
                    showMutiple = YES;
                }
            }
            
            if (showMutiple) {
                SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:UIFontName];
                [label setFontSize:20];
                [label setColorBlendFactor:1];
                [label setColor:[UIColor yellowColor]];
                [label setText:[NSString stringWithFormat:@"X%d", self.multiple]];
                label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
                label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
                SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"star5S"];
                [node setZRotation:M_PI_2];
                [node setScale:0.5f];
                [node setPosition:CGPointMake(-10, -1)];
                [node setAnchorPoint:CGPointMake(0.447f, 0.5f)];
                [node setColorBlendFactor:1];
                [node setColor:[UIColor yellowColor]];
                [label addChild:node];
                [label setZPosition:2];
                [self addChild:label];
                //[label setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
                CGPoint pos = [self convertPoint:self.player.position fromNode:self.worldPanel];
                [label setPosition:CGPointMake(pos.x, pos.y + 50)];
                [label setScale:1.5f];
                [label setAlpha:0];
                SKAction *show = [SKAction group:@[[SKAction moveBy:CGVectorMake(0, 100) duration:1], [SKAction fadeInWithDuration:1.5f]]];
                [show setTimingMode:SKActionTimingEaseOut];
                SKAction *hide = [SKAction group:@[[SKAction moveTo:CGPointMake(10, self.size.height - 50) duration:0.35f], [SKAction fadeOutWithDuration:0.35f], [SKAction scaleTo:0.1 duration:0.35f]]];
                //[hide setTimingMode:SKActionTimingEaseInEaseOut];
                [label runAction:[SKAction sequence:@[show, hide]] completion:^{
                    [label removeFromParent];
                }];
            }
        }
        
        [self updateUI];
    }else if (contact.bodyA.categoryBitMask == PhysicType_bullet || contact.bodyB.categoryBitMask == PhysicType_bullet) {
        //子弹碰撞
        SKPhysicsBody *bullet = nil;
        SKPhysicsBody *other = nil;
        if (contact.bodyA.categoryBitMask == PhysicType_bullet) {
            bullet = contact.bodyA;
            other = contact.bodyB;
        }else if (contact.bodyB.categoryBitMask == PhysicType_bullet){
            bullet = contact.bodyB;
            other = contact.bodyA;
        }
        //NSLog(@"bulletNode:%@", bullet.node);
        if (other.categoryBitMask == PhysicType_edge) {
            //边界
            SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"BulletFlash"];
            emitter.position = [self.worldPanel convertPoint:contact.contactPoint fromNode:self];
            [self.worldPanel addChild:emitter];
            int inset = 10;
            float angular = bullet.node.zRotation;
            if (emitter.position.x < -self.worldSize.width/2 + inset || emitter.position.x > self.worldSize.width/2 - inset) {
                angular = M_PI - angular;
            }
            if (emitter.position.y < -self.worldSize.height/2 + inset || emitter.position.y > self.worldSize.height/2 - inset) {
                angular = - angular;
            }
            //        NSLog(@"pos:%f,%f", emitter.position.x, emitter.position.y);
            //        NSLog(@"bulletRotation:%f",bullet.node.zRotation);
            //        NSLog(@"angular:%f", angular);
            [emitter setEmissionAngle:angular];
            [emitter runAction:[SKAction waitForDuration:0.5f] completion:^{
                [emitter removeFromParent];
            }];
            [bullet.node removeFromParent];
        }else if (other.categoryBitMask == PhysicType_enermy){
            EnemyBase *enemy = (EnemyBase *)other.node;
            if (enemy == nil) {
                //碰撞前已经有其他子弹碰撞掉了
                //NSLog(@"empty");
                return;
            }
            [bullet.node removeFromParent];
            if (enemy.group) {
                //在组中
                SKNode *group = enemy.group;
                for (EnemyBase *child in group.children) {
                    if ([child.class isSubclassOfClass:[EnemyBase class]]) {
                        [child breakInGroup:enemy.group toScene:self];
                    }
                }
                [group removeFromParent];
                return;
            }
            enemy.health -= self.player.fireDamage;
            if (enemy.health <= 0) {
                //击破
                self.score += enemy.score * self.multiple;
                [self updateUI];
                SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"EnemyExplode"];
                emitter.position = [self.worldPanel convertPoint:contact.contactPoint fromNode:self];
                [emitter setParticleColorSequence:nil];
                [emitter setParticleColor:enemy.color];
                [self.worldPanel addChild:emitter];
                [emitter runAction:[SKAction waitForDuration:0.5f] completion:^{
                    [emitter removeFromParent];
                }];
                
                //掉落点点
                SKSpriteNode *point = [SKSpriteNode spriteNodeWithImageNamed:@"star5S"];
                [self.worldPanel addChild:point];
                [self.arrayPoints addObject:point];
                [point setPosition:enemy.position];
                [point setColorBlendFactor:1];
                [point setColor:[UIColor colorWithRed:1 green:1 blue:0.8f alpha:1]];
                [point setBlendMode:SKBlendModeAdd];
                [point setAnchorPoint:CGPointMake(0.447f, 0.5f)];
                point.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:80];
                point.physicsBody.restitution = 0;
                point.physicsBody.linearDamping = 0;
                point.physicsBody.angularDamping = 0;
                point.physicsBody.friction = 0;
                point.physicsBody.categoryBitMask = PhysicType_point;
                point.physicsBody.collisionBitMask = PhysicType_edge;
                point.physicsBody.contactTestBitMask = PhysicType_player;
                point.physicsBody.fieldBitMask = FieldType_player;
                point.physicsBody.angularVelocity = getRandom() * 0.5f;
                [point setScale:0.2f];
                SKAction *flash = [SKAction sequence:@[[SKAction fadeAlphaTo:0.35f duration:0.25f], [SKAction fadeAlphaTo:1 duration:0.25f]]];
                SKAction *repeat = [SKAction repeatAction:flash count:6];
                [point runAction:[SKAction sequence:@[repeat, [SKAction fadeOutWithDuration:1]]] completion:^{
                    [point removeFromParent];
                    [self.arrayPoints removeObject:point];
                }];
                
                //移除
                [self.arrayEnemies removeObject:enemy];
                [enemy removeFromParent];
                
            }else{
                //bullet已删
                //[enemy.physicsBody applyImpulse:CGVectorMake(bullet.node.physicsBody.velocity.dx * 0.001, bullet.node.physicsBody.velocity.dy * 0.001) atPoint:[self.worldPanel convertPoint:contact.contactPoint fromNode:self]];
            }
        }else if (other.node.physicsBody.categoryBitMask == PhysicType_blackHole){
            //子弹打黑洞
            BlackHole *blackHole = (BlackHole *)other.node;
            if (blackHole == nil) {
                //碰撞前已经有其他子弹碰撞掉了
                //NSLog(@"empty");
                return;
            }
            [bullet.node removeFromParent];
            
            if (blackHole.strength > 0.2) {
                blackHole.strength -= 0.005;
            }
            if (![blackHole hasActions]) {
                SKAction *seq = [SKAction sequence:@[[SKAction scaleTo:blackHole.strength - 0.03f duration:0.02f], [SKAction scaleTo:blackHole.strength duration:0.07f]]];
                [blackHole runAction:seq];
            }
            blackHole.getDamage += self.player.fireDamage;
            if (blackHole.getDamage >= blackHole.health + blackHole.absorbedEnemies) {
                [self blackHoleExplode:blackHole];
            }
            
            self.score += blackHole.score * self.multiple;
            [self updateUI];
        }
    }
    else if (contact.bodyA.categoryBitMask == PhysicType_blackHole || contact.bodyB.categoryBitMask == PhysicType_blackHole) {
        //黑洞碰撞与敌人碰撞
        BlackHole *blackHole = nil;
        SKPhysicsBody *other = nil;
        if (contact.bodyA.categoryBitMask == PhysicType_blackHole) {
            blackHole = (BlackHole *)contact.bodyA.node;
            other = contact.bodyB;
        }else if (contact.bodyB.categoryBitMask == PhysicType_blackHole){
            blackHole = (BlackHole *)contact.bodyB.node;
            other = contact.bodyA;
        }
        EnemyBase *enemy = (EnemyBase *)other.node;
        if (enemy.group) {
            //在组中
            SKNode *group = enemy.group;
            for (EnemyBase *child in group.children) {
                if ([child.class isSubclassOfClass:[EnemyBase class]]) {
                    [child breakInGroup:enemy.group toScene:self];
                }
            }
            [group removeFromParent];
        }
        
        if (blackHole.strength < 1) {
            blackHole.strength += 0.05;
        }
        if (![blackHole hasActions]) {
            SKAction *seq = [SKAction sequence:@[[SKAction scaleTo:blackHole.strength + 0.03f duration:0.02f], [SKAction scaleTo:blackHole.strength duration:0.07f]]];
            [blackHole runAction:seq];
        }
        blackHole.absorbedEnemies += enemy.health * 5;
        if (blackHole.absorbedEnemies >= blackHole.health) {
            [self blackHoleExplode:blackHole];
        }
        
        [self.arrayEnemies removeObject:enemy];
        [enemy removeFromParent];
    }
}
-(void)blackHoleExplode:(BlackHole *)blackHole{
    for (int i = 0 ; i < blackHole.absorbedEnemies/5; i ++) {
        //NSLog(@"holePos:%f,%f", blackHole.position.x, blackHole.position.y);
        //刷新黑洞产物
        Enemy_Black *enemy = [Enemy_Black create];
        enemy.currentScene = self;
        [self.arrayEnemies addObject:enemy];
        [self.worldPanel addChild:enemy];
        [enemy setPosition:blackHole.position];
        [enemy createPhysicBody];//加到场景后再加物理，否则进不来边界
        [enemy setScale:0.6f];
        //NSLog(@"enemyPos:%f,%f", enemy.position.x, enemy.position.y);
        
        enemy.moveAngular = getRandom() * M_PI * 2;
        enemy.moveSpeed = 0;
        int dis = 200 + getIntRadom(300);
        SKAction *action = [SKAction moveBy:CGVectorMake(cosf(enemy.moveAngular) * dis, sinf(enemy.moveAngular) * dis) duration:2];
        action.timingMode = SKActionTimingEaseOut;
        [enemy runAction:action];
    }
    [blackHole destroy];
    [self.arrayBlackHoles removeObject:blackHole];
}

@end
