//
//  VCPhotoDetailViewController.h
//  Vaccinations
//
//  Created by Nguyen Le Duan on 12/26/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VCPhotoDetailDataSource <NSObject>
@required
- (UIImage *)photoAtIndex:(NSUInteger)index;
@end

@interface VCPhotoDetailViewController : UIViewController
@property (nonatomic, weak) id<VCPhotoDetailDataSource> dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
+ (VCPhotoDetailViewController *)photoViewControllerForPageIndex:(NSInteger)pageIndex;

@end
