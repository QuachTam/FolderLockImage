//
//  VCPhotoDetailViewController.m
//  Vaccinations
//
//  Created by Nguyen Le Duan on 12/26/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import "VCPhotoDetailViewController.h"
#import "VCPhotoScrollView.h"

@implementation VCPhotoDetailViewController
+ (VCPhotoDetailViewController *)photoViewControllerForPageIndex:(NSInteger)pageIndex
{
    return [[self alloc] initWithPageIndex:pageIndex];
}

- (id)initWithPageIndex:(NSInteger)pageIndex
{
    if (self = [super init])
    {
        self.pageIndex = pageIndex;
    }
    
    return self;
}


- (void)loadView
{
    VCPhotoScrollView *scrollView   = [[VCPhotoScrollView alloc] init];
    scrollView.dataSource           = self.dataSource;
    scrollView.index                = self.pageIndex;
    
    self.view = scrollView;
}
@end
