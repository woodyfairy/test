//
//  PlayerSprite.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/3.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "PlayerSprite.h"
#import "Common.h"
#import "DataController.h"

@implementation PlayerSprite

+(PlayerSprite *) create{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -14, 0);
    CGPathAddLineToPoint(path, NULL, -4, 14);
    CGPathAddLineToPoint(path, NULL, 4.6f, 14);
    CGPathAddLineToPoint(path, NULL, 14, 5);
    CGPathAddLineToPoint(path, NULL, 3.8f, 5);
    CGPathAddLineToPoint(path, NULL, 3.8f, -5);
    CGPathAddLineToPoint(path, NULL, 14, -5);
    CGPathAddLineToPoint(path, NULL, 4.6f, -14);
    CGPathAddLineToPoint(path, NULL, -4, -14);
    CGPathAddLineToPoint(path, NULL, -14, 0);
    
//    CGMutablePathRef physicPath = CGPathCreateMutable();
//    CGPathMoveToPoint(physicPath, NULL, -14, 0);
//    CGPathAddLineToPoint(physicPath, NULL, -4, 14);
//    CGPathAddLineToPoint(physicPath, NULL, 4.6f, 14);
//    CGPathAddLineToPoint(physicPath, NULL, 14, 5);
//    CGPathAddLineToPoint(physicPath, NULL, 14, -5);
//    CGPathAddLineToPoint(physicPath, NULL, 4.6f, -14);
//    CGPathAddLineToPoint(physicPath, NULL, -4, -14);
//    CGPathAddLineToPoint(physicPath, NULL, -14, 0);
    
    PlayerSprite *node = [PlayerSprite shapeNodeWithPath:path];
    [node setLineCap:kCGLineCapButt];
    [node setLineWidth:1];
    [node setStrokeColor:[UIColor whiteColor]];
    [node setGlowWidth:1];
    
    //node.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:physicPath];
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:14];//用不规则形状碰到边界会反弹有奇怪的速度不消失
    node.physicsBody.restitution = 0;
    node.physicsBody.linearDamping = 0;
    node.physicsBody.angularDamping = 0;
    node.physicsBody.friction = 0;
    
    CGPathRelease(path);
//    CGPathRelease(physicPath);
    
    node.xScale = 1.5f;
    node.yScale = 1.5f;
    
    UserData *userData = [[DataController instance] getUserData];
    
    int speedLevel = userData.powerUp6Level.shortValue;
    if (speedLevel == 3) {
        node.maxSpeed = 400;
    }else if (speedLevel == 2){
        node.maxSpeed = 350;
    }else if (speedLevel == 1){
        node.maxSpeed = 300;
    }else{
        node.maxSpeed = 250;
    }
    
    node.maxLight = 80;
    node.emitter = [SKEmitterNode nodeWithFileNamed:@"light1"];
    [node addChild:node.emitter];
    [node.emitter setPosition:CGPointMake(-15, 0)];
    node.physicsBody.categoryBitMask = PhysicType_player;
    node.physicsBody.collisionBitMask = PhysicType_edge;
    node.physicsBody.contactTestBitMask = PhysicType_enermy | PhysicType_point | PhysicType_gold | PhysicType_blackHole;
    node.physicsBody.fieldBitMask = FieldType_all - FieldType_player;
    
    node.fireLevel = userData.powerUp0Level.shortValue;
    //node.fireLevel = 1;//test
    if (node.fireLevel >= 4) {
        node.fireInterval = 0.075f;
    }else if (node.fireLevel >=1){
        node.fireInterval = 0.1f;
    }else{
        node.fireInterval = 0.125f;
    }
    if (node.fireLevel >= 3) {
        node.fireDamage = 2;
    }else{
        node.fireDamage = 1;
    }
    
    node.isInvincible = NO;
    
    //加一个引力吸收
    SKFieldNode *field = [SKFieldNode radialGravityField];
    [node addChild:field];
    int rangeLevel = userData.powerUp7Level.shortValue;
    //rangeLevel = 3;//test
    float range = 50;
    field.strength = 1;
    if (rangeLevel == 3) {
        range = 125;
        field.strength = 2;
    }else if (rangeLevel == 2){
        range = 100;
        field.strength = 1.5;
    }else if (rangeLevel == 1){
        range = 75;
    }
    field.region = [[SKRegion alloc] initWithRadius:range];
    field.falloff = 3;
    
    field.categoryBitMask = FieldType_player;
    
    return node;
}

@end
