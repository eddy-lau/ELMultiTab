//
//  TabContentView.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 10/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TabContentView.h"

@interface TabContentViewContent : UIView
@end

@implementation TabContentViewContent

- (void) layoutSubviews {    
    for (UIView *v in self.subviews) {
        v.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
        [v setNeedsLayout];
    }
}

@end

@interface TabContentView (private)

- (CGRect) contentViewFrame;

@end

@implementation TabContentView

@synthesize delegate,tabView,contentView;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        
        hasTab = YES;
		
		/*
		 * Tab Area
		 */
			
        tabView                 = [[TabView alloc] init];
        [self addSubview:tabView];
        
        contentView             =  [[TabContentViewContent alloc] initWithFrame:[self contentViewFrame]];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
			
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [contentView release];
	[tabView release];
    [super dealloc];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!hasTab) {
        return [super pointInside:point withEvent:event];
    }
	
    CGRect bounds = self.bounds;
	if (tabOrientation == TAB_ORIENATION_BOTTOM) {
        
        bounds.size.height -= tabView.tabAreaHeight;
        
    } else {

        bounds.origin.y += tabView.tabAreaHeight;
        bounds.size.height -= tabView.tabAreaHeight;
        
    }
    

    if (CGRectContainsPoint(bounds, point)) {
        return YES;
    } else {
        CGRect tabViewFrame = tabView.frame;
        return CGRectContainsPoint(tabViewFrame, point);
    }        
    
}

- (CGRect) contentViewFrame {
    
    CGFloat tabHeight = hasTab?tabView.tabAreaHeight:0;
    if (tabOrientation == TAB_ORIENATION_BOTTOM) {
        
        return CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height-tabHeight);
        
    } else {
    
        return CGRectMake(0.0, tabHeight, self.bounds.size.width, self.bounds.size.height-tabHeight);
        
    } 
}

- (void) layoutSubviews {
    contentView.frame = [self contentViewFrame];
    [contentView setNeedsLayout];    
}

- (void) setHasTab:(BOOL)value {
    if (hasTab != value) {
        hasTab = value;
        [self setNeedsLayout];
        
        if (!hasTab) {
            [tabView removeFromSuperview];
        } else {
            [self addSubview:tabView];
        }
    }
}

- (BOOL) hasTab {
    return hasTab;
}

- (void) setTabOrientation:(ELTabOrientation)value {
    if (tabOrientation != value) {
        tabOrientation = value;
        [self setNeedsLayout];
        
        tabView.tabOrientation = tabOrientation;
    }
}

- (ELTabOrientation) tabOrientation {
    return tabOrientation;
}

@end
