//
//  FLFolderListViewController.h
//  FolderLock
//
//  Created by QSOFT on 7/13/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StartApp/StartApp.h>

@interface FLFolderListViewController : UIViewController<STADelegateProtocol>{
    /*
     Declaration of STAStartAppAd which later on will be used
     for loading within the viewDidApear and displaying when
     clicking a button
     */
    STAStartAppAd *startAppAd_autoLoad;
    
    /*
     Declaration of STAStartAppAd which later on will be used
     for loading when user clicks on a button and showing the
     loaded ad when the ad was loaded with delegation
     */
    STAStartAppAd *startAppAd_loadShow;
    
    /*
     Declaration of StartApp Banner view with automatic positioning
     */
    STABannerView *startAppBanner_auto;
    
    /*
     Declaration of StartApp Banner view with fixed positioning and size
     */
    STABannerView *startAppBanner_fixed;
    
}

@end
