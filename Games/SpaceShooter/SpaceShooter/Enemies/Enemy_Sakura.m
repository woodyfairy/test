//
//  Enemy_Sakura.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/23.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_Sakura.h"
#import "Common.h"

@implementation Enemy_Sakura
+(instancetype)create{
    Enemy_Sakura *node = [Enemy_Sakura spriteNodeWithImageNamed:@"flower"];
    node.type = EnemyType_Box;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor colorWithRed:1 green:0.75 blue:0.75 alpha:1]];
    [node setBlendMode:SKBlendModeAdd];
    return node;
}
-(void)createPhysicBody{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(22, 12)];
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
    self.score = 2;
    self.health = 1;
    if (self.moveSpeed == 0) {
        self.moveSpeed = 600;
    }
    if (self.moveAngular == 0) {
        self.moveAngular = getRandom() * M_PI * 2;
    }
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    if (self.isActive && self.currentScene.player) {
        if (self.state == MoveState_speedUp) {
            if (self.moveSpeed < 600) {
                self.moveSpeed += 400.f * delta;
            }else{
                self.state = MoveState_speedDown;
            }
        }else if (self.state == MoveState_speedDown) {
            if (self.moveSpeed > 0) {
                self.moveSpeed -= 500.f * delta;
            }else{
                self.moveSpeed = 0;
                self.state = MoveState_searching;
            }
            if (self.physicsBody.angularVelocity > 0) {
                self.physicsBody.angularVelocity -= 1.f * delta;
            }else{
                self.physicsBody.angularVelocity = 0;
            }
        }else if (self.state == MoveState_searching){
            //角度
            if ([self hasActions]) {
                return;
            }
            float desAngel = atan2f(self.currentScene.player.position.y - self.position.y, self.currentScene.player.position.x - self.position.x);
            float deltaAng = desAngel - self.zRotation;
            while (deltaAng > M_PI) {
                deltaAng -= M_PI * 2;
            }
            while (deltaAng <= -M_PI) {
                deltaAng += M_PI * 2;
            }
            SKAction *rotAction = [SKAction rotateByAngle:deltaAng duration:0.8f];
            [self runAction:rotAction completion:^{
                self.moveAngular = self.zRotation;
                self.state = MoveState_speedUp;
            }];
        }
        if (self.state == MoveState_speedUp || self.state == MoveState_speedDown) {
            self.physicsBody.velocity = CGVectorMake(cosf(self.moveAngular) * self.moveSpeed, sinf(self.moveAngular) * self.moveSpeed);
        }
    }
}

@end
