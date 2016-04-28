//
//  SyncView.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 13/04/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface RotatingView : UIView {
    
    CGFloat  speed;
    
}

- (id) initWithFrame:(CGRect)frame;
- (void) startRotating;
- (void) stopRotating;

@property (nonatomic)        CGFloat  speed; // rps
@property (nonatomic)        BOOL     isRotating;

@end
