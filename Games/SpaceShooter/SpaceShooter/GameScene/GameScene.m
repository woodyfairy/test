//
//  GameScene.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/6/30.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "GameScene.h"
#import "Common.h"
#import "SoundController.h"
#import "DataController.h"
#import "SpawnController.h"
#import "EnemyBase.h"
#import "BlackHole.h"
#import "Enemy_Black.h"

//test
int startLevel = 1;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    //init
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
    
    //敌人控制
    self.arrayEnemies = [[NSMutableArray alloc] init];
    self.arrayBlackHoles = [[NSMutableArray alloc] init];
    self.arrayPoints = [[NSMutableArray alloc] init];
    //self.arrayGolds = [[NSMutableArray alloc] init];
    
    //颜色层
    self.colorCover = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:self.size];
    self.colorCover.alpha = 0;
    [self addChild:self.colorCover];
    [self.colorCover setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self.colorCover setZPosition:3];
    
    self.playing = NO;
    //[self start];
    
    //背景
    [self setBackgroundColor:[UIColor blackColor]];
    self.backgroundNode = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size: self.size];
    [self addChild:self.backgroundNode];
    [self.backgroundNode setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self.backgroundNode setZPosition:-2];
//    SKShader *shader = [SKShader shaderWithFileNamed:@"BackgroundShaer.fsh"];
//    shader.uniforms = @[ [SKUniform uniformWithName:@"size" floatVector3:GLKVector3Make(self.size.width, self.size.height, 0)],
//                         [SKUniform uniformWithName:@"offset" floatVector2:GLKVector2Make(self.worldPanel.position.x - self.size.width/2, self.worldPanel.position.y - self.size.height/2)],
//                         [SKUniform uniformWithName:@"time" float:0],
//                         [SKUniform uniformWithName:@"sinTime12" float:0],
//                         [SKUniform uniformWithName:@"sinTime18" float:0],
//                         [SKUniform uniformWithName:@"sinTime36" float:0] ];
//    [self.backgroundNode setShader:shader];
}
-(void)start{
    //清空所有
    [self clean];
    
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
    [gird setStrokeColor:[UIColor colorWithWhite:1 alpha:0.1f]];
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
    
    //重新刷新
    self.spawnController = nil;
    self.spawnController = [[SpawnController alloc] initWithLevel:startLevel Scene:self];
    self.preTime = 0;
    self.playing = YES;
    
    UserData *userData = [[DataController instance] getUserData];
    //读取数据，刷新UI
    self.score = 0;
    self.multiple = 1;
    self.lives = 1 + userData.powerUp1Level.shortValue;
    self.bombs = 2 + userData.powerUp3Level.shortValue;
    [self updateUI];
    
    [self.view setPaused:NO];
    
    //UI
    [self.scoreLabel setHidden:NO];
    [self.multipleLabel setHidden:NO];
    [self.pauseBtn setHidden:NO];
    [self.bombBtn setHidden:NO];
    [self.playerIcon setHidden:NO];
    [self.livesLabel setHidden:NO];
    [self.bombsLabel setHidden:NO];
    
    //新手引导
    if ([self showLeftGuide] == NO) {
        [self showRightGuide];
    }
    
    //sound
    [[SoundController instance] playBackground:@"BattleBackground"];
}
-(void)end{
    self.playing = false;
    
    //UI
    [self.scoreLabel setHidden:YES];
    [self.multipleLabel setHidden:YES];
    [self.pauseBtn setHidden:YES];
    [self.bombBtn setHidden:YES];
    [self.playerIcon setHidden:YES];
    [self.livesLabel setHidden:YES];
    [self.bombsLabel setHidden:YES];
}
-(void) clean{
    [self.worldPanel removeAllChildren];
    [self.arrayEnemies removeAllObjects];
    [self.arrayBlackHoles removeAllObjects];
    [self.arrayPoints removeAllObjects];
    [self.worldPanel setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    if (self.leftHand) {
        [self.leftHand removeFromParent];
        self.leftHand = nil;
    }
    if (self.leftLabel) {
        [self.leftLabel removeFromParent];
        self.leftLabel = nil;
    }
    if (self.rightHand) {
        [self.rightHand removeFromParent];
        self.rightHand = nil;
    }
    if (self.rightLabel) {
        [self.rightLabel removeFromParent];
        self.rightLabel = nil;
    }
    self.showingLeftGuide = NO;
    self.showingRightGuide = NO;
}
-(void)updateUI{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score:%llu", self.score]];
    [self.multipleLabel setText:[NSString stringWithFormat:@"X%d", self.multiple]];
    [self.livesLabel setText:[NSString stringWithFormat:@"X%d", self.lives]];
    [self.bombsLabel setText:[NSString stringWithFormat:@"X%d", self.bombs]];
}

-(void)GameControllerBeginTouch:(GameControllerView *)controller{
    if (controller == self.leftController) {
        [self finishLeftGuide];
    }else if (controller == self.rightController) {
        [self finishRightGuide];
    }
}
-(void)GameControllerEndTouch:(GameControllerView *)controller{
}

CFTimeInterval countTime = 0;
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //NSLog(@"time:%f", currentTime);
    
    if (self.player && self.playing) {
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
        BOOL cameraMoved = NO;
        CGPoint posInScreen = [self convertPoint:self.player.position fromNode:self.worldPanel];
        if (posInScreen.x < self.size.width/3) {
            self.worldPanel.position = CGPointMake(self.worldPanel.position.x + self.size.width/3 - posInScreen.x, self.worldPanel.position.y);
            cameraMoved = YES;
        }else if (posInScreen.x > self.size.width/3*2){
            self.worldPanel.position = CGPointMake(self.worldPanel.position.x + self.size.width/3*2 - posInScreen.x, self.worldPanel.position.y);
            cameraMoved = YES;
        }
        if (posInScreen.y < self.size.height/5*2) {
            self.worldPanel.position = CGPointMake(self.worldPanel.position.x, self.worldPanel.position.y + self.size.height/5*2 - posInScreen.y);
            cameraMoved = YES;
        }else if (posInScreen.y > self.size.height/5*3){
            self.worldPanel.position = CGPointMake(self.worldPanel.position.x, self.worldPanel.position.y + self.size.height/5*3 - posInScreen.y);
            cameraMoved = YES;
        }
//        if (cameraMoved) {
//            SKUniform *uniform = [self.backgroundNode.shader.uniforms objectAtIndex:1];
//            uniform.floatVector2Value = GLKVector2Make(self.worldPanel.position.x - self.size.width/2, self.worldPanel.position.y - self.size.height/2);
//        }
    }
    
    //间隔时间的
    if (_preTime != 0) {
        CFTimeInterval delta = currentTime - _preTime;
//        if (self.backgroundNode) {
//            SKUniform *timeUniform = [self.backgroundNode.shader.uniforms objectAtIndex:2];
//            timeUniform.floatValue = timeUniform.floatValue + delta;
//            //循环
//            if (timeUniform.floatValue > 72 * M_PI) {
//                timeUniform.floatValue = 0;
//                NSLog(@"time = 0");
//            }
//            float sinTime12 = sinf(timeUniform.floatValue/12.f);
//            float sinTime18 = sinf(timeUniform.floatValue/18.f);
//            float sinTime36 = sinf(timeUniform.floatValue/36.f);
//            SKUniform *sinT12Uniform = [self.backgroundNode.shader.uniforms objectAtIndex:3];
//            SKUniform *sinT18Uniform = [self.backgroundNode.shader.uniforms objectAtIndex:4];
//            SKUniform *sinT36Uniform = [self.backgroundNode.shader.uniforms objectAtIndex:5];
//            sinT12Uniform.floatValue = sinTime12;
//            sinT18Uniform.floatValue = sinTime18;
//            sinT36Uniform.floatValue = sinTime36;
//        }
        //加速的话action动画会有问题
//        if (self.speed < 1) {
//            self.speed += 0.3 * delta;
//        }else if (self.speed > 1){
//            self.speed = 1;
//        }
//        if (self.physicsWorld.speed < 1) {
//            self.physicsWorld.speed += 0.3 * delta;
//        }else if (self.physicsWorld.speed > 1){
//            self.physicsWorld.speed = 1;
//        }
//        delta = delta * self.speed;
        //NSLog(@"time:%f", delta);
        countTime += delta;
        if (countTime >= self.player.fireInterval && self.playing) {
            countTime = 0;
            //玩家子弹
            int bulletNum = 1;
            float angRange = 0;
            if (self.player.fireLevel >= 5) {
                bulletNum = 5;
                angRange = 0.035f;
            }else if (self.player.fireLevel >= 2){
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
                float speed = 500;
                if (self.player.fireLevel >= 4) {
                    speed = 700;
                }else if (self.player.fireLevel >= 1){
                    speed = 600;
                }
                
                bullet.physicsBody.velocity = CGVectorMake(speed*cos(anguler), speed*sin(anguler));
                [self.worldPanel addChild:bullet];
                anguler += angRange/2;
            }
        }
        //刷新控制
        if (self.spawnController && self.playing) {
            [self.spawnController updateWithDelta:delta];
        }
        //敌人控制
        for (EnemyBase *enemy in self.arrayEnemies) {
            if ([enemy respondsToSelector:@selector(updateWithDelta:)]) {
                [enemy updateWithDelta:delta];
            }
        }
        //test
        //NSLog(@"dataController:%@", [[DataController instance] log]);
    }
    
    _preTime = currentTime;
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA == nil || contact.bodyB == nil) {
        //同时有1对n的碰撞已经删掉了
        return;
    }
    UserData *userData = [[DataController instance] getUserData];
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
        if (other.categoryBitMask == PhysicType_enermy || other.node.physicsBody.categoryBitMask == PhysicType_blackHole) {
            if (self.player.isInvincible) {
                //无敌状态
                return;
            }
            [self invincibleWithTime:2.f];//无敌2秒
            
            //if 自动使用炸弹&&炸弹>0，使用炸弹
            if (userData.powerUp5Level.shortValue > 0 && self.bombs > 0) {
                [self useBomb];
                return;
            }
            //玩家碰撞，死掉
            [[SoundController instance] playSound:@"die"];
            [self flashColor:[UIColor redColor]];
            if (self.lives == 0) {
                //最后一命
                [self gameOver];
                [self.player removeFromParent];
                self.player = nil;
                return;
            }else{
                self.lives --;
            }
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
            
        }else if (other.categoryBitMask == PhysicType_point){
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
        
        //拾取星星之后增加生命或者炸弹
        short liveGainLevel = userData.powerUp2Level.shortValue;
        if (liveGainLevel > 0) {
            int gainLiveStar = 0;
            if (liveGainLevel == 1) {
                gainLiveStar = 1000;
            }else if (liveGainLevel == 2){
                gainLiveStar = 900;
            }else if (liveGainLevel == 3){
                gainLiveStar = 700;
            }
            if (self.multiple % gainLiveStar == 0) {
                self.lives ++;
                NSLog(@"liveUP");
            }
        }
        short bombGainLevel = userData.powerUp4Level.shortValue;
        if (bombGainLevel > 0) {
            int gainBombStar = 0;
            if (bombGainLevel == 1) {
                gainBombStar = 880;
            }else if (bombGainLevel == 2){
                gainBombStar = 770;
            }else if (bombGainLevel == 3){
                gainBombStar = 625;
            }
            if (self.multiple % gainBombStar == 0) {
                self.bombs ++;
                NSLog(@"bombUP");
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
                [self killEnemy:enemy];
                
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
                //打破黑洞
                [self blackHoleExplode:blackHole];
                self.score += blackHole.score * self.multiple;
                [self updateUI];
            }
        }
    }else if (contact.bodyA.categoryBitMask == PhysicType_bomb || contact.bodyB.categoryBitMask == PhysicType_bomb){
        //炸弹碰撞
        SKSpriteNode *bomb = nil;
        SKPhysicsBody *other = nil;
        if (contact.bodyA.categoryBitMask == PhysicType_bomb) {
            bomb = (BlackHole *)contact.bodyA.node;
            other = contact.bodyB;
        }else if (contact.bodyB.categoryBitMask == PhysicType_bomb){
            bomb = (BlackHole *)contact.bodyB.node;
            other = contact.bodyA;
        }
        float dis = getDistanceByTwoPosition(bomb.position, other.node.position);
        if (bomb.xScale > 10 && dis < 8 * bomb.xScale) {
            return;//爆炸波已过去太多再刷新到内部的就不触发了（scale10以内，爆炸范围150左右，里面全都消灭）
        }
        if (other.categoryBitMask == PhysicType_enermy){
            //炸弹碰到敌人
            EnemyBase *enemy = (EnemyBase *)other.node;
            if (enemy == nil) {
                //碰撞前已经有其他子弹碰撞掉了
                //NSLog(@"empty");
                return;
            }
            if (enemy.group) {
                SKNode *group = enemy.group;
                for (EnemyBase *child in group.children) {
                    if ([child.class isSubclassOfClass:[EnemyBase class]]) {
                        CGPoint pos = [self.worldPanel convertPoint:child.position fromNode:group];
                        child.group = nil;
                        [child removeFromParent];
                        [self.worldPanel addChild:child];
                        [child setPosition:pos];
                        [self killEnemy:child];
                    }
                }
                [group removeFromParent];
            }else{
                [self killEnemy:enemy];
            }
        }else if (other.categoryBitMask == PhysicType_blackHole){
            //炸弹击破黑洞
            BlackHole *blackHole = (BlackHole *)other.node;
            if (blackHole == nil) {
                //碰撞前已经有其他子弹碰撞掉了
                //NSLog(@"empty");
                return;
            }
            [blackHole destroy];
            [self.arrayBlackHoles removeObject:blackHole];
            self.score += blackHole.score * self.multiple;
            [self updateUI];
        }
    }else if (contact.bodyA.categoryBitMask == PhysicType_blackHole || contact.bodyB.categoryBitMask == PhysicType_blackHole) {
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
//正常击破一个敌人
-(void)killEnemy:(EnemyBase *)enemy{
    self.score += enemy.score * self.multiple;
    [self updateUI];
    SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"EnemyExplode"];
    emitter.position = enemy.position;
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
}
-(void)blackHoleExplode:(BlackHole *)blackHole{
    for (int i = 0 ; i < blackHole.absorbedEnemies/5; i ++) {
        //NSLog(@"holePos:%f,%f", blackHole.position.x, blackHole.position.y);
        //刷新黑洞产物
        Enemy_Black *enemy = [Enemy_Black create];
        enemy.moveAngular = getRandom() * M_PI * 2;
        enemy.moveSpeed = 0;
        [enemy setPosition:CGPointMake(blackHole.position.x + cosf(enemy.moveAngular)*20, blackHole.position.y + sinf(enemy.moveAngular) * 20)];//要先设定坐标，否则会不对
        enemy.currentScene = self;
        [self.arrayEnemies addObject:enemy];
        [self.worldPanel addChild:enemy];
        [enemy createPhysicBody];//加到场景后再加物理，否则进不来边界
        [enemy setScale:0.6f];
        //NSLog(@"enemyPos:%f,%f", enemy.position.x, enemy.position.y);
        
        
        int dis = 200 + getIntRadom(300);
        SKAction *action = [SKAction moveBy:CGVectorMake(cosf(enemy.moveAngular) * dis, sinf(enemy.moveAngular) * dis) duration:2];
        action.timingMode = SKActionTimingEaseOut;
        [enemy runAction:action];
        
        
    }
    [blackHole destroy];
    [self.arrayBlackHoles removeObject:blackHole];
}
-(void)flashColor:(UIColor *)color{
    self.colorCover.alpha = 0;
    [self.colorCover removeAllActions];
    [self.colorCover setColor:color];
    SKAction *seq = [SKAction sequence:@[[SKAction fadeAlphaTo:0.4f duration:0.075f], [SKAction fadeOutWithDuration:0.3f]]];
    [self.colorCover runAction:seq];
}

