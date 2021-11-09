//
//  MultiTabViewController.h
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 10/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELTabOrientation.h"

@class ELMultiTabViewController;
@protocol MultiTabViewControllerDataSource <NSObject>

- (NSInteger) numberOfTabsInMultiTabViewController:(ELMultiTabViewController *)controller;
- (UIViewController *) multiTabViewController:(ELMultiTabViewController *)controller viewControllerWithIndex:(NSInteger)index;

@end

@protocol MultiTabViewControllerDelegate <NSObject>

@optional
- (BOOL) multiTabViewController:(ELMultiTabViewController *)controller shouldShowDeleteBadgeAtIndex:(NSInteger)index;

@end


@interface ELMultiTabViewController : UIViewController

- (NSInteger) numberOfViewControllers;
- (UIViewController *) viewControllerAtIndex:(NSInteger)index;
- (void) setFullScreen:(BOOL)enable animated:(BOOL)animated;

- (void) activateLeftTab;
- (void) activateRightTab;
- (void) closeCurrentTab;


@property (nonatomic, assign) id<MultiTabViewControllerDataSource> dataSource;
@property (nonatomic, assign) id<MultiTabViewControllerDelegate> delegate;
@property (nonatomic, copy) NSArray *tabColors;
@property (nonatomic, retain) UIColor *darkModeActiveTabTextColor;
@property (nonatomic) BOOL fullScreen;
@property (nonatomic) ELTabOrientation tabOrientation;



// Deprecated methods
//- (TabContentViewController *) allocTabContentViewController;
//- (TabContentViewController *) createTabContentViewControllerWithState:(TabState)state withObject:(id)object;
//- (void) addTabController:(TabContentViewController *) viewController;
//- (NSArray *) contentViewControllersOfState:(TabState)state;



@end
