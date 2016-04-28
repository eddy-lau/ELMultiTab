//
//  TabContentViewDelegate.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 10/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabView.h"

@class TabContentView;

@protocol TabContentViewDelegate

- (BOOL) tabContentView:(TabContentView *)tabContentView shouldChangeStateTo:(TabState) state previousState:(TabState) prevState;
- (BOOL) tabContentViewWillRemove:(TabContentView *)tabContentView;
- (BOOL) tabContentViewShouldShowDeleteBadge:(TabContentView *)tabContentView;

@optional
- (void) tabContentView:(TabContentView *)tabContentView didChangedStateTo:(TabState) state previousState:(TabState) prevState;


@end