-(void)useBomb{
    if (self.bombs <= 0) {
        return;
    }
    self.bombs --;
    [self updateUI];
    [self flashColor:[UIColor whiteColor]];
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
    [node setColorBlendFactor:1];
    [node setColor:[UIColor whiteColor]];
    [node setBlendMode:SKBlendModeAdd];
    [self.worldPanel addChild:node];
    [node setPosition:self.player.position];
    node.zPosition = 1;
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    node.physicsBody.restitution = 0;
    node.physicsBody.linearDamping = 0;
    node.physicsBody.angularDamping = 0;
    node.physicsBody.friction = 0;
    node.physicsBody.categoryBitMask = PhysicType_bomb;
    node.physicsBody.collisionBitMask = PhysicType_none;
    node.physicsBody.contactTestBitMask = PhysicType_enermy | PhysicType_blackHole;
    node.physicsBody.fieldBitMask = FieldType_none;
    
    float scale = 200;
    float actionTime = 2.6f;
    SKAction *actionBomb = [SKAction group:@[[SKAction scaleTo:scale duration:actionTime], [SKAction fadeAlphaTo:0 duration:actionTime]]];
    //[actionBomb setTimingMode:SKActionTimingEaseIn];
    [node setAlpha:0.5f];
    [node runAction:actionBomb completion:^{
        [node removeFromParent];
    }];
    
    [[SoundController instance] playSound:@"bomb"];
}

