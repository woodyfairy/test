//
//  Enemy_Arrow.m
//  SpaceShooter
//
//  Created by wdy iMac on 15/7/12.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_Arrow.h"
#import "Common.h"

@implementation Enemy_Arrow
+(instancetype)create{
    Enemy_Arrow *node = [Enemy_Arrow spriteNodeWithImageNamed:@"arrow"];
    node.type = EnemyType_Arrow;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor orangeColor]];
    [node setBlendMode:SKBlendModeAdd];
    return node;
}
-(void)createPhysicBody{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -16, -13);
    CGPathAddLineToPoint(path, NULL, 14, 0);
    CGPathAddLineToPoint(path, NULL, -16, 13);
    CGPathAddLineToPoint(path, NULL, -16, -13);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    self.physicsBody.restitution = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.friction = 0;
    self.physicsBody.categoryBitMask = PhysicType_enermy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = PhysicType_player | PhysicType_bullet | PhysicType_blackHole;
    self.physicsBody.fieldBitMask = FieldType_none;//不受任何力场影响 //FieldType_all - FieldType_player;
    
    CGPathRelease(path);
}
-(void)initData{
    self.score = 1;
    self.health = 1;
    
    self.emitter = [SKEmitterNode nodeWithFileNamed:@"light1"];
    [self addChild:self.emitter];
    [self.emitter setPosition:CGPointMake(-13, 0)];
    self.emitter.particleBirthRate = 100;
    self.emitter.particleColorSequence = nil;
    self.emitter.particleColor = [UIColor orangeColor];
    [self.emitter setTargetNode:self.parent];
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    if (self.isActive) {
        float acceleration = 350; //加速度
        if (self.direction == MoveDirection_horizontal) {
            //水平移动
            if (self.position.x < 0) {
                self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx + acceleration * delta, self.physicsBody.velocity.dy);
            }
            if (self.position.x > 0) {
                self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx - acceleration * delta, self.physicsBody.velocity.dy);
            }
            if (self.physicsBody.velocity.dx > 0) {
                self.zRotation = 0;
            }
            if (self.physicsBody.velocity.dx < 0) {
                self.zRotation = M_PI;
            }
        }else{
            //垂直运动
            if (self.position.y < 0) {
                self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, self.physicsBody.velocity.dy + acceleration * delta);
            }
            if (self.position.y > 0) {
                self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, self.physicsBody.velocity.dy - acceleration * delta);
            }
            if (self.physicsBody.velocity.dy > 0) {
                self.zRotation = M_PI_2;
            }
            if (self.physicsBody.velocity.dy < 0) {
                self.zRotation = -M_PI_2;
            }
        }
        self.emitter.particleRotation = self.zRotation + M_PI_2;
        self.emitter.emissionAngle = self.zRotation + M_PI;
    }
}
@end
