//
//  TabView.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 04/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteBadge.h"
#import "DeleteBadgeDelegate.h"
#import "MKNumberBadgeView.h"
#import "RotatingCircle.h"
#import "ELTabOrientation.h"

typedef enum {
	
	TAB_STATE_INACTIVE = 0,
	TAB_STATE_ACTIVE,
	TAB_STATE_NEW,
	
} TabState;

@interface TabView : UIView <DeleteBadgeDelegate> {

	NSInteger                     index;
	TabState                      state;
	UILabel                      *titleLabel;
	DeleteBadge                  *deleteBadge;
	MKNumberBadgeView            *numberBadge;
	NSInteger                     numberBadgeValue;
    RotatingCircle               *rotatingCircle;
	
	NSTimer                      *hideDeleteBadgeTimer;

	CGFloat                       busyLevel;
	CGFloat                       leftOffset;
	CGFloat                       tabAreaHeight;
	CGFloat                       tabTopSpace;
	CGFloat                       tabWidth;	
	CGFloat                       tabOverlapWidth;
	
	UIColor                      *activeTextColor;
	UIColor                      *inactiveTabColor;
    
    ELTabOrientation               tabOrientation;
}


- (void) setState:(TabState) state animated:(BOOL) animated;
- (void) setIndex:(NSInteger) newIndex animated:(BOOL)animated;
- (void) handleTouchAtPoint:(CGPoint)point;


@property (nonatomic)            TabState     state;
@property (nonatomic,readonly)   NSInteger    index;
@property (nonatomic,readonly)   CGFloat      tabAreaHeight;
@property (nonatomic,readonly)   CGFloat      tabWidth;
@property (nonatomic,readonly)   CGFloat      tabTopSpace;
@property (nonatomic,readonly)   UILabel     *titleLabel;
@property (nonatomic,readonly)   DeleteBadge *deleteBadge;
@property (nonatomic)            CGFloat      leftOffset;
@property (nonatomic,retain)     UIColor     *inactiveTabColor;
@property (nonatomic,retain)     UIColor     *darkModeActiveTextColor;

@property (nonatomic,copy)       NSString    *title;
@property (nonatomic)            NSInteger    numberBadgeValue;
@property (nonatomic)            CGFloat      busyLevel;
@property (nonatomic)            ELTabOrientation tabOrientation;

@end
