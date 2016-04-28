//
//  UIColor+Web.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 08/02/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (Web)

+ (UIColor *) facebookColor;
+ (UIColor *) colorFromWebTitle:(NSString *)title;
+ (UIColor *) colorWithHexInteger:(UInt32)col;

/* 0.0 is darkest */
- (UIColor *)colorByDarkeningColorBy:(CGFloat)darkness;
	
@end
