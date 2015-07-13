//
//  Enemy_Box.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/11.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_Box.h"
#import "Common.h"

@implementation Enemy_Box
+(instancetype)create{
    Enemy_Box *node = [Enemy_Box spriteNodeWithImageNamed:@"box"];
    node.type = EnemyType_Box;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor blueColor]];
    [node setBlendMode:SKBlendModeAdd];
    return node;
}
-(void)createPhysicBody{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(32, 32)];
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
    self.physicsBody.angularVelocity = getRandom() + 1.5f;
    self.moveSpeed = 120;
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    if (self.isActive) {
        self.moveAngular = atan2f(self.currentScene.player.position.y - self.position.y, self.currentScene.player.position.x - self.position.x);
        self.physicsBody.velocity = CGVectorMake(cosf(self.moveAngular) * self.moveSpeed, sinf(self.moveAngular) * self.moveSpeed);
    }
}

@end
