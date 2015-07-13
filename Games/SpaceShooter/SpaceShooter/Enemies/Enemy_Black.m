//
//  Enemy_Black.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/13.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "Enemy_Black.h"
#import "Common.h"

@implementation Enemy_Black
+(instancetype)create{
    Enemy_Black *node = [Enemy_Black spriteNodeWithImageNamed:@"circle"];
    node.type = EnemyType_Black;
    [node setColorBlendFactor:1];
    [node setColor:[UIColor blackColor]];
    
    //直接刷新
    [node initData];
    
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
    self.physicsBody.fieldBitMask = FieldType_none;
}
-(void)initData{
    self.score = 5;
    self.health = 1;
}
-(void)updateWithDelta:(NSTimeInterval)delta{
    self.moveSpeed += 100 * delta;
    self.moveAngular = atan2f(self.currentScene.player.position.y - self.position.y, self.currentScene.player.position.x - self.position.x);
    self.physicsBody.velocity = CGVectorMake(cosf(self.moveAngular) * self.moveSpeed, sinf(self.moveAngular) * self.moveSpeed);
}
@end
