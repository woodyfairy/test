//
//  EnemyBase.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/9.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "EnemyBase.h"

@implementation EnemyBase
-(void)spawnInScene:(GameScene *)scene onPosition:(CGPoint)pos{
    self.currentScene = scene;
    [self setPosition:pos];
    [self spawn];
    _isActive = NO;
}
-(void)spawnInGroup:(SKNode *)group onPosition:(CGPoint)pos{
    self.group = group;
    [self setPosition:pos];
    [self spawn];
    _isActive = NO;
}
-(void)breakInGroup:(SKNode *)group toScene:(GameScene *)scene{
    CGPoint pos = [self.group convertPoint:self.position toNode:scene];
    CGPoint toPos = [self.group convertPoint:CGPointMake(self.position.x * 10, self.position.y * 10) toNode:scene];
    self.group = nil;
    self.currentScene = scene;
    [self.currentScene addChild:self];
    [self setPosition:pos];
    _isActive = YES;
    SKAction *action = [SKAction moveBy:CGVectorMake(toPos.x - pos.x, toPos.y - pos.y) duration:0.2f];
    action.timingMode = SKActionTimingEaseOut;
    [self runAction:action];
}


-(void)spawn{
    [self initData];
    [self setAlpha:0];
    float timeInterval = 0.1f;
    float count = 5;
    SKAction *spawnAction = [SKAction sequence:@[[SKAction waitForDuration:timeInterval],[SKAction performSelector:@selector(newSprite) onTarget:self]]];
    SKAction *repeat = [SKAction repeatAction:spawnAction count:count];
    [self runAction:repeat];
    
    SKAction *activeAction = [SKAction sequence:@[[SKAction waitForDuration:timeInterval * count + 0.5f], [SKAction fadeInWithDuration:0.1f]]];
    [self runAction:activeAction completion:^{
        if (self.scene) {
            _isActive = YES;
            [self createPhysicBody];
        }
    }];
    
}
-(void)newSprite{
    float time1 = 0.5f;
    float time2 = 0.3f;
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithTexture:self.texture];
    [node setAnchorPoint:self.anchorPoint];
    [node setColorBlendFactor:self.colorBlendFactor];
    [node setColor:self.color];
    [node setZRotation:self.zRotation];
    [node setAlpha:0];
    [node setScale:4];
    [node setPosition:self.position];
    [self.parent addChild:node];
    SKAction *action = [SKAction sequence:@[[SKAction group:@[[SKAction scaleTo:1 duration:time1],[SKAction fadeInWithDuration:time1]]], [SKAction fadeOutWithDuration:time2]]];
    [node runAction:action completion:^{
        [node removeFromParent];
    }];
}


////子类必须实现的方法
+(instancetype) create{
    return nil;
}
-(void) createPhysicBody{
    
}
-(void) initData{
    
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    
}
@end
