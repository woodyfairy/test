//
//  BlackHole.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/12.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "BlackHole.h"
#import "Common.h"

@implementation BlackHole

+(instancetype)create{
    BlackHole *node = [BlackHole spriteNodeWithImageNamed:@"blackHole"];
    return node;
}
-(void)spawnInScene:(GameScene *)scene withStrength:(float)strength{
    self.currentScene = scene;
    [self setPosition:[self getRandomPos]];
    
    
    self.strength = strength;
    self.health = self.strength * 100;
    self.score = self.health;
    self.absorbedEnemies = 0;
    self.getDamage = 0;
//    NSLog(@"blackHoleStrength:%f", self.strength);
//    NSLog(@"health:%d", self.health);
    
    [self spawn];
    
}
-(CGPoint) getRandomPos{
    float inset = 100;
    float width = self.currentScene.worldSize.width - inset * 2;
    float height = self.currentScene.worldSize.height - inset * 2;
    return CGPointMake(getRandom() * width - width/2, getRandom() * height - height/2);
}

-(void)spawn{
    [self setScale:0.05f];
    [self runAction:[SKAction scaleTo:self.strength duration:3] completion:^{
        //physicBody
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:45];
        self.physicsBody.restitution = 0;
        self.physicsBody.linearDamping = 0;
        self.physicsBody.angularDamping = 0;
        self.physicsBody.friction = 0;
        self.physicsBody.categoryBitMask = PhysicType_blackHole;
        self.physicsBody.collisionBitMask = PhysicType_none;
        self.physicsBody.contactTestBitMask = PhysicType_player | PhysicType_bullet | PhysicType_enermy | PhysicType_bomb;
        self.physicsBody.fieldBitMask = FieldType_none;
        
        //加一个引力吸收
        self.field = [SKFieldNode radialGravityField];
        [self.parent addChild:self.field];
        [self.field setPosition:self.position];
        self.field.region = [[SKRegion alloc] initWithRadius:300];
        self.field.falloff = 0;
        self.field.strength = 3;
        self.field.categoryBitMask = FieldType_blackHole;
        
        //加粒子
        self.emitter = [SKEmitterNode nodeWithFileNamed:@"BlackHole"];
        [self addChild:self.emitter];
        [self.emitter setFieldBitMask:FieldType_blackHole];
        [self.emitter setTargetNode:self.currentScene.worldPanel];
        //[self.emitter setScale:self.xScale];
    }];
}

-(void)destroy{
    self.physicsBody = nil;
    [self.field removeFromParent];
    self.field = nil;
    [self removeAllActions];
//    [self.emitter setTargetNode:self];
//    [self.emitter setScale:1];
    [self.emitter removeFromParent];
    self.emitter = nil;
    [self runAction:[SKAction scaleTo:0.05f duration:0.1f] completion:^{
        [self removeFromParent];
    }];
}

@end
