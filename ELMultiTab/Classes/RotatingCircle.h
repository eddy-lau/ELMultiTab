//
//  RotatingCircle.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 27/04/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RotatingView.h"


@interface RotatingCircle : RotatingView {
    
    UIColor *color;
	CGFloat dashPhase;
	CGFloat dashPattern[10];
	size_t dashCount;
    
}

@property (nonatomic,retain) UIColor *color;
@property(nonatomic, readwrite) CGFloat dashPhase;
-(void)setDashPattern:(CGFloat*)pattern count:(size_t)count;

@end
