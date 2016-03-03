//
//  AppDelegate.m
//  Music
//
//  Created by thanhhaitran on 11/24/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "AppDelegate.h"

#import "M_First_ViewController.h"

#import "YoutubeChildViewController.h"

#import "M_Second_ViewController.h"

#import "M_RootViewController.h"

#import <StartApp/StartApp.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.appID = kStartAppId;
    sdk.devID = kStartAppDev;
        
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)])
    {
        if(SYSTEM_VERSION_GREATER_THAN(@"7"))
            [UINavigationBar appearance].tintColor = [AVHexColor colorWithHexString:@"#FFFFFF"];
    }
    
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
//                                           forState:UIControlStateNormal];
//    
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
//                                           forState:UIControlStateSelected];
    
    [self addObject:@{@"banner":@"0",@"fullBanner":@"0",@"adsMob":@"0"} andKey:@"adsInfo"];
    
    [[UITabBar appearance] setSelectedImageTintColor:[AVHexColor colorWithHexString:kColor]];

    [[LTRequest sharedInstance] initRequest];
    
    self.window.rootViewController =  [M_RootViewController new];//[[UINavigationController alloc] initWithRootViewController:[M_First_ViewController new]];
    
    [self.window makeKeyAndVisible];
    
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
    // Saves changes in the application's managed object context before the application terminates.
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    UIViewController * presentedViewController = window.rootViewController.presentedViewController;
    if (presentedViewController)
    {
        if(![presentedViewController isKindOfClass:[YoutubeChildViewController class]])
        {
            return UIInterfaceOrientationMaskPortrait;
        }
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
