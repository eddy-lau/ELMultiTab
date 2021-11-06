//
//  TabView.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 04/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TabView.h"
#import "TabContentView.h"
#import "TabContentViewDelegate.h"
#import "MKNumberBadgeView.h"
#import "UIColor+Web.h"
#import "RegexKitLite.h"
#import "Util.h"

@interface TabView (private)

- (void) updateUI:(BOOL)animated oldState:(TabState)oldState;
- (void) showDeleteBadge;
- (void) hideDeleteBadge;

@end

@implementation TabView

@synthesize tabWidth,tabTopSpace,tabAreaHeight,titleLabel,deleteBadge;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        [self updateTabAreaHeight];
		tabWidth             = (IS_IPAD ? 150.0 : 120);
		tabOverlapWidth      = 30.0;
		
		activeTextColor      = [UIColor darkGrayColor];
		inactiveTabColor     = [[UIColor colorWithRed:114.0/255.0 green: 132.0/255.0 blue:211.0/255.0 alpha:1.0] retain];
		
		
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds   = NO;
		state                = TAB_STATE_INACTIVE;
		
		CGRect labelFrame          = CGRectMake(25.0, 0.0, tabWidth-50.0, tabAreaHeight-tabTopSpace);
		titleLabel                 = [[UILabel alloc] initWithFrame:labelFrame];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textAlignment   = NSTextAlignmentCenter;
		titleLabel.font            = [UIFont fontWithName:@"HelveticaBold" size:(IS_IPAD?12.0:8.0)];
		titleLabel.textColor       = [UIColor whiteColor];
		[self addSubview:titleLabel];
		
		
		deleteBadge = [[DeleteBadge alloc] initWithFrame:CGRectMake((IS_IPAD?tabWidth-40.0:tabWidth-35.0),
                                                                    (IS_IPAD?-10:-7),
                                                                    30.0,
                                                                    30.0)];
		deleteBadge.alpha = 0.0;
		deleteBadge.delegate = self;
		[self addSubview:deleteBadge];
		
		
		numberBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectZero];
		numberBadge.backgroundColor = [UIColor clearColor];
		numberBadge.strokeColor = [UIColor clearColor];
		numberBadge.shadow = YES;
		numberBadge.shine = NO;
        
        
        CGFloat rotatingCircleWidth = IS_IPAD?20.0:17.0;
        rotatingCircle = [[RotatingCircle alloc] initWithFrame:CGRectMake(22.0, 5.0, rotatingCircleWidth, rotatingCircleWidth)];
        rotatingCircle.speed = 0;
        rotatingCircle.hidden = YES;
        [self addSubview:rotatingCircle];
        
		[self updateUI:NO oldState:state];
		

    }
    return self;
}

- (void)addRoundedPathInRect:(CGRect)rect inContext:(CGContextRef)context {
    
    float radius      = IS_IPAD ? 7.0 : 5.0;
	float angle       = 80.0*M_PI/180.0;
	float adjustment  = 5.0;

    if (tabOrientation == TAB_ORIENATION_BOTTOM) {
        
        /*
         
         1\-------------------/2
         x 8                 3 x
           |                 |
           7 x             x 4 
           \                 /
            _6_____________5_
         
         */
        
        CGContextBeginPath(context);
        
        // Move to point 1
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        
        // Move to point 2
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        
        // Arc from 2 to 3
        CGContextAddArc(context, CGRectGetMaxX(rect), CGRectGetMinY(rect) +radius, radius, 3*M_PI/2, 3*M_PI/2 - angle, 1);
        
        // Arc from 4 to 5
        CGContextAddArc(context, CGRectGetMaxX(rect)-2*radius-adjustment, CGRectGetMaxY(rect) - radius, radius, M_PI/2-angle, M_PI/2, 0);
        
        // Arc from 6 to 7
        CGContextAddArc(context, CGRectGetMinX(rect)+2*radius+adjustment, CGRectGetMaxY(rect) - radius, radius, M_PI/2, M_PI/2+angle, 0);
        
        // Arc from 8 to 1
        CGContextAddArc(context, CGRectGetMinX(rect), CGRectGetMinY(rect)+radius, radius, 3*M_PI/2+angle, 3*M_PI/2, 1);
        
        
        CGContextClosePath(context);
        
    } else {
    
        /*
         
            _6_____________5_
           /                 \
           7 x             x 4 
           |                 |
         x 8                 3 x
         1/-------------------\2
         
         */
        
        CGContextBeginPath(context);
        
        // Move to point 1
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        
        // Move to point 2
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        
        // Arc from 2 to 3
        CGContextAddArc(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) -radius, radius, M_PI/2, M_PI/2 + angle, 0);
        
        // Arc from 4 to 5
        CGContextAddArc(context, CGRectGetMaxX(rect)-2*radius-adjustment, CGRectGetMinY(rect) + radius, radius, 3*M_PI/2+angle, 3*M_PI/2, 1);
        
        // Arc from 6 to 7
        CGContextAddArc(context, CGRectGetMinX(rect)+2*radius+adjustment, CGRectGetMinY(rect) + radius, radius, 3*M_PI/2, 3*M_PI/2-angle, 1);
        
        // Arc from 8 to 1
        CGContextAddArc(context, CGRectGetMinX(rect), CGRectGetMaxY(rect)-radius, radius, M_PI/2-angle, M_PI/2, 0);
        
        
        CGContextClosePath(context);
        
    }
    
}

