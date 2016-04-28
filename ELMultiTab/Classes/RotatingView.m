//
//  SyncView.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 13/04/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import "RotatingView.h"


@implementation RotatingView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.speed = 1.0/3.0;
        
    }
    return self;
    
}

- (void)drawRect:(CGRect)rect
{
}

- (void)dealloc
{
    [super dealloc];
}

- (void) startRotating {
    
    if ([self.layer animationForKey:@"rotateAnimation"]==nil) {
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation
                                           animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotateAnimation.toValue   = [NSNumber numberWithFloat:2.0*M_PI];
        rotateAnimation.duration  = 1.0/speed;
        rotateAnimation.repeatCount=HUGE_VALF;
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [self.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
        
        [self setNeedsDisplay];
        
    }
    
}

- (void) stopRotating {

    if ([self.layer animationForKey:@"rotateAnimation"]) {
        [self.layer removeAnimationForKey:@"rotateAnimation"];
        [self setNeedsDisplay];
    }
    
}

- (BOOL) isRotating {
    return [self.layer animationForKey:@"rotateAnimation"]!=nil;
}

- (void) setIsRotating:(BOOL)isRotating {
    if (isRotating) {
        [self startRotating];
    } else {
        [self stopRotating];
    }
}

- (void) setSpeed:(CGFloat)value {
    if (speed != value) {
        speed = value;
        [self stopRotating];
        if (speed > 0) {
            [self startRotating];
        }
    }
}

- (CGFloat) speed {
    CABasicAnimation *rotateAnimation = (CABasicAnimation *)[self.layer animationForKey:@"rotateAnimation"];
    if (rotateAnimation) {
        return 1.0/rotateAnimation.duration; 
    } else {
        return 0.0;
    }
}

@end
