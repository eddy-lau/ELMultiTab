//
//  RotatingCircle.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 27/04/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import "RotatingCircle.h"

typedef struct {
	CGFloat pattern[5];
	size_t count;
} Pattern;

static Pattern pattern = {{5, 2}, 2};

@implementation RotatingCircle

@synthesize dashPhase;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        color = [[UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1.0] retain];
        dashPhase = 0.0;
        
        [self setDashPattern:pattern.pattern count:pattern.count];
        
    }
    return self;
}

- (void) dealloc {
    [color release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    
    rect = CGRectInset(rect, 2.0, 2.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();    
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
	CGContextSetLineWidth(context, 2.0);
    
	CGContextSetLineDash(context, dashPhase, dashPattern, dashCount);

    CGContextStrokeEllipseInRect(context, rect);
}

-(void)setDashPhase:(CGFloat)phase
{
	if(phase != dashPhase)
	{
		dashPhase = phase;
		[self setNeedsDisplay];
	}
}

-(void)setDashPattern:(CGFloat *)pattern count:(size_t)count
{
	if((count != dashCount) || (memcmp(dashPattern, pattern, sizeof(CGFloat) * count) != 0))
	{
		memcpy(dashPattern, pattern, sizeof(CGFloat) * count);
		dashCount = count;
		[self setNeedsDisplay];
	}
}

- (void) setColor:(UIColor *)c {
    if (color != c ) {
        [color release];
        color = [c retain];
        [self setNeedsDisplay];
    }
}

- (UIColor *) color {
    return color;
}


@end
