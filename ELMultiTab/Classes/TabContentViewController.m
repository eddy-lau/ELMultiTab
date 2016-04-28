    //
//  TabContentViewController.m
//  Browser
//
//  Created by Eddie Hiu-Fung Lau on 10/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TabContentViewController.h"
#import "ELMultiTabViewController.h"


@implementation TabContentViewController

@synthesize delegate,parentController;

- (id) initWithTabState:(TabState) state withParentController:(ELMultiTabViewController *)multiTabViewController {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        initialState      =  state;
        parentController  =  multiTabViewController;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)loadView {
	
	
    CGRect           appFrame       = [UIScreen mainScreen].applicationFrame;	
	TabContentView  *v              = [[TabContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, appFrame.size.height)];
	v.tabView.state                 = initialState;
	v.autoresizingMask             |= UIViewAutoresizingFlexibleWidth;
	v.autoresizingMask             |= UIViewAutoresizingFlexibleHeight;
	
	self.view = v;
    [v release];
	
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tabContentView.contentView addSubview:self.contentViewController.view];
    self.tabContentView.tabView.title = self.contentViewController.title;
}

- (TabContentView *) tabContentView {
	return (TabContentView *)self.view;
}

- (void) setTabIndex:(NSInteger)index animated:(BOOL)animated {
	[self.tabContentView.tabView setIndex: index animated:animated];
}

- (void) setTabIndex:(NSInteger) newTabIndex {	
	[self setTabIndex:newTabIndex animated:NO];
}


- (NSInteger) tabIndex {
	return self.tabContentView.tabView.index;
}


- (void) setTabState:(TabState)newState {
	self.tabContentView.tabView.state = newState;
}

- (TabState) tabState {
	return self.tabContentView.tabView.state;
}

- (void) didChangeState:(TabState) state previousState:(TabState)previousState {
    
    if (state == TAB_STATE_ACTIVE) {
        
        [self.parentViewController.navigationItem setRightBarButtonItem:self.contentViewController.navigationItem.rightBarButtonItem animated:NO];
        
    } else {
        
        [self.parentViewController.navigationItem setRightBarButtonItem:nil animated:NO];
        
    }
    
}

- (void) activateLeftTab {
    
    if (self.tabState == TAB_STATE_ACTIVE) {
        [parentController activateLeftTab];
    }
    
}

- (void) activateRightTab {
    
    if (self.tabState == TAB_STATE_ACTIVE) {
        [parentController activateRightTab];
    }
    
}

- (void) closeTab {
    
    if (self.tabState == TAB_STATE_ACTIVE) {
        [parentController closeCurrentTab];
    }
}

- (void) setContentViewController:(UIViewController *)contentViewController {
    
    NSArray *children = [[self.childViewControllers copy] autorelease];
    for (UIViewController *vc in children) {
        [vc removeFromParentViewController];
    }
    
    [self addChildViewController:contentViewController];
}

- (UIViewController *) contentViewController {
    
    if (self.childViewControllers.count > 0) {
        return self.childViewControllers[0];
    } else {
        return nil;
    }
    
    
}

@end
