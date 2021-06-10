    //
//  MultiTabViewController.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 10/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ELMultiTabViewController.h"
#import "TabContentViewController.h"
#import "TabScrollView.h"
//#import "iOS7Support.h"
#import "UIColor+Web.h"
#import "TabContentViewDelegate.h"
#import "TabContentViewController.h"
#import "MultiTabView.h"
#import "MaterialTabs.h"

@interface ELMultiTabViewController () <TabContentViewDelegate,UIScrollViewDelegate> {
    
    NSMutableArray        *tabViewControllers;
    UIScrollView          *tabScrollView;
    NSMutableArray        *tabColorTheme;
    ELTabOrientation       tabOrientation;
}

@property (nonatomic) BOOL viewIsLoaded;

@end

@implementation ELMultiTabViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        
		tabViewControllers = [[NSMutableArray alloc] initWithCapacity:3];
		tabColorTheme = [[NSMutableArray alloc] initWithObjects:
						 [UIColor colorWithRed:255.0/255.0 green:196.0/255.0 blue:18.0/255.0 alpha:1.0],
						 [UIColor colorWithRed:116.0/255.0 green:198.0/255.0 blue:88.0/255.0 alpha:1.0],
						 [UIColor colorWithRed:235.0/255.0 green: 46.0/255.0 blue:53.0/255.0 alpha:1.0],
						 [UIColor colorWithRed:143.0/255.0 green:101.0/255.0 blue:175.0/255.0 alpha:1.0],
						 [UIColor colorWithRed:166.0/255.0 green:123.0/255.0 blue:55.0/255.0 alpha:1.0],
						 [UIColor colorWithRed:34.0/255.0 green:184.0/255.0 blue:182.0/255.0 alpha:1.0],
						 [UIColor colorWithRed:230.0/255.0 green:133.0/255.0 blue:186.0/255.0 alpha:1.0],
						 [UIColor colorWithRed:240.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0],
						  nil];
		
    }
    return self;
	
}

- (void)dealloc {
    
    [tabViewControllers release];
    [tabColorTheme release];
    [tabScrollView release];
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    CGRect appFrame         = [UIScreen mainScreen].applicationFrame;
    UIView *view  = [[MultiTabView alloc] initWithFrame:appFrame];
    view.backgroundColor    = [UIColor colorWithHexInteger:0x79ac51];
    view.autoresizingMask  |= UIViewAutoresizingFlexibleHeight;
    view.autoresizingMask  |= UIViewAutoresizingFlexibleWidth;
    self.view               = view;
    [view release];
    
    [self loadData];
}

