//
//  Enemy_Circle.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/11.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_Circle.h"
#import "Common.h"

@implementation Enemy_Circle
+(instancetype)create{
    Enemy_Circle *node = [Enemy_Circle spriteNodeWithImageNamed:@"circle"];
    node.type = EnemyType_Circle;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor purpleColor]];
    [node setBlendMode:SKBlendModeAdd];
    return node;
}
-(void)createPhysicBody{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    self.physicsBody.restitution = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.friction = 0;
    self.physicsBody.categoryBitMask = PhysicType_enermy;
    self.physicsBody.collisionBitMask = PhysicType_edge;
    self.physicsBody.contactTestBitMask = PhysicType_player | PhysicType_bullet | PhysicType_blackHole | PhysicType_bomb;
    self.physicsBody.fieldBitMask = FieldType_all - FieldType_player;
}
-(void)initData{
    self.score = 1;
    self.health = 1;
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    if (self.isActive) {
        self.moveAngular = atan2f(self.currentScene.player.position.y - self.position.y, self.currentScene.player.position.x - self.position.x);
        float force = 3;
        [self.physicsBody applyForce:CGVectorMake(cosf(self.moveAngular) * force, sinf(self.moveAngular) * force)];
    }
}

@end
