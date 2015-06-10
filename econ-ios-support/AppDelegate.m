//
//  AppDelegate.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+ECMColor.h"
#import "ECMLib.h"
#import "SupportsTableViewController.h"
#import "StreamTableViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong)UITabBarController *tabarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.tabarController = [[UITabBarController alloc] init];
    
    self.window = [UIWindow new];
    self.window.tintColor = [UIColor ecm_orange];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [[UIScreen mainScreen] bounds];
    [self.window makeKeyAndVisible];
    
    SupportsTableViewController *stvc = [[SupportsTableViewController alloc] init];
    
    ECMNavigationController *streamNav = [[ECMNavigationController alloc] initWithNavigationBarClass:[ECMNavigationBar class] toolbarClass:[UIToolbar class]];
    StreamTableViewController *svc = [[StreamTableViewController alloc] init];
    [streamNav pushViewController:svc animated:NO];
    
    ECMNavigationController *nav = [[ECMNavigationController alloc] initWithNavigationBarClass:[ECMNavigationBar class] toolbarClass:[UIToolbar class]];
    [nav pushViewController:stvc animated:YES];
    self.tabarController.viewControllers = @[nav, streamNav];
    self.window.rootViewController = self.tabarController;
    
    
    UIImage *tap2 = [UIImage imageNamed:@"tabbar_stream"];
    UIImage *tap1 = [UIImage imageNamed:@"tabbar_supporters"];
    UITabBarItem *tabbarItemSupporters = [[UITabBarItem alloc] initWithTitle:nil image:tap1 selectedImage:tap1];
    UITabBarItem *tabbarItemStream = [[UITabBarItem alloc] initWithTitle:nil image:tap2 selectedImage:tap2];
    
    nav.tabBarItem = tabbarItemSupporters;
    streamNav.tabBarItem = tabbarItemStream;
    
    // Magic top inset to position title-less tabbar icons
    float topInset = 5.0f;
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(topInset, 0.0f, -topInset, 0.0f);
    streamNav.tabBarItem.imageInsets = UIEdgeInsetsMake(topInset, 0.0f, -topInset, 0.0f);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
