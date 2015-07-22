//
//  Enemy_5Side.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/11.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_3star.h"
#import "Common.h"

@implementation Enemy_3star
+(instancetype)create{
    Enemy_3star *node = [Enemy_3star spriteNodeWithImageNamed:@"star3R"];
    node.type = EnemyType_3star;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor greenColor]];
    [node setBlendMode:SKBlendModeAdd];
    [node setAnchorPoint:CGPointMake(0.334f, 0.5f)];
    return node;
}
-(void)createPhysicBody{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -8, -15);
    CGPathAddLineToPoint(path, NULL, 17, 0);
    CGPathAddLineToPoint(path, NULL, -8, 15);
    CGPathAddLineToPoint(path, NULL, -8, -15);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    self.physicsBody.restitution = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.friction = 0;
    self.physicsBody.categoryBitMask = PhysicType_enermy;
    self.physicsBody.collisionBitMask = PhysicType_edge;
    self.physicsBody.contactTestBitMask = PhysicType_player | PhysicType_bullet | PhysicType_blackHole | PhysicType_bomb;
    self.physicsBody.fieldBitMask = FieldType_all - FieldType_player;
    
    CGPathRelease(path);
}
-(void)initData{
    self.score = 1;
    self.health = 1;
    
    self.moveSpeed = 250;
    if (self.moveAngular == 0) {
        self.moveAngular = getRandom() * M_PI * 2;
    }
    self.physicsBody.angularVelocity = getRandom() + 2;
    
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    if (self.isActive) {
        float angelSpeed = 1.f;
        //角度
        float desAngel = atan2f(self.currentScene.player.position.y - self.position.y, self.currentScene.player.position.x - self.position.x);
        float deltaAng = desAngel - self.moveAngular;
        while (deltaAng > M_PI) {
            deltaAng -= M_PI * 2;
        }
        while (deltaAng <= -M_PI) {
            deltaAng += M_PI * 2;
        }
        if (deltaAng > -0.05f && deltaAng < 0.05f) {
            self.moveAngular = desAngel;
        }else if (deltaAng < 0) {
            self.moveAngular -= angelSpeed * delta;
        }else if (deltaAng > 0) {
            self.moveAngular += angelSpeed * delta;
        }
        
        self.physicsBody.velocity = CGVectorMake(cosf(self.moveAngular) * self.moveSpeed, sinf(self.moveAngular) * self.moveSpeed);
        
    }
}
@end
