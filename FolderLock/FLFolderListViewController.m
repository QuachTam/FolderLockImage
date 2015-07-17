//
//  FLFolderListViewController.m
//  FolderLock
//
//  Created by QSOFT on 7/13/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLFolderListViewController.h"
#import "FLButtonHelper.h"
#import "FLSettingViewController.h"
#import "FLAccountViewController.h"
#import "STAViewController.h"

@interface FLFolderListViewController ()

@end

@implementation FLFolderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _LSFromTable(@"title.strings", @"FLFolderListViewController", @"List Folder");
    UIButton *settingButton = fl_buttonSetting();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [settingButton addTarget:self action:@selector(settingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraButton = fl_buttonCamera();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    [settingButton addTarget:self action:@selector(cameraTap:) forControlEvents:UIControlEventTouchUpInside];
    
    FLAccountViewController *account = [[FLAccountViewController alloc] initWithNibName:NSStringFromClass([FLAccountViewController class]) bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:account];
    [self presentViewController:nav animated:YES completion:nil];
    
    // Initialize the ad
    /*
     Init of the startapp interstitials
     NOTE: replace the ApplicationID and the PublisherID with your own IDs
     */
    startAppAd_autoLoad = [[STAStartAppAd alloc] init];
    startAppAd_loadShow = [[STAStartAppAd alloc] init];
    
    [self btnLoadShowClick:nil];
}

#pragma mark Action

- (void)settingTap:(id)sender {
    FLSettingViewController *setting = [[FLSettingViewController alloc] initWithNibName:NSStringFromClass([FLSettingViewController class]) bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setting];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cameraTap:(id)sencer {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // loading the StartApp Ad
    [startAppAd_autoLoad loadAdWithDelegate:self];
    
    /*
     load the StartApp auto position banner, banner size will be assigned automatically by  StartApp
     NOTE: replace the ApplicationID and the PublisherID with your own IDs
     */
    if (startAppBanner_auto == nil) {
        startAppBanner_auto = [[STABannerView alloc] initWithSize:STA_AutoAdSize
                                                       autoOrigin:STAAdOrigin_Bottom
                                                         withView:self.view withDelegate:nil];
        [self.view addSubview:startAppBanner_auto];
    }
    
    /*
     load the StartApp fixed position banner - in (0, 200)
     NOTE: replace the ApplicationID and the PublisherID with your own IDs
     */
    if (startAppBanner_fixed == nil) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_768x90
                                                                origin:CGPointMake(0,self.view.frame.size.height-90)
                                                              withView:self.view withDelegate:nil];
        } else {
            startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_320x50
                                                                origin:CGPointMake(0,self.view.frame.size.height-50)
                                                              withView:self.view withDelegate:nil];
        }
        
        [self.view addSubview:startAppBanner_fixed];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // notify StartApp auto Banner orientation change
    [startAppBanner_auto didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    // notify StartApp fixed position Banner orientation change
    [startAppBanner_fixed didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation ];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate{
    return YES && (startAppAd_loadShow.STAShouldAutoRotate || startAppAd_autoLoad.STAShouldAutoRotate);
}

#pragma mark ShowAd button click
- (IBAction)btnShowAdClick:(id)sender
{
    /*
     displaying StartApp ad.
     NOTE:  Since the loadAd method is async,
     it is possible that when calling the showAd method the
     ad hasn't been loaded yet.
     You can verify that by using the isReady method.
     */
    [startAppAd_autoLoad showAd];
}

#pragma mark Load and Show button click
- (IBAction)btnLoadShowClick:(id)sender
{
    // load StartApp ad with Automatic AdType and self view controller
    // as a delegation for callbacks
    [startAppAd_loadShow loadAdWithDelegate:self];
}

#pragma mark STADelegateProtocol methods
/*
 Implementation of the STADelegationProtocol.
 All methods here are optional and you can
 implement only the ones you need.
 */

// StartApp Ad loaded successfully
- (void) didLoadAd:(STAAbstractAd*)ad;
{
    NSLog(@"StartApp Ad had been loaded successfully");
    
    // Show the Ad
    if (startAppAd_loadShow == ad) {
        [startAppAd_loadShow showAd];
    }
}

// StartApp Ad failed to load
- (void) failedLoadAd:(STAAbstractAd*)ad withError:(NSError *)error;
{
    NSLog(@"StartApp Ad had failed to load");
}

// StartApp Ad is being displayed
- (void) didShowAd:(STAAbstractAd*)ad;
{
    NSLog(@"StartApp Ad is being displayed");
}

// StartApp Ad failed to display
- (void) failedShowAd:(STAAbstractAd*)ad withError:(NSError *)error;
{
    
    NSLog(@"StartApp Ad is failed to display");
    if (startAppAd_autoLoad == ad) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can't show ad" message:@"Ad is not loaded yet, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) didCloseAd:(STAAbstractAd*)ad {
    if (startAppAd_autoLoad == ad) {
        [startAppAd_autoLoad loadAdWithDelegate:self];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