- (void) loadData {
    
    if (self.dataSource != nil) {
        
        NSInteger numberOfTabs = [self.dataSource numberOfTabsInMultiTabViewController:self];
        for (NSInteger i = numberOfTabs - 1; i>=0; i--) {
            
            id viewController = [self.dataSource multiTabViewController:self viewControllerWithIndex:i];
            if ([viewController isKindOfClass:[TabContentViewController class]]) {
                
                TabContentViewController *tabContentViewController = viewController;
                tabContentViewController.tabIndex                   =  i;
                tabContentViewController.tabContentView.delegate    =  self;
                [tabViewControllers addObject:tabContentViewController];
                [self.view addSubview:tabContentViewController.view];
                
                if (i == 0) {
                    tabContentViewController.tabState = TAB_STATE_ACTIVE;
                } else {
                    tabContentViewController.tabState = TAB_STATE_INACTIVE;
                }
                
            } else if ([viewController isKindOfClass:[UIViewController class]]) {
                
                TabState tabState = i==0? TAB_STATE_ACTIVE : TAB_STATE_INACTIVE;
                TabContentViewController *tabContentViewController = [[[TabContentViewController alloc] initWithTabState:tabState withParentController:self] autorelease];
                tabContentViewController.contentViewController = viewController;
                tabContentViewController.tabContentView.tabView.inactiveTabColor = [self nextTabColor];
                tabContentViewController.tabContentView.tabOrientation = tabOrientation;
                tabContentViewController.tabIndex = i;
                tabContentViewController.tabContentView.delegate = self;
                [tabViewControllers addObject:tabContentViewController];
                
                [self addChildViewController:tabContentViewController];
                [self.view addSubview:tabContentViewController.view];
                
            } else {
                NSAssert(NO, @"Should not happen");
            }
            
        }
        
        [self.view setNeedsLayout];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewIsLoaded = YES;
    
    MultiTabView *view = (MultiTabView *)self.view;
    view.tabOrientation = tabOrientation;
	
	CGRect tabsScrollerFrame = CGRectZero;
	tabScrollView = [[TabScrollView alloc] initWithFrame:tabsScrollerFrame];
	tabScrollView.scrollsToTop = NO;
	tabScrollView.showsVerticalScrollIndicator = NO;
	tabScrollView.showsHorizontalScrollIndicator = NO;
	tabScrollView.delegate = self;
	
	UITapGestureRecognizer *tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)] autorelease];
	
	[tabScrollView addGestureRecognizer:tapGestureRecognizer];
	
	[view addSubview: tabScrollView];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated {
    
    for (UIViewController *controller in tabViewControllers) {
        [controller viewWillAppear:animated];
    }
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UIViewController *viewController in tabViewControllers) {
        [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    for (UIViewController *viewController in tabViewControllers) {
        [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }    
}

#pragma mark private method

- (NSInteger) indexOfFirstContentView {
    
    NSInteger index = 0;
    for (index = 0; index < [self.view.subviews count]; index++) {
        
        UIView *v = [self.view.subviews objectAtIndex:index];
        if ([v isKindOfClass:[TabContentView class]]) {
            break;
        }
        
        
    }
    
    return index;    
}

- (TabContentViewController *) allocTabContentViewController {
	return nil;
}

- (BOOL) tabColorIsInUse:(UIColor *)c {
	
	for (UIView *v in self.view.subviews) {
		if ([v isKindOfClass:[TabContentView class]]) {
			TabContentView *tabContentView = (TabContentView *)v;
			if ([tabContentView.tabView.inactiveTabColor isEqual:c])
				return YES;
		}
	}
	
	return NO;
}

- (UIColor *) nextTabColor {
	
	for (NSInteger i = 0; i<[tabColorTheme count]; i++) {
		UIColor *c = [tabColorTheme objectAtIndex:i];
		if (![self tabColorIsInUse:c]) {
			
			[c retain];
			[tabColorTheme removeObjectAtIndex:i];
			[tabColorTheme insertObject:c atIndex:0];
			[c release];
			
			return c;
		}
	}

	UIColor *c = [tabColorTheme lastObject];
	
	[c retain];
	[tabColorTheme removeLastObject];
	[tabColorTheme insertObject:c atIndex:0];
	[c release];
	
	return c;
}

- (TabContentViewController *) createTabContentViewControllerWithState:(TabState)state withObject:(id)object {
	TabContentViewController *tabContentViewController = [self allocTabContentViewController];
	[tabContentViewController initWithTabState:state withParentController:self];
	tabContentViewController.tabContentView.tabView.inactiveTabColor = [self nextTabColor];	
    tabContentViewController.tabContentView.tabOrientation = tabOrientation;
	return tabContentViewController;
}

- (void) addTabController:(TabContentViewController *)viewController {
        	
	UIView *activeView = nil;
	for (TabContentViewController *vc in tabViewControllers) {
		if (vc.tabState == TAB_STATE_ACTIVE) {
			activeView = vc.view;
			break;
		}
	}

	[tabViewControllers addObject:viewController];
		
	if (viewController.tabState == TAB_STATE_NEW) {
		[self.view insertSubview:viewController.view atIndex:[self indexOfFirstContentView]];
	} else {
		if (activeView == nil) {
			[self.view addSubview:viewController.view];
		} else {
            if (viewController.tabState != TAB_STATE_INACTIVE) {
                NSLog (@"Wanring! More than 1 active tab found. There should be one 1 active tab");
                viewController.tabState = TAB_STATE_INACTIVE;
            }
			[self.view insertSubview:viewController.view belowSubview:activeView];
		}
	}
	
	[self.view setNeedsLayout];
}

- (void) removeTabController:(TabContentViewController *)viewController {
	[viewController.tabContentView removeFromSuperview];
	[tabViewControllers removeObject:viewController];
    [viewController removeFromParentViewController];
}

- (NSArray *) contentViewControllersOfState:(TabState)state {
	
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:3];
	
	for (TabContentViewController *viewController in tabViewControllers) {
		TabState s = viewController.tabContentView.tabView.state;
		if (s == state) {
			[result addObject:viewController];
		}
	}
	
	return result;	
	
}

- (void) activateLeftTab {
	
	TabContentViewController *activeTab = nil;
	for (TabContentViewController *vc in tabViewControllers) {
		if (vc.tabState == TAB_STATE_ACTIVE) {
			activeTab = vc;
		}
	}
	
	TabContentViewController *leftTab = nil;
	for (TabContentViewController *vc in tabViewControllers) {
		if (vc.tabIndex == activeTab.tabIndex-1) {
			leftTab = vc;
		}
	}
	
	if (leftTab && leftTab.tabState==TAB_STATE_INACTIVE) {
		[leftTab.tabContentView.tabView handleTouchAtPoint:CGPointMake(0, 0)];
	}
	
}

- (void) activateRightTab {
	
	TabContentViewController *activeTab = nil;
	for (TabContentViewController *vc in tabViewControllers) {
		if (vc.tabState == TAB_STATE_ACTIVE) {
			activeTab = vc;
		}
	}
	
	TabContentViewController *rightTab = nil;
	for (TabContentViewController *vc in tabViewControllers) {
		if (vc.tabIndex == activeTab.tabIndex+1) {
			rightTab = vc;
		}
	}
	
	if (rightTab && rightTab.tabState==TAB_STATE_INACTIVE) {
		[rightTab.tabContentView.tabView handleTouchAtPoint:CGPointMake(0, 0)];
	}
	
}

- (void) closeCurrentTab {
    
    NSLog (@"closeCurrentTab");
    if ([tabViewControllers count]<=2)
        return;
    
	TabContentViewController *activeTab = nil;
	for (TabContentViewController *vc in tabViewControllers) {
		if (vc.tabState == TAB_STATE_ACTIVE) {
			activeTab = vc;
		}
	}
    
    if (activeTab) {
        [self tabContentViewWillRemove:activeTab.tabContentView];
    }
}

- (void) setFullScreen:(BOOL)enable animated:(BOOL)animated {
    
    MultiTabView *view = (MultiTabView *)self.view;
    [view setFullScreen:enable animated:animated];
    
}

#pragma mark TabContentViewDelegate

- (void) inactivateAll {
	
	for (TabContentViewController *viewController in tabViewControllers) {
		if (viewController.tabContentView.tabView.state == TAB_STATE_ACTIVE) {
			viewController.tabContentView.tabView.state = TAB_STATE_INACTIVE;
		}
	}

}

- (void) newTabContentView:(TabContentView *)prevNewView {
	
	[self.view bringSubviewToFront:prevNewView];
	
	TabContentViewController *viewController  =  [self createTabContentViewControllerWithState:TAB_STATE_NEW withObject:nil];		
	viewController.tabContentView.delegate    =  self;
	viewController.tabIndex                   =  [tabViewControllers count];
	
	[self addTabController:viewController];
	[self.view insertSubview:viewController.view belowSubview:prevNewView];
	
	[viewController release];
}

- (void) newBackgroundTabContentView:(TabContentView *)prevNewView {
	
	TabContentViewController *viewController  =  [self createTabContentViewControllerWithState:TAB_STATE_NEW withObject:nil];		
	viewController.tabContentView.delegate    =  self;
	viewController.tabIndex                   =  [tabViewControllers count];
	
	[self addTabController:viewController];
	[self.view insertSubview:viewController.view belowSubview:prevNewView];
	
	[viewController release];
	
	
}


- (BOOL) tabContentView:(TabContentView *)tabContentView shouldChangeStateTo:(TabState) state previousState:(TabState) prevState {
	
	if (prevState == TAB_STATE_INACTIVE && state == TAB_STATE_ACTIVE) {

		/* Send current active view to back */
		[self inactivateAll];
		
		/* Bring this view to front */
//		[self.view performSelector:@selector(bringSubviewToFront:) 
//				   withObject:tabContentView
//				   afterDelay:0.2];
        [self.view bringSubviewToFront:tabContentView];


		/* relayout the tab scroll view */
		[self.view setNeedsLayout];

		return YES;
	}
	
	if (prevState == TAB_STATE_NEW && state == TAB_STATE_ACTIVE) {
		
		/* Send current active view to back */
		[self inactivateAll];
		
		/* Bring the new view to front after the animation */
		[self performSelector:@selector(newTabContentView:) 
				   withObject:tabContentView
				   afterDelay:0.2];
				
		return YES;
		
	}
	
	if (prevState == TAB_STATE_NEW && state == TAB_STATE_INACTIVE) {
		
		/* Bring the new view to front after the animation */
		[self performSelector:@selector(newBackgroundTabContentView:) 
				   withObject:tabContentView
				   afterDelay:0.2];
		
		return YES;

	}
	
	return NO;
}

- (void) scrollTabToVisible:(TabContentView *)tabContentView {
	
	CGRect frame = tabContentView.tabView.frame;
	frame.origin.x -= tabContentView.tabView.leftOffset;
	
	if (!CGRectContainsRect(tabScrollView.bounds, frame)) {
		[tabScrollView scrollRectToVisible:frame animated:YES];
	}
	
}

- (void) tabContentView:(TabContentView *)tabContentView didChangedStateTo:(TabState) state previousState:(TabState) prevState {

	if (state == TAB_STATE_ACTIVE) {
		
		if (prevState == TAB_STATE_NEW) {
			[self performSelector:@selector(scrollTabToVisible:) withObject:tabContentView afterDelay:0.3];
		} else {
			[self scrollTabToVisible:tabContentView];
		}
	}
	
	for (TabContentViewController *viewController in tabViewControllers) {
		if (viewController.view == tabContentView) {
			[viewController didChangeState:state previousState:prevState];
		}
	}
		
	
}


- (TabContentView *) frontTabContentView {
	
	NSInteger count = [self.view.subviews count];
	for (NSInteger i = count-1; i>=0; i--) {
		UIView *v = [self.view.subviews objectAtIndex:i];
		if ([v isKindOfClass:[TabContentView class]]) {
			return (TabContentView *)v;
		}
	}
	return nil;
}

- (BOOL) tabContentViewWillRemove:(TabContentView *)tabContentView {

	TabContentViewController *removingController = nil;
	for (TabContentViewController *controller in tabViewControllers) {
		if (controller.tabContentView == tabContentView) {
			removingController = controller;
			break;
		}
	}
	
	if (removingController) {
		
		NSInteger index = removingController.tabContentView.tabView.index;
		[self removeTabController:removingController];
		
		for (TabContentViewController *controller in tabViewControllers) {
			if (controller.tabContentView.tabView.index > index) {
				NSInteger tabIndex = controller.tabContentView.tabView.index;
				[controller setTabIndex:tabIndex-1 animated:YES];
			}
			if (controller.tabContentView.tabView.state == TAB_STATE_NEW) {
                [controller.tabContentView removeFromSuperview];
                [self.view insertSubview:controller.tabContentView atIndex:[self indexOfFirstContentView]];
			}
		}
		
		TabContentView *frontSubView = [self frontTabContentView];
		frontSubView.tabView.state = TAB_STATE_ACTIVE;
		
	}
	
	return YES;
}

- (BOOL) tabContentViewShouldShowDeleteBadge:(TabContentView *)tabContentView {

    if ([self.delegate respondsToSelector:@selector(multiTabViewController:shouldShowDeleteBadgeAtIndex:)]) {
        return [self.delegate multiTabViewController:self shouldShowDeleteBadgeAtIndex:tabContentView.tabView.index];
    }
    
	return [tabViewControllers count]>2;
}

#pragma mark UIScrollViewDelegate

- (void) tappedScrollView:(UIGestureRecognizer *)gestureRecognizer; {
	
	NSInteger count = [self.view.subviews count];
	for (NSInteger i = count-1; i>=0; i--) {

		UIView *v = [self.view.subviews objectAtIndex:i];
		if ([v isKindOfClass:[TabContentView class]]) {
			
			TabContentView *tabContentView = (TabContentView *)v;
			CGPoint touchLocation;
			
			touchLocation = [gestureRecognizer locationInView:tabContentView.tabView.deleteBadge];
			CGRect deleteBadgeBounds = tabContentView.tabView.deleteBadge.bounds;
			if (tabContentView.tabView.deleteBadge.alpha == 1.0 && CGRectContainsPoint(deleteBadgeBounds, touchLocation)) {
				[tabContentView.tabView.deleteBadge handleTouchAtPoint:touchLocation];
				break;
			}
			
			
			touchLocation = [gestureRecognizer locationInView:tabContentView.tabView];
			CGRect tabViewBounds = tabContentView.tabView.bounds;
			if (CGRectContainsPoint(tabViewBounds,touchLocation)) {
				TabView *tabView = tabContentView.tabView;
				[tabView handleTouchAtPoint:touchLocation];				
				break;
			}
			
		}
		
	}
	
	
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.view setNeedsLayout];	
}

