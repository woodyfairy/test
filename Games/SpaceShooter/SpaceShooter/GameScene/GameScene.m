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
    self.spawnController = [[SpawnController alloc] initWithLevel:1 Scene:self];
    self.arrayEnemies = [[NSMutableArray alloc] init];
    
    //UI
    self.score = 0;
    self.multiple = 1;
    self.lives = 1;
    self.bombs = 1;
    [self updateUI];
}
-(void)updateUI{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score:%ld", self.score]];
    [self.multipleLabel setText:[NSString stringWithFormat:@"x%d", self.multiple]];
    [self.livesLabel setText:[NSString stringWithFormat:@"x%d", self.lives]];
    [self.bombsLabel setText:[NSString stringWithFormat:@"x%d", self.bombs]];
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
//    
//    NSLog(@"pos:%f,%f", self.position.x, self.position.y);
//    NSLog(@"size:%f,%f", self.size.width, self.size.height);
//}

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
                bullet.physicsBody.contactTestBitMask = PhysicType_edge | PhysicType_enermy;
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
    if (contact.bodyA.categoryBitMask == PhysicType_player || contact.bodyB.categoryBitMask == PhysicType_player) {
        //玩家碰撞，死掉
        for (int i = (int)self.arrayEnemies.count - 1; i >= 0; i --) {
            EnemyBase *enemy = [self.arrayEnemies objectAtIndex:i];
            SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"EnemyExplode"];
            emitter.position = [self.worldPanel convertPoint:contact.contactPoint fromNode:self];
            [emitter setParticleColorSequence:nil];
            [emitter setParticleColor:enemy.color];
            [self.worldPanel addChild:emitter];
            [emitter runAction:[SKAction waitForDuration:0.5f] completion:^{
                [emitter removeFromParent];
            }];
            [self.arrayEnemies removeObject:enemy];
            [enemy removeFromParent];
        }
        self.lives --;
        [self updateUI];
        return;
    }
    
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
            self.score += enemy.score;
            [self updateUI];
            SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"EnemyExplode"];
            emitter.position = [self.worldPanel convertPoint:contact.contactPoint fromNode:self];
            [emitter setParticleColorSequence:nil];
            [emitter setParticleColor:enemy.color];
            [self.worldPanel addChild:emitter];
            [emitter runAction:[SKAction waitForDuration:0.5f] completion:^{
                [emitter removeFromParent];
            }];
            
            [self.arrayEnemies removeObject:enemy];
            [enemy removeFromParent];
        }else{
            //[enemy.physicsBody applyImpulse:CGVectorMake(bullet.node.physicsBody.velocity.dx * 0.001, bullet.node.physicsBody.velocity.dy * 0.001) atPoint:[self.worldPanel convertPoint:contact.contactPoint fromNode:self]];
        }
        [bullet.node removeFromParent];
        
        
    }
}

@end