- (void)addNewTabPathInRect:(CGRect)rect inContext:(CGContextRef)context {
	
    float radius      = IS_IPAD ? 7.0 : 5.0;
	float angle       = 80.0*M_PI/180.0;
	float adjustment  = 5.0;
	
	/*
	 
	    _6_____________5_
	   /                 \
	   7 x             x 4 
	   |                 |
	 x 8                 3 x
	 1/-------------------\2
	 
	 */
	
    CGContextBeginPath(context);
	
    // Move to point 1
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
	
	// Move to point 2
	CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
	
	// Arc from 2 to 3
	CGContextAddArc(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) -radius, radius, M_PI/2, M_PI/2 + angle, 0);
	
	// Arc from 4 to 5
	CGContextAddArc(context, CGRectGetMaxX(rect)-2*radius-adjustment, CGRectGetMinY(rect) + radius, radius, 3*M_PI/2+angle, 3*M_PI/2, 1);
	
	// Arc from 6 to 7
	CGContextAddArc(context, CGRectGetMinX(rect)+2*radius+adjustment, CGRectGetMinY(rect) + radius, radius, 3*M_PI/2, 3*M_PI/2-angle, 1);
	
	// Arc from 8 to 1
	CGContextAddArc(context, CGRectGetMinX(rect), CGRectGetMaxY(rect)-radius, radius, M_PI/2-angle, M_PI/2, 0);
	
	
    CGContextClosePath(context);
}

- (void)clipToRoundedRect:(CGRect)rect inContext:(CGContextRef)context
{
    [self addRoundedPathInRect:rect inContext:context];
    CGContextClip(context);
}

- (CGRect) plusSignRect:(CGRect)rect {

    CGFloat w = IS_IPAD?8:6;
    CGFloat h = IS_IPAD?8:6;
    CGFloat x = IS_IPAD?CGRectGetMaxX(rect)-w-21:CGRectGetMaxX(rect)-w-14;
    CGFloat y = 8;
    
    return CGRectMake(x, y, w, h);    
}

