//
//  VCPhotoPageController.m
//  Vaccinations
//
//  Created by Nguyen Le Duan on 12/26/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import "VCPhotoPageController.h"
#import "VCPhotoScrollView.h"
#import "FLPhotoModel.h"
#import "FLButtonHelper.h"
#import "FLManageImage.h"
#import "FLFolderModel.h"

@interface VCPhotoPageController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, VCPhotoDetailDataSource>
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign, getter = isStatusBarHidden) BOOL statusBarHidden;
@end

@implementation VCPhotoPageController
- (id)initWithPhotos:(NSArray *)photos
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@30.f}];
    if (self)
    {
        self.photos                 = photos;
        self.dataSource             = self;
        self.delegate               = self;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor   = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addNotificationObserver];
    [self configureNavigationBar];
}

- (void)dealloc
{
    [self removeNotificationObserver];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}

- (void)configureNavigationBar
{
    UIButton *backBt = fl_buttonBack();
    [backBt addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBt];
}

#pragma mark - Actions

- (void)backClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Update Title

- (void)setTitleIndex:(NSInteger)index
{
    NSInteger count = self.photos.count;
    self.title      = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%ld / %ld", @"CTAssetsPickerController", nil), index, count];
}

- (void)setTitleWithText:(NSString*)title
{
    self.title      = title;
}

#pragma mark - Page Index

- (NSInteger)pageIndex
{
    return ((VCPhotoDetailViewController *)self.viewControllers[0]).pageIndex;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    NSInteger count = self.photos.count;
    
    if (pageIndex >= 0 && pageIndex < count)
    {
        VCPhotoDetailViewController *page = [VCPhotoDetailViewController photoViewControllerForPageIndex:pageIndex];
        page.dataSource = self;
        
        [self setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
        
        [self setTitleIndex:pageIndex + 1];
    }
}

- (void)setPageIndex:(NSInteger)pageIndex title:(NSString*)title
{
    NSInteger count = self.photos.count;
    
    if (pageIndex >= 0 && pageIndex < count)
    {
        VCPhotoDetailViewController *page = [VCPhotoDetailViewController photoViewControllerForPageIndex:pageIndex];
        page.dataSource = self;
        
        [self setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
        
        [self setTitleWithText:title];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((VCPhotoDetailViewController *)viewController).pageIndex;
    
    if (index > 0)
    {
        VCPhotoDetailViewController *page = [VCPhotoDetailViewController photoViewControllerForPageIndex:(index - 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger count = self.photos.count;
    NSInteger index = ((VCPhotoDetailViewController *)viewController).pageIndex;
    
    if (index < count - 1)
    {
        VCPhotoDetailViewController *page = [VCPhotoDetailViewController photoViewControllerForPageIndex:(index + 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        VCPhotoDetailViewController *vc   = (VCPhotoDetailViewController *)pageViewController.viewControllers[0];
        NSInteger index                 = vc.pageIndex + 1;
        
        [self setTitleIndex:index];
    }
}


#pragma mark - Notification Observer

- (void)addNotificationObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(scrollViewTapped:)
                   name:VCPhotoScrollViewTappedNotification
                 object:nil];
}

- (void)removeNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VCPhotoScrollViewTappedNotification object:nil];
}


#pragma mark - Tap Gesture

- (void)scrollViewTapped:(NSNotification *)notification
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)notification.object;
    
    if (gesture.numberOfTapsRequired == 1)
        [self toogleNavigationBar:gesture];
}


#pragma mark - Fade in / away navigation bar

- (void)toogleNavigationBar:(id)sender
{
    if (self.isStatusBarHidden)
        [self fadeNavigationBarIn];
    else
        [self fadeNavigationBarAway];
}

- (void)fadeNavigationBarAway
{
    self.statusBarHidden = YES;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                         [self.navigationController.navigationBar setAlpha:0.0f];
                         [self.navigationController setNavigationBarHidden:YES];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)fadeNavigationBarIn
{
    self.statusBarHidden = NO;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                         [self.navigationController.navigationBar setAlpha:1.0f];
                         [self.navigationController setNavigationBarHidden:NO];
                     }];
}



#pragma mark - VCPhotoViewControllerDataSource

- (UIImage *)photoAtIndex:(NSUInteger)index;
{
    FLPhotoModel *object = [self.photos objectAtIndex:index];
    FLFolderModel *folder = [[FLFolderModel alloc] initWithFolderEntity:object.entity.folder];
    UIImage *image = [FLManageImage getImage:object.uuid folderID:folder.uuid];
    return image;
}


@end
