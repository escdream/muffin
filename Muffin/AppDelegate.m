//
//  AppDelegate.m
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "NavigationController.h"

#import "UserViewController.h"
#import "MainScreenViewController.h"
#import "TONavigationBar.h"
#import "CommonUtil.h"
#import "UserInfo.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>



@interface AppDelegate ()
{

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    RootViewController *viewController;
//    viewController = [RootViewController new];

    [self initMuffinData];

    MainScreenViewController * viewController =  [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil];
    
    NavigationController *navigationController = [[NavigationController alloc]  initWithNavigationBarClass:[TONavigationBar class] toolbarClass:nil];
    
    [navigationController pushViewController:viewController animated:NO];
    
    MainViewController *mainViewController = [MainViewController new];
    
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:1];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void) initMuffinData
{
 
    NSString * sUserId = [CommonUtil getStringForKey:@"userinfo.userid" basic:@""];
    
    // before login User;
    if (![sUserId isEqualToString:@""] && sUserId.length > 3)
    {
        // 자동 로그인 처리
    }
    else
    {
        [UserInfo instance].userLoginState = UserInfoStateNone;
    }
    
}





- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}



@end