- (void)drawRect:(CGRect)rect
{
	if (state == TAB_STATE_INACTIVE) {
	
		/* 
		 * Draw tab in color
		 */
		
		rect = CGRectInset(rect, 5.0, 0.0);
		
		CGContextRef context = UIGraphicsGetCurrentContext();

		// Define the shadow
		CGFloat shadowOffsetX = 0.0;
		CGFloat shadowOffsetY = 0.0;
		CGFloat shadowBlur    = 10.0;
		CGSize  shadowOffset  = CGSizeMake (shadowOffsetX, shadowOffsetY);
		CGContextSetShadow (context, shadowOffset, shadowBlur); 
		
		// Added path
		[self addRoundedPathInRect:rect inContext:context];
		
		// Fill the background
		CGContextSetFillColorWithColor(context, inactiveTabColor.CGColor);
		CGContextFillPath(context);
			
	} else if (state == TAB_STATE_ACTIVE) {
		
		/* 
		 * Draw tab in white with more shadow
		 */
		
		rect = CGRectInset(rect, 5.0, 0.0);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		// Define the shadow
		CGFloat shadowOffsetX = 0.0;
		CGFloat shadowOffsetY = 0.0;
		CGFloat shadowBlur    = 15.0;
		CGSize  shadowOffset  = CGSizeMake (shadowOffsetX, shadowOffsetY);
		CGContextSetShadow (context, shadowOffset, shadowBlur); 
		
		// Added path
		[self addRoundedPathInRect:rect inContext:context];
		
		// Fill the background
        if (@available(iOS 13.0, *)) {
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                UIColor *fillColor = [UIColor systemBackgroundColor];
                CGContextSetFillColorWithColor(context, fillColor.CGColor);
            } else {
                CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
            }
        } else {
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        }
		CGContextFillPath(context);
		
	} else if (state == TAB_STATE_NEW) {
		
		
		/* 
		 * Draw tab in color
		 */
		
		rect            =  CGRectInset(rect, 5.0, 0.0);
//		rect.origin.x  -=  rect.size.width*0.7;
//		rect.origin.y  +=  5.0;
		
		CGContextRef context = UIGraphicsGetCurrentContext();
        
		CGContextSaveGState(context);
        
		// Define the shadow
		CGFloat shadowOffsetX = 0.0;
		CGFloat shadowOffsetY = 0.0;
		CGFloat shadowBlur    = 10.0;
		CGSize  shadowOffset  = CGSizeMake (shadowOffsetX, shadowOffsetY);
		CGContextSetShadow (context, shadowOffset, shadowBlur); 
		
		// Added path
		[self addNewTabPathInRect:rect inContext:context];
		
		// Fill the background
		CGContextSetFillColorWithColor(context, inactiveTabColor.CGColor);
		CGContextFillPath(context);
        
        CGContextRestoreGState(context);
        
        // Draw the plus sign
        CGContextSetStrokeColorWithColor(context, [inactiveTabColor colorByDarkeningColorBy:0.8].CGColor);
        CGContextSetLineWidth(context, IS_IPAD?3.5:3.0);
        CGContextSetLineCap(context, kCGLineCapSquare);
        
        CGRect plusRect = [self plusSignRect:rect];
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMidX(plusRect), CGRectGetMinY(plusRect));
        CGContextAddLineToPoint(context, CGRectGetMidX(plusRect), CGRectGetMaxY(plusRect));
        CGContextStrokePath(context);
		
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(plusRect), CGRectGetMidY(plusRect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(plusRect), CGRectGetMidY(plusRect));
        CGContextStrokePath(context);
	}
		
	    
}

- (void)dealloc {
    [rotatingCircle release];
	[numberBadge release];
	[inactiveTabColor release];
	[deleteBadge release];
	[titleLabel release];
    [super dealloc];
}

- (void) handleTouchAtPoint:(CGPoint)point {
	
	TabContentView   *parent     =  (TabContentView *)[self superview];
	
	if (state == TAB_STATE_INACTIVE) {
		
		BOOL ok = NO;
		if ([parent.delegate respondsToSelector:@selector(tabContentView:shouldChangeStateTo:previousState:)]) {
			ok = [parent.delegate tabContentView:parent shouldChangeStateTo:TAB_STATE_ACTIVE previousState:state];
		}
		
		if (ok)
			self.state = TAB_STATE_ACTIVE;
		
		
	} else if (state == TAB_STATE_NEW) {
		
		BOOL ok = NO;
		if ([parent.delegate respondsToSelector:@selector(tabContentView:shouldChangeStateTo:previousState:)]) {
			ok = [parent.delegate tabContentView:parent shouldChangeStateTo:TAB_STATE_ACTIVE previousState:state];
		}
		
		if (ok)
			[self setState:TAB_STATE_ACTIVE animated:YES];
		
		
	}
	
	if (state == TAB_STATE_ACTIVE) {
		[self showDeleteBadge];
	}
		
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
//	[self handleTouchAt];
}
 */

#pragma mark properties

- (void) setLeftOffset:(CGFloat) newOffset {
	leftOffset = newOffset;
	[self updateUI:NO oldState:state];
}

- (CGFloat) leftOffset {
	return leftOffset;
}

- (void) setIndex:(NSInteger) newIndex {
	index = newIndex;
	[self updateUI:NO oldState:state];
}

- (void) setIndex:(NSInteger) newIndex animated:(BOOL)animated {
	index = newIndex;
	[self updateUI:animated oldState:state];
}

- (NSInteger) index {
	return index;
}

- (void) setState:(TabState) newState {
	[self setState:newState animated:NO];	
}

- (void) setState:(TabState) newState animated:(BOOL)animated {
	if (state != newState) {
		TabState oldState = state;
		state = newState;
		
		[self setNeedsDisplay];
		[self updateUI:animated oldState:oldState];
		
		TabContentView *parent = (TabContentView *)[self superview];
		if ([parent.delegate respondsToSelector:@selector(tabContentView:didChangedStateTo:previousState:)]) {
			[parent.delegate tabContentView:parent didChangedStateTo:state previousState:oldState];
		}
	}
}