#pragma mark public methods

- (NSInteger) numberOfViewControllers {
    return tabViewControllers.count;
}

- (UIViewController *) viewControllerAtIndex:(NSInteger)index {
    
    if (index < tabViewControllers.count) {
        
        for (TabContentViewController *vc in tabViewControllers) {
            if (vc.tabContentView.tabView.index == index) {
                return vc.contentViewController;
            }
        }
        
    }
    
    return nil;
}


- (void) setFullScreen:(BOOL)enable {
    [self setFullScreen:enable animated:NO];
}

- (BOOL) fullScreen {
    MultiTabView *view = (MultiTabView *)self.view;
    return view.fullScreen;
}

- (void) setTabOrientation:(ELTabOrientation)value {
    if (tabOrientation != value) {
        tabOrientation = value;
        
        if (self.viewIsLoaded) {
            
            MultiTabView *view = (MultiTabView *)self.view;
            view.tabOrientation = tabOrientation;
            
            for (TabContentViewController *controller in tabViewControllers) {
                controller.tabContentView.tabOrientation = tabOrientation;
            }
            
        }
    }
}

- (ELTabOrientation) tabOrientation {
    return tabOrientation;
}

- (void) setTabColors:(NSArray *)tabColors {
    [tabColorTheme setArray:tabColors];
}

- (NSArray *) tabColors {
    return tabColorTheme;
}

- (void) reloadData {
    
    
}

@end
