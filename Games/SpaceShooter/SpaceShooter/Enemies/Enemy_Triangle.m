//
//  Enemy_Triangle.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/10.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_Triangle.h"
#import "Common.h"

@implementation Enemy_Triangle
+(instancetype)create{
    Enemy_Triangle *node = [Enemy_Triangle spriteNodeWithImageNamed:@"triangle"]; //[[Enemy_Triangle alloc] initWithTexture:[SKTexture textureWithImageNamed:@"triangle"]];
    node.type = EnemyType_Triangle;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor yellowColor]];
    [node setBlendMode:SKBlendModeAdd];
    [node setAnchorPoint:CGPointMake(0.334f, 0.5f)];
    return node;
}
-(void)createPhysicBody{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -7, -15);
    CGPathAddLineToPoint(path, NULL, 18, 0);
    CGPathAddLineToPoint(path, NULL, -7, 15);
    CGPathAddLineToPoint(path, NULL, -7, -15);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    self.physicsBody.restitution = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.friction = 0;
    self.physicsBody.categoryBitMask = PhysicType_enermy;
    self.physicsBody.collisionBitMask = PhysicType_edge;
    self.physicsBody.contactTestBitMask = PhysicType_player | PhysicType_bullet;
    
    CGPathRelease(path);
}
-(void)initData{
    self.score = 1;
    self.health = 1;
    self.physicsBody.angularVelocity = getRandom() + 1.5f;
}
-(void)updateWithDelta:(NSTimeInterval)delta{
//    if (self.isActive) {
//        
//    }
}

@end