- (TabState) state {
	return state;
}

- (void) setInactiveTabColor:(UIColor *)c {
	[inactiveTabColor release];
	inactiveTabColor = [c retain];
	[self setNeedsDisplay];
}

- (UIColor *) inactiveTabColor {
	return inactiveTabColor;
}

- (void) setTitle:(NSString *)s {
	
	NSRange matchedRange = [s rangeOfRegex:@"\\(.*[0-9]+.*\\)"];
	if (matchedRange.location != NSNotFound) {
		NSString *matchedString = [s substringWithRange:matchedRange];
		NSLog (@"Found notification title: %@ matched %@", s, matchedString);
		NSRange numberRange = [matchedString rangeOfRegex:@"[0-9]+"];
		if (numberRange.location != NSNotFound) {
			self.numberBadgeValue = [[matchedString substringWithRange:numberRange] integerValue];
			self.titleLabel.text = NSLocalizedString([[s stringByReplacingCharactersInRange:matchedRange withString:@""]
                                                      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],@"");
			return;
		}
	} else {
		self.numberBadgeValue = 0;
	}
	
	self.titleLabel.text = NSLocalizedString(s,@"");
	
}

- (NSString *)title {
	return self.titleLabel.text;
}

- (void) setNumberBadgeValue:(NSInteger)v {
	
	numberBadgeValue = v;
	[self updateUI:NO oldState:state];
}

- (NSInteger) numberBadgeValue {
	return numberBadgeValue;
}

- (void) setBusyLevel:(CGFloat)value {
    
    if (busyLevel != value) {
        busyLevel = value;
        
        if (busyLevel > 0) {
            
            CGFloat speed = busyLevel/3.0;
            if (speed > 5.0)
                speed = 5.0;
            
            rotatingCircle.speed = speed;
            rotatingCircle.hidden = NO;
            
        } else {
            
            rotatingCircle.speed = 0;
            rotatingCircle.hidden = YES;
        }
        
        [self updateUI:YES oldState:state];
    }
}

- (CGFloat) busyLevel {
    return busyLevel;
}

- (void) setTabOrientation:(ELTabOrientation)value {
    if (tabOrientation != value) {
        tabOrientation = value;
        
        [self updateTabAreaHeight];
        [self setNeedsDisplay];
        [self updateUI:NO oldState:state];
    }
}

- (ELTabOrientation) tabOrientation {
    return tabOrientation;
}

#pragma mark Private methods

- (void) updateTabAreaHeight {
    
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        if (self.tabOrientation == TAB_ORIENATION_BOTTOM) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            bottomPadding = window.safeAreaInsets.bottom;
        }
    }
    
    tabAreaHeight        = (IS_IPAD ? 40 : 30) + bottomPadding;
    tabTopSpace          = (IS_IPAD ? 10 : 5) + bottomPadding;
    
}

- (CGRect) tabFrame {

    if (tabOrientation == TAB_ORIENATION_BOTTOM) {
        
        CGFloat dx = 0.0;
        CGFloat dy = 0.0;
        
        if (state == TAB_STATE_NEW) {
            dx = -tabWidth*0.6;
            dy = -5.0;
        }

        UIView *sv = [self superview];
        CGFloat superViewH = sv.bounds.size.height;
        
        CGFloat tabLeft = leftOffset + index * (tabWidth-tabOverlapWidth);
        return CGRectMake(tabLeft+dx, superViewH-tabAreaHeight, tabWidth, tabAreaHeight-tabTopSpace);
        
    } else {
        CGFloat dx = 0.0;
        CGFloat dy = 0.0;
        
        if (state == TAB_STATE_NEW) {
            dx = -tabWidth*0.6;
            dy = 5.0;
        }
        
        CGFloat tabLeft = leftOffset + index * (tabWidth-tabOverlapWidth);
        return CGRectMake(tabLeft+dx, tabTopSpace+dy, tabWidth, tabAreaHeight-tabTopSpace);    
    }
}

- (UIColor *) activeTitleColor {
    if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor darkGrayColor];
        } else {
            return [UIColor lightGrayColor];
        }
    } else {
        return [UIColor lightGrayColor];
    }
}

