//
//  DeleteBadge.m
//  TouchBible
//
//  Created by Eddie Lau on 12/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DeleteBadge.h"
#import "DeleteBadgeDelegate.h"


@implementation DeleteBadge

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

static void addOvalToPath(CGContextRef context, CGRect r)
{
    CGContextSaveGState(context);// 1
    
    CGContextTranslateCTM(context, r.origin.x + r.size.width/2,// 2
                          r.origin.y + r.size.height/2);
    CGContextScaleCTM(context, r.size.width/2, r.size.height/2);// 3
    CGContextBeginPath(context);// 4
    CGContextAddArc(context, 0, 0, 1, 0, 2*M_PI, true);// 5
    
    CGContextRestoreGState(context);// 6
}


- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();	
    CGContextSaveGState(context);
    
	CGRect r = CGRectInset(self.bounds, 3.0f, 3.0f);
    CGSize shadowOffset = CGSizeMake (0.0,  3.0);
    CGContextSetShadow (context, shadowOffset, 3.0); 
    
    addOvalToPath (context,r);    
    CGContextSetRGBFillColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0);
    CGContextFillPath (context);

	r = CGRectInset(r, 2.5f, 2.5f);
    addOvalToPath (context,r);    
    CGContextSetRGBFillColor(context, 0.0/255.0, 0.0/255.0, 0.0/255.0, 1.0);
    CGContextFillPath (context);    
    
    // Draw the cross here
    CGFloat minX, minY;
    CGFloat maxX, maxY;
    
    minX = r.origin.x + r.size.width*0.3;
    minY = r.origin.y + r.size.height*0.3;
    maxX = r.origin.x + r.size.width*0.7;
    maxY = r.origin.y + r.size.height*0.7;
    
    CGContextSetRGBStrokeColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0);
    CGContextSetLineWidth (context, 2.5);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextMoveToPoint(context, minX, minY);
	CGContextAddLineToPoint(context, maxX, maxY);
	CGContextStrokePath(context);
    
	CGContextMoveToPoint(context, maxX, minY);
	CGContextAddLineToPoint(context, minX, maxY);
	CGContextStrokePath(context);
    
    
    
    CGContextRestoreGState(context);
}

- (void) handleTouchAtPoint:(CGPoint)point {
    if ([delegate respondsToSelector:@selector(deleteBadgeTouchesEnded:)]) {
        [delegate deleteBadgeTouchesEnded:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}


- (void)dealloc {
    [super dealloc];
}


@end
