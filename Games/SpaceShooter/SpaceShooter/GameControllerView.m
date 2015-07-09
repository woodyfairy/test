//
//  GameControllerView.m
//  SpaceShooter
//
//  Created by WuDongyang on 15/7/2.
//  Copyright (c) 2015年 WuDongyang. All rights reserved.
//

#import "GameControllerView.h"

@implementation GameControllerView

-(void)didMoveToSuperview{
    self.multipleTouchEnabled = false;
    if (self.circleBack == nil) {
        self.circleBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ControllerCircle_backCircle"]];
        [self.circleBack setAlpha:0];
        
    }
    if (self.circleArrow == nil) {
        self.circleArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ControllerCircle_arrowCircle"]];
        [self.circleArrow setAlpha:0];
        [self.circleArrow setFrame:self.circleBack.bounds];
    }
    [self addSubview:self.circleBack];
    [self.circleBack addSubview:self.circleArrow];
    
    if (self.minRange == 0) {
        self.minRange = 50;
    }
    if (self.maxRange == 0) {
        self.maxRange = 100;
    }
    
    _isTouching = NO;
}
-(void)setMaxRange:(float)maxRange{
    _maxRange = maxRange;
    CGPoint center = self.circleBack.center;
    [self.circleBack setFrame:CGRectMake(0, 0, self.maxRange * 2, self.maxRange * 2)];
    [self.circleBack setCenter:center];
    [self.circleArrow setFrame:self.circleBack.bounds];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouching = YES;
    NSArray *arr = [touches allObjects];
    UITouch *touch = [arr objectAtIndex:0];
    CGPoint pos = [touch locationInView:self];
    if (pos.x < self.minRange || pos.x > self.frame.size.width - self.minRange) {
        return;
    }
    if (pos.y < self.minRange || pos.y > self.frame.size.height - self.minRange) {
        return;
    }
    [self.circleBack setCenter:pos];
    [self.circleArrow setAlpha:0];
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.circleBack.alpha = 1;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GameControllerBeginTouch:)]) {
        [self.delegate GameControllerBeginTouch: self];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *arr = [touches allObjects];
    UITouch *touch = [arr objectAtIndex:0];
    CGPoint pos = [touch locationInView:self];
    float range = sqrtf( (pos.y - self.circleBack.center.y) * (pos.y - self.circleBack.center.y) + (pos.x - self.circleBack.center.x) * (pos.x - self.circleBack.center.x) );
    if (range < self.minRange) {
        return;
    }else if (range >= self.minRange) {
        self.arc = atan2f(pos.y - self.circleBack.center.y, pos.x - self.circleBack.center.x);
        self.circleArrow.transform = CGAffineTransformMakeRotation(self.arc);
        float correctRange = range;
        if (correctRange > self.maxRange) {
            correctRange = self.maxRange;
        }
        self.value = (correctRange - self.minRange) / (self.maxRange - self.minRange);
        self.circleArrow.alpha = self.value;
        
        if (range > self.maxRange) {
            CGPoint centerOffset = CGPointMake(cosf(self.arc) * (range - self.maxRange), sinf(self.arc) * (range - self.maxRange));
            CGPoint newCenter = CGPointMake(self.circleBack.center.x + centerOffset.x, self.circleBack.center.y + centerOffset.y);
            if (newCenter.x - self.maxRange < 0 && centerOffset.x <= 0) {
                newCenter.x = self.circleBack.center.x;
            }else if (newCenter.x + self.maxRange > self.bounds.size.width && centerOffset.x >= 0){
                newCenter.x = self.circleBack.center.x;
            }
            if (newCenter.y - self.maxRange < 0 && centerOffset.y <= 0) {
                newCenter.y = self.circleBack.center.y;
            }else if (newCenter.y + self.maxRange > self.bounds.size.height && centerOffset.y >= 0){
                newCenter.y = self.circleBack.center.y;
            }
            
            [self.circleBack setCenter:newCenter];
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self toucheEnd];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self toucheEnd];
}
-(void)toucheEnd{
    _isTouching = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.circleBack.alpha = 0;
    }];
    self.value = 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GameControllerEndTouch:)]) {
        [self.delegate GameControllerBeginTouch: self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
