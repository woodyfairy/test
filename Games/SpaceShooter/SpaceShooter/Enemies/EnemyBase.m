//
//  EnemyBase.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/9.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "EnemyBase.h"
#import "Common.h"

@implementation EnemyBase
-(void)spawnInScene:(GameScene *)scene onPosition:(CGPoint)pos{
    self.currentScene = scene;
    self.group = nil;
    [self setPosition:pos];
    _isActive = NO;
    [self spawn];
}
-(void)spawnInGroup:(SKNode *)group onPosition:(CGPoint)pos{
    self.currentScene = nil;
    self.group = group;
    [self setPosition:pos];
    _isActive = NO;
    [self spawn];
}
-(void)breakInGroup:(SKNode *)group toScene:(GameScene *)scene{
    self.currentScene = scene;
    CGPoint pos = [self.parent convertPoint:self.position toNode: self.currentScene.worldPanel];
    NSLog(@"pos1:%@", NSStringFromCGPoint(pos));
    CGPoint toPos = [self.parent convertPoint:CGPointMake(self.position.x * 12, self.position.y * 12) toNode: self.currentScene.worldPanel];
    self.group = nil;
    [self removeFromParent];
    [self setPosition: pos];//必须先设定位置，再addChild...
    [self.currentScene.worldPanel addChild:self];
    _isActive = YES;
    [self initData];
    self.physicsBody.fieldBitMask = FieldType_all - FieldType_player;
    SKAction *action = [SKAction moveBy:CGVectorMake(toPos.x - pos.x, toPos.y - pos.y) duration:0.8f];
    action.timingMode = SKActionTimingEaseOut;
    [self runAction:action];
    NSLog(@"pos2:%@", NSStringFromCGPoint(self.position));
}


-(void)spawn{
    //[self setShader:[SKShader shaderWithFileNamed:@"EnemyShaer.fsh"]];
    [self setAlpha:0];
    float timeInterval = 0.1f;
    float count = 5;
    SKAction *spawnAction = [SKAction sequence:@[[SKAction waitForDuration:timeInterval],[SKAction performSelector:@selector(newSprite) onTarget:self]]];
    SKAction *repeat = [SKAction repeatAction:spawnAction count:count];
    [self runAction:repeat];
    
    SKAction *activeAction = [SKAction sequence:@[[SKAction waitForDuration:timeInterval * count + 0.5f], [SKAction fadeInWithDuration:0.2f]]];
    [self runAction:activeAction completion:^{
        [self createPhysicBody];
        if (self.currentScene) {
            _isActive = YES;
            [self initData];
        }else{
            self.physicsBody.fieldBitMask = FieldType_none;
        }
    }];
}
-(void)newSprite{
    float time1 = 0.5f;
    float time2 = 0.2f;
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithTexture:self.texture];
    [node setShader:self.shader];
    [node setAnchorPoint:self.anchorPoint];
    [node setColorBlendFactor:self.colorBlendFactor];
    [node setColor:self.color];
    [node setBlendMode:self.blendMode];
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
