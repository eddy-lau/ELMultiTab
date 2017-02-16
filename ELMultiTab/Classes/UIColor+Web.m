//
//  UIColor+Web.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 08/02/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import "UIColor+Web.h"


@implementation UIColor (Web)

+ (UIColor *)colorWithHexInteger:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (UIColor *) colorWithHexString:(NSString *)str {
	
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    UInt32 x = (UInt32)strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHexInteger:x];
	
}

+ (UIColor *) facebookColor {
	
	return [UIColor colorWithRed:48.0/255.0 green:93.0/255.0 blue:154.0/255.0 alpha:1.0];
	
}

+ (UIColor *) colorFromWebTitle:(NSString *)title {
	if (title && [title rangeOfString:@"facebook" options:NSCaseInsensitiveSearch].location != NSNotFound) {
		return [self facebookColor];
	}
	return nil;
}

/* 0.0 is darkest */
- (UIColor *)colorByDarkeningColorBy:(CGFloat)darkness
{
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	CGFloat newComponents[4];
    
	NSInteger numComponents = CGColorGetNumberOfComponents([self CGColor]);
    
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0]*darkness;
			newComponents[1] = oldComponents[0]*darkness;
			newComponents[2] = oldComponents[0]*darkness;
			newComponents[3] = oldComponents[1];
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0]*darkness;
			newComponents[1] = oldComponents[1]*darkness;
			newComponents[2] = oldComponents[2]*darkness;
			newComponents[3] = oldComponents[3];
			break;
		}
	}
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
	return retColor;
}

@end
