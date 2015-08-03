//
//  VCPhotoScrollView.h
//  Vaccinations
//
//  Created by Nguyen Le Duan on 12/26/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPhotoDetailViewController.h"

extern NSString * const VCPhotoScrollViewTappedNotification;

@interface VCPhotoScrollView : UIScrollView
@property (nonatomic, weak) id<VCPhotoDetailDataSource> dataSource;
@property (nonatomic) NSUInteger index;
@end
