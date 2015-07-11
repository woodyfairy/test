//
//  Enemy_5Side.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/11.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_5Side.h"
#import "Common.h"

@implementation Enemy_5Side
+(instancetype)create{
    Enemy_5Side *node = [Enemy_5Side spriteNodeWithImageNamed:@"5side"];
    node.type = EnemyType_Circle;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor cyanColor]];
    [node setBlendMode:SKBlendModeAdd];
    [node setAnchorPoint:CGPointMake(0.447f, 0.5f)];
    return node;
}
-(void)createPhysicBody{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    self.physicsBody.restitution = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.friction = 0;
    self.physicsBody.categoryBitMask = PhysicType_enermy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = PhysicType_player | PhysicType_bullet;
    self.physicsBody.fieldBitMask = FieldType_all - FieldType_player;
}
-(void)initData{
    self.score = 1;
    self.health = 1;
    
    self.physicsBody.restitution = 1;
    self.physicsBody.angularVelocity = getRandom() * 0.5f;
    self.moveSpeed = 100 + getRandom() * 100;
    self.moveAngular = getRandom() * M_PI * 2;
    self.physicsBody.velocity = CGVectorMake(cosf(self.moveAngular) * self.moveSpeed, sinf(self.moveAngular) * self.moveSpeed);
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    if (self.isActive) {
        if (self.position.x < -self.currentScene.worldSize.width/2 + 20 && self.physicsBody.velocity.dx < 0) {
            self.physicsBody.velocity = CGVectorMake(-self.physicsBody.velocity.dx, self.physicsBody.velocity.dy);
            self.position = CGPointMake(-self.currentScene.worldSize.width/2 + 20, self.position.y);
        }else if (self.position.x > self.currentScene.worldSize.width/2 - 20 && self.physicsBody.velocity.dx > 0){
            self.physicsBody.velocity = CGVectorMake(-self.physicsBody.velocity.dx, self.physicsBody.velocity.dy);
            self.position = CGPointMake(self.currentScene.worldSize.width/2 - 20, self.position.y);
        }
        if (self.position.y < -self.currentScene.worldSize.height/2 + 20 && self.physicsBody.velocity.dy < 0) {
            self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, -self.physicsBody.velocity.dy);
            self.position = CGPointMake(self.position.x, -self.currentScene.worldSize.height/2 + 20);
        }else if (self.position.y > self.currentScene.worldSize.height/2 - 20 && self.physicsBody.velocity.dy > 0){
            self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, -self.physicsBody.velocity.dy);
            self.position = CGPointMake(self.position.x, self.currentScene.worldSize.height/2 - 20);
        }
    }
}
@end
