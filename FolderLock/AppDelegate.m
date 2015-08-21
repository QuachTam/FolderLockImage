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
/* Import StartApp SDK framework */
#import <StartApp/StartApp.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FLStringHelper.h"
#import "MHGalleryImageViewerViewController.h"

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
    
    MHGalleryCustomLocalizationBlock(^NSString *(NSString *stringToLocalize) {
        return nil;
    });
    
    MHGalleryCustomImageBlock(^UIImage *(NSString *imageToChangeName) {
        return nil;
    });
    
    [self settingStartAppSDK];
    [self settingPasscode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertView:) name:kShowAlertView object:nil];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)showAlertView:(NSNotification*)notification {
    NSDictionary *dict = notification.object;
    NSString *title = [dict objectForKey:@"title"];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertview show];
}

- (void)settingStartAppSDK {
    // initialize the SDK with your appID and devID
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.appID = @"207556413";
    sdk.devID = @"107367486";
    sdk.preferences = [STASDKPreferences prefrencesWithAge:28 andGender:STAGender_Male];
    
    STASplashPreferences *splashPreferences = [[STASplashPreferences alloc] init];
    splashPreferences.splashMode = STASplashModeTemplate;
    splashPreferences.splashTemplateTheme = STASplashTemplateThemeOcean;
    splashPreferences.splashLoadingIndicatorType = STASplashLoadingIndicatorTypeDots;
    splashPreferences.splashTemplateIconImageName = @"startApp";
    splashPreferences.splashTemplateAppName = @"Folder Lock Start";
    
}

- (void)settingPasscode {
    [[LTHPasscodeViewController sharedUser] setKeychainPasscodeUsername:kKeychainPasscode];
    [[LTHPasscodeViewController sharedUser] setKeychainServiceName:kKeychainService];
    [LTHPasscodeViewController sharedUser].maxNumberOfAllowedFailedAttempts = 3;
    [[LTHPasscodeViewController sharedUser] setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]];
    [[LTHPasscodeViewController sharedUser] setPasscodeTextColor:[UIColor blackColor]];
    [[LTHPasscodeViewController sharedUser] setLabelTextColor:[UIColor blackColor]];
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
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
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
