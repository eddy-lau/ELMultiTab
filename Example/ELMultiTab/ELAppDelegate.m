//
//  ELAppDelegate.m
//  ELMultiTab
//
//  Created by Eddie Lau on 04/28/2016.
//  Copyright (c) 2016 Eddie Lau. All rights reserved.
//

#import "ELAppDelegate.h"
#import <ELMultiTab/ELMultiTab.h>

@interface ELAppDelegate () <MultiTabViewControllerDataSource>

@property (nonatomic,strong) UIViewController *viewController1;
@property (nonatomic,strong) UIViewController *viewController2;
@property (nonatomic,strong) UIViewController *viewController3;

@end

@implementation ELAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.viewController1 = [[UIViewController alloc] init];
    self.viewController1.title = @"Tab 1";
    
    self.viewController2 = [[UIViewController alloc] init];
    self.viewController2.title = @"Tab 2";
    
    self.viewController3 = [[UIViewController alloc] init];
    self.viewController3.title = @"Tab 3";
    
    ELMultiTabViewController *multiTabViewController = [[ELMultiTabViewController alloc] init];
    multiTabViewController.dataSource = self;
    
    /* Customizable tab orientations */
    //multiTabViewController.tabOrientation = TAB_ORIENATION_BOTTOM;
    
    /* Customizable tab colors. Uncomment below to customize
     
    multiTabViewController.tabColors = [NSArray arrayWithObjects:
                      [UIColor colorWithRed:255.0/255.0 green:196.0/255.0 blue:18.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:235.0/255.0 green: 46.0/255.0 blue:53.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:143.0/255.0 green:101.0/255.0 blue:175.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:166.0/255.0 green:123.0/255.0 blue:55.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:34.0/255.0 green:184.0/255.0 blue:182.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:230.0/255.0 green:133.0/255.0 blue:186.0/255.0 alpha:1.0],
                      [UIColor colorWithRed:240.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0],
                      nil];
     
     */
    
    self.window.rootViewController = multiTabViewController;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark MultiTabViewControllerDataSource

- (NSInteger)numberOfTabsInMultiTabViewController:(ELMultiTabViewController *)controller {
    return 3;
}

- (UIViewController *)multiTabViewController:(ELMultiTabViewController *)controller viewControllerWithIndex:(NSInteger)index {
    
    if (index == 0) {
        return self.viewController1;
    } else if (index == 1) {
        return self.viewController2;
    } else if (index == 2) {
        return self.viewController3;
    } else {
        return nil;
    }
}

@end
