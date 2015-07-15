//
//  AppDelegate.m
//  FolderLock
//
//  Created by QSOFT on 7/13/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "AppDelegate.h"
#import "LTHPasscodeViewController.h"
#import "FLFolderListViewController.h"
#import <MagicalRecord/MagicalRecord.h>

NSString * const kCoreDataFileName = @"FolderLock.sqlite";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kCoreDataFileName];
    
    [[UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:H3_COLOR, NSForegroundColorAttributeName,VCTitleFont(30), NSFontAttributeName, nil]];
    
    FLFolderListViewController *folderList = [[FLFolderListViewController alloc] initWithNibName:NSStringFromClass([FLFolderListViewController class]) bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderList];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)settingPasscode {
    [[LTHPasscodeViewController sharedUser] setKeychainPasscodeUsername:kKeychainPasscode];
    [[LTHPasscodeViewController sharedUser] setKeychainServiceName:kKeychainService];
    [LTHPasscodeViewController sharedUser].maxNumberOfAllowedFailedAttempts = 3;
    
    [[LTHPasscodeViewController sharedUser] setPasscodeTextColor:[UIColor whiteColor]];
    [[LTHPasscodeViewController sharedUser] setLabelTextColor:[UIColor whiteColor]];
    [[LTHPasscodeViewController sharedUser] setLabelFont:[UIFont systemFontOfSize:20]];
    
    
    NSUserDefaults *userDetault = [NSUserDefaults standardUserDefaults];
    BOOL isDelete = [userDetault boolForKey:kInstallApplication];
    if (!isDelete) {
        [userDetault setBool:YES forKey:kInstallApplication];
        [LTHPasscodeViewController deletePasscode];
    }
    
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES
                                                                 withLogout:NO
                                                             andLogoutTitle:nil];
    }
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

@end