-(void)invincibleWithTime:(float)seconds{
    [self.player setIsInvincible:YES];
    SKAction *flashAction = [SKAction sequence:@[[SKAction fadeAlphaTo:0.1f duration:0.1f], [SKAction fadeAlphaTo:0.5f duration:0.1f]]];
    [self.player runAction:[SKAction repeatActionForever:flashAction]];
    [self.player runAction:[SKAction waitForDuration:seconds] completion:^{
        [self.player removeAllActions];
        [self.player setAlpha:1];
        [self.player setIsInvincible:NO];
    }];
}

-(void)gameOver{
    //return;//test
    [self end];
    
    //记录数据
    BOOL newRecord = NO;
    UserData *userData = [[DataController instance] getUserData];
//    NSLog(@"score:%lld", self.score);
//    NSLog(@"recoredScore:%lld", userData.topScore.longLongValue);
    if (self.score > userData.topScore.longLongValue) {
        userData.topScore = [NSNumber numberWithLongLong:self.score];
        newRecord = YES;
    }
    userData.totalStar = [NSNumber numberWithLongLong:userData.totalStar.longLongValue + self.multiple];
    userData.currentStar = [NSNumber numberWithLongLong:userData.currentStar.intValue + self.multiple];
    [[DataController instance] saveContext];
    
    //显示页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameOverNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:newRecord] forKey:@"NewRecordKey"]];
    
    //更新gamecenter
    if (newRecord) {
        //更新最高分
        [[DataController instance] reportScore:userData.topScore.longLongValue forLeaderboardIdentifier:LeaderboardIdentifier_Score];
    }
    //更新总星星
    [[DataController instance] reportScore:userData.totalStar.longLongValue forLeaderboardIdentifier:LeaderboardIdentifier_Star];
}