- (void) updateUI:(BOOL)animated oldState:(TabState)oldState {
	
	/*
	 * Update the frame 
	 */
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
	}

    self.frame = [self tabFrame];
    
    CGRect titleLabelFrame;
    if (rotatingCircle.isRotating) {        
        CGFloat labelDx = 43.0-25.0;
        
        CGSize labelSize = CGSizeMake(tabWidth-50, tabAreaHeight-tabTopSpace);
        CGSize textSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:labelSize lineBreakMode:NSLineBreakByTruncatingTail];
        if (labelSize.width > textSize.width) {
            if ((labelSize.width-textSize.width)/2 > labelDx) {
                labelDx = 0;
            }
        }
        
        titleLabelFrame = CGRectMake(25.0+labelDx, 0.0, tabWidth-50.0-labelDx, tabAreaHeight-tabTopSpace);
    } else {
        titleLabelFrame = CGRectMake(25.0, 0.0, tabWidth-50.0, tabAreaHeight-tabTopSpace);
    }
    titleLabel.frame = titleLabelFrame;
    
	
	if (animated) {
		[UIView commitAnimations];
	}	
	
	/*
	 * Update the label colors
	 */
	if (state == TAB_STATE_ACTIVE) {
				
		titleLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        titleLabel.textColor       = [self activeTitleColor];
		titleLabel.shadowColor     = [UIColor clearColor];
		titleLabel.shadowOffset    = CGSizeMake(0,0);
        rotatingCircle.color       = titleLabel.textColor;
		
	} else if (state == TAB_STATE_INACTIVE) {
		
		titleLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
		titleLabel.textColor       = [UIColor whiteColor];
		titleLabel.shadowColor     = [UIColor darkGrayColor];
		titleLabel.shadowOffset    = CGSizeMake(1.0,1.0);
        rotatingCircle.color       = [[UIColor blackColor] colorWithAlphaComponent:0.5];
		
	} else if (state == TAB_STATE_NEW) {
		
		titleLabel.text            = @"";
		titleLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
		titleLabel.textColor       = [UIColor whiteColor];
		titleLabel.shadowColor     = [UIColor darkGrayColor];
		titleLabel.shadowOffset    = CGSizeMake(1.0,1.0);
        rotatingCircle.color       = [[UIColor blackColor] colorWithAlphaComponent:0.3];
		
	}
	
	/* Number badge */
	if (numberBadgeValue != 0 && state != TAB_STATE_NEW) {
		
		numberBadge.value = numberBadgeValue;
		numberBadge.frame = CGRectMake(10.0, -10, numberBadge.badgeSize.width, numberBadge.badgeSize.height + 10.0 /* shadow height */);
		[self addSubview:numberBadge];
		
	} else {
		
		[numberBadge removeFromSuperview];
	}
	
	/*
	 * Hide the delete badge if not active
	 */
	if (state != TAB_STATE_ACTIVE) {
		[self hideDeleteBadge];
	}
    	
}

- (void)hideDeleteBadgeTimout:(NSTimer *)timer {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	deleteBadge.alpha = 0.0;
	
	[UIView commitAnimations];
}

- (void) showDeleteBadge {
	
	BOOL shouldShow = YES;
	
	TabContentView   *parent     =  (TabContentView *)[self superview];	
	if (parent.delegate) {
		shouldShow = [parent.delegate tabContentViewShouldShowDeleteBadge:parent];
	}
		
	if (shouldShow) {
		
		[hideDeleteBadgeTimer invalidate];
		[hideDeleteBadgeTimer release];
		hideDeleteBadgeTimer = nil;
		hideDeleteBadgeTimer = [[NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(hideDeleteBadgeTimout:) userInfo:nil repeats:NO] retain];
		[[NSRunLoop currentRunLoop] addTimer:hideDeleteBadgeTimer forMode:NSDefaultRunLoopMode];
		
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		
		deleteBadge.alpha = 1.0;
		
		[UIView commitAnimations];
		
	}
}

- (void) hideDeleteBadge {

	[hideDeleteBadgeTimer invalidate];
	[hideDeleteBadgeTimer release];
	hideDeleteBadgeTimer = nil;
	
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.5];

	deleteBadge.alpha = 0.0;
	
//	[UIView commitAnimations];

}

#pragma mark DeleteBadgeDelegate

- (void) deleteBadgeTouchesEnded:(DeleteBadge *)deleteBadge {
	
	TabContentView   *parent     =  (TabContentView *)[self superview];
	
	if (parent.delegate) {
		[parent.delegate tabContentViewWillRemove:parent];
	}

}

@end
