//
//  MultiTabView.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 01/06/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import "MultiTabView.h"
#import "TabContentView.h"
#import "TabScrollView.h"

@implementation MultiTabView

@synthesize adBannerView;

- (CGRect) customAdFrame {
    
    CGRect bounds = self.bounds;
    if (customAdBanner == nil) {
        return CGRectZero;
    } else {
        
        if (!iAdLoaded) {
            
            CGFloat x = bounds.origin.x;
            CGFloat h = 50;
            CGFloat y = CGRectGetMaxY(bounds)-h;
            CGFloat w = bounds.size.width;
            
            return CGRectMake(x, y, w, h);
        } else {
            
            CGFloat x = bounds.origin.x;
            CGFloat h = 50;
            CGFloat y = CGRectGetMaxY(bounds);
            CGFloat w = bounds.size.width;
            
            return CGRectMake(x, y, w, h);
        }
    }
}

- (CGRect) adBannerViewFrame {
    
    CGRect bounds = self.bounds;
    
    if (adBannerView != nil) {
        
        /*
        if (bounds.size.width > bounds.size.height) {
            adBannerView.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierLandscape != nil) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifier480x32;
        } else {
            adBannerView.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierPortrait != nil) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifier320x50;         
        }
         */
        

        if (iAdLoaded) {
            
            CGFloat h = adBannerView.bounds.size.height;
            CGFloat x = bounds.origin.x;
            CGFloat y = CGRectGetMaxY(bounds)-h;
            CGFloat w = bounds.size.width;    
            
            return CGRectMake(x,y,w,h);
        } else {
            
            CGFloat h = adBannerView.bounds.size.height;
            CGFloat x = bounds.origin.x;
            CGFloat y = CGRectGetMaxY(bounds);
            CGFloat w = bounds.size.width;    
            
            return CGRectMake(x,y,w,h);
        }
    } else {
        return CGRectZero;
    }
}

- (CGFloat) tabScrollViewWidth {
    return self.bounds.size.width;
}

- (CGRect) tabScrollViewFrame:(CGFloat)tabHeight {
    
    if (tabOrientation == TAB_ORIENATION_BOTTOM) {
        
        CGFloat y = fullScreen?CGRectGetMaxY(self.bounds):CGRectGetMaxY(self.bounds)-tabHeight;
        return CGRectMake(0.0, y, [self tabScrollViewWidth], tabHeight);
        
    } else {
        CGFloat y = fullScreen?-tabHeight:0;
        return CGRectMake(0.0, y, [self tabScrollViewWidth], tabHeight);
    }
    
}

- (void) layoutSubviews {
    
    adBannerView.frame = [self adBannerViewFrame];
    CGFloat adHeight = [self customAdFrame].size.height;
    
    if (iAdLoaded) {
        adHeight = adBannerView.bounds.size.height;
    }
    
    customAdBanner.frame = [self customAdFrame];
    
    
	CGRect allTabsFrame = CGRectZero;
	TabContentView *tabContentView = nil;
    NSInteger tabContentMaxZOrder = 0;
    
    for (NSInteger i = 0; i<[self.subviews count]; i++) {
        UIView *v = [self.subviews objectAtIndex:i];
		if ([v isKindOfClass:[TabContentView class]]) {
			tabContentView = (TabContentView *)v;
            
            if (i>tabContentMaxZOrder) {
                tabContentMaxZOrder = i;
            }            
            
			allTabsFrame = CGRectUnion(allTabsFrame, tabContentView.tabView.frame);
                        
            CGFloat x,y,w,h;
            x = 0;
            y = 0;
            w = self.bounds.size.width;
            h = self.bounds.size.height - adHeight;
            
            if (fullScreen) {
                h += tabContentView.tabView.tabAreaHeight;
                y -= tabContentView.tabView.tabAreaHeight;
            }
            
			v.frame = CGRectMake(x, y, w, h);
			
		}
        
	}
	
	if (tabContentView != nil) {
		for (UIView *v in [self subviews]) {
			if ([v isKindOfClass:[TabScrollView class]]) {
				
				UIScrollView *tabScrollView = (UIScrollView *)v;
				CGFloat tabHeight = tabContentView.tabView.tabAreaHeight;
				
				tabScrollView.frame = [self tabScrollViewFrame:tabHeight];
                
                [self insertSubview:tabScrollView atIndex:tabContentMaxZOrder+1];
				
				tabScrollView.contentSize = allTabsFrame.size;
				
				for (UIView *v in [self subviews]) {
					if ([v isKindOfClass:[TabContentView class]]) {
						tabContentView = (TabContentView *)v;
						tabContentView.tabView.leftOffset = -tabScrollView.contentOffset.x;
					}
				}
				
				break;
			}
		}
	}
    
}

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog (@"bannerViewDidLoadAd");
    iAdLoaded = YES;
    
    [self setNeedsLayout];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self layoutIfNeeded];    
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {

    NSLog (@"bannerView:didFailToReceiveAdWithError");
    iAdLoaded = NO;
    
    [self setNeedsLayout];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self layoutIfNeeded];    
    [UIView commitAnimations];    
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    NSLog (@"bannerViewActionShouldBegin");
    return YES;
}


-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
    
}

static BOOL isIOS4(void) {
    
    NSString *currentVersion = [[UIDevice currentDevice] systemVersion];
    if ([currentVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending ||
        [currentVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedSame) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

#pragma mark public method 

- (void) setFullScreen:(BOOL)value animated:(BOOL)animated {
    
    if (fullScreen != value) {
        fullScreen = value;
        
        if (animated) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [self layoutSubviews];
            
            [UIView commitAnimations];
            
        } else {
            [self setNeedsLayout];
        }
        
    }
    
}

- (void) setFullScreen:(BOOL)value {
    [self setFullScreen:value animated:NO];
    
}

- (BOOL) fullScreen {
    return fullScreen;
}

- (void) setHasAd:(BOOL)value {
    if (hasAd != value) {
        hasAd = value;
        
        if (hasAd) {
            
            if (isIOS4()) {
                
                adBannerView = [[ADBannerView alloc] initWithFrame:[self adBannerViewFrame]];
                adBannerView.delegate = self;
                
                adBannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
                
                // Since we support all orientations, support portrait and landscape content sizes.
                // If you only supported landscape or portrait, you could remove the other from this set
                
                /*
                adBannerView.requiredContentSizeIdentifiers = (&ADBannerContentSizeIdentifierPortrait != nil) ?
                [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil] : 
                [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32, nil];
                */
                 
                [self addSubview:adBannerView];
                
            }
            
        } else {
            
            adBannerView.delegate = nil;
            [adBannerView removeFromSuperview];
            [adBannerView release];
            adBannerView = nil;
            
        }
        
        [self setNeedsLayout];
    }
}

- (BOOL) hasAd {
    return hasAd;
}

- (void) setCustomAdBanner:(UIView *)view {
    if (customAdBanner != view) {
        
        [customAdBanner removeFromSuperview];
        [customAdBanner release];
        customAdBanner = [view retain];
        
        [self addSubview:customAdBanner];
        
        [self setNeedsLayout];
    }
}

- (UIView *) customAdBanner {
    return customAdBanner;
}

- (void) setTabOrientation:(ELTabOrientation)value {
    if (tabOrientation != value) {
        tabOrientation = value;
        [self setNeedsLayout];
    }
}

- (ELTabOrientation) tabOrientation {
    return tabOrientation;
}

@end
