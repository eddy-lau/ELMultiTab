//
//  TabViewController.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 10/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabContentView.h"
#import "TabView.h"

@class ELMultiTabViewController;

@interface TabContentViewController : UIViewController {
	
	id                            delegate;
	TabState                      initialState;
	ELMultiTabViewController       *parentController;

}


- (id) initWithTabState:(TabState) state withParentController:(ELMultiTabViewController *)parent;
- (void) didChangeState:(TabState) state previousState:(TabState)previousState;
- (void) setTabIndex:(NSInteger)index animated:(BOOL)animated;
- (void) activateLeftTab;
- (void) activateRightTab;
- (void) closeTab;


@property (nonatomic)               TabState                 tabState;
@property (nonatomic)               NSInteger                tabIndex;
@property (nonatomic,assign)        id                       delegate;
@property (nonatomic,readonly)      TabContentView          *tabContentView;
@property (nonatomic,readonly)      ELMultiTabViewController  *parentController;
@property (nonatomic,retain)        UIViewController        *contentViewController;


@end