#pragma mark - 新手指引
-(BOOL)showLeftGuide{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LeftGuideFinish"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftGuideFinish"] boolValue]) {
        self.showingLeftGuide = NO;
        return NO;
    }
    
    if (self.showingLeftGuide == NO) {
        self.leftHand = [SKSpriteNode spriteNodeWithImageNamed:@"GuideHand"];
        [self.leftHand setAnchorPoint:CGPointMake(0.6f, 0.78f)];
        [self.leftHand setPosition:CGPointMake(self.size.width/4, self.size.height/3)];
        [self.leftHand setScale:2];
        [self.leftHand setAlpha:0];
        SKAction *pushAction = [SKAction group:@[ [SKAction fadeAlphaTo:1 duration:0.35f], [SKAction scaleTo:1 duration:0.35f] ]];
        SKAction *moveAction = [SKAction group:@[ [SKAction moveBy:CGVectorMake(100, 0) duration:0.75f], [SKAction fadeAlphaTo:0 duration:0.75f] ]];
        SKAction *resetAction = [SKAction group:@[ [SKAction scaleTo:2 duration:0.1f], [SKAction moveBy:CGVectorMake(-100, 0) duration:0.1f] ]];
        SKAction *seqAction = [SKAction sequence:@[ pushAction, [SKAction waitForDuration:0.3f], moveAction, resetAction] ];
        [self.leftHand runAction:[SKAction repeatActionForever:seqAction]];
        [self addChild:self.leftHand];
        
        self.leftLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"guide_left", @"")];
        [self.leftLabel setFontSize:30];
        [self.leftLabel setFontColor:[UIColor whiteColor]];
        [self.leftLabel setPosition:CGPointMake(self.size.width/4, self.size.height/5*3)];
        SKAction *flash = [SKAction sequence:@[ [SKAction fadeAlphaTo:0.3f duration:0.35f], [SKAction fadeAlphaTo:1 duration:0.35f] ]];
        [self.leftLabel runAction:[SKAction repeatActionForever:flash]];
        [self addChild:self.leftLabel];
    }
    
    self.showingLeftGuide = YES;
    return YES;
}
-(BOOL)showRightGuide{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RightGuideFinish"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"RightGuideFinish"] boolValue]) {
        self.showingRightGuide = NO;
        return NO;
    }
    
    if (self.showingRightGuide == NO) {
        self.rightHand = [SKSpriteNode spriteNodeWithImageNamed:@"GuideHand"];
        [self.rightHand setAnchorPoint:CGPointMake(0.6f, 0.78f)];
        [self.rightHand setPosition:CGPointMake(self.size.width/4 * 3, self.size.height/3)];
        [self.rightHand setXScale:-2];
        [self.rightHand setYScale:2];
        [self.rightHand setAlpha:0];
        SKAction *pushAction = [SKAction group:@[ [SKAction fadeAlphaTo:1 duration:0.35f], [SKAction scaleXTo:-1 y:1 duration:0.35f] ]];
        SKAction *moveAction = [SKAction group:@[ [SKAction moveBy:CGVectorMake(-100, 0) duration:0.75f], [SKAction fadeAlphaTo:0 duration:0.75f] ]];
        SKAction *resetAction = [SKAction group:@[ [SKAction scaleXTo:-2 y:2 duration:0.1f], [SKAction moveBy:CGVectorMake(100, 0) duration:0.1f] ]];
        SKAction *seqAction = [SKAction sequence:@[ pushAction, [SKAction waitForDuration:0.3f], moveAction, resetAction] ];
        [self.rightHand runAction:[SKAction repeatActionForever:seqAction]];
        [self addChild:self.rightHand];
        
        self.rightLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"guide_right", @"")];
        [self.rightLabel setFontSize:30];
        [self.rightLabel setFontColor:[UIColor whiteColor]];
        [self.rightLabel setPosition:CGPointMake(self.size.width/4*3, self.size.height/5*3)];
        SKAction *flash = [SKAction sequence:@[ [SKAction fadeAlphaTo:0.3f duration:0.35f], [SKAction fadeAlphaTo:1 duration:0.35f] ]];
        [self.rightLabel runAction:[SKAction repeatActionForever:flash]];
        [self addChild:self.rightLabel];
    }
    
    self.showingRightGuide = YES;
    return YES;
}
-(void)finishLeftGuide{
    if (self.showingLeftGuide) {
        self.showingLeftGuide = NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"LeftGuideFinish"];
        [self.leftHand removeFromParent];
        [self.leftLabel runAction:[SKAction waitForDuration:1.5f] completion:^{
            [self.leftLabel removeAllActions];
            [self.leftLabel setAlpha:1];
            [self.leftLabel runAction:[SKAction fadeAlphaTo:0 duration:0.5f] completion:^{
                [self.leftLabel removeFromParent];
                [self showRightGuide];
            }];
        }];
    }
}
-(void)finishRightGuide{
    if (self.showingRightGuide) {
        self.showingRightGuide = NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"RightGuideFinish"];
        [self.rightHand removeFromParent];
        [self.rightLabel runAction:[SKAction waitForDuration:1.5f] completion:^{
            [self.rightLabel removeAllActions];
            [self.rightLabel setAlpha:1];
            [self.rightLabel runAction:[SKAction fadeAlphaTo:0 duration:0.5f] completion:^{
                [self.rightLabel removeFromParent];
            }];
        }];
    }
}








@end

















