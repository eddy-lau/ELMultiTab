//
//  MultiTabView.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 01/06/2011.
//  Copyright 2011 TouchUtility.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELTabOrientation.h"

@interface MultiTabView : UIView
{
    BOOL          fullScreen;
    
    BOOL          hasAd;
    BOOL          iAdLoaded;
    UIView       *customAdBanner;
    
    ELTabOrientation tabOrientation;
}

- (void) setFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@property (nonatomic)          BOOL          fullScreen;
@property (nonatomic)          BOOL          hasAd;
@property (nonatomic,retain)   UIView       *customAdBanner;
@property (nonatomic)          ELTabOrientation tabOrientation;

@end

