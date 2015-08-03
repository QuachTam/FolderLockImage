//
//  VCPhotoPageController.h
//  Vaccinations
//
//  Created by Nguyen Le Duan on 12/26/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCPhotoPageController : UIPageViewController
- (id)initWithPhotos:(NSArray *)photos;
@property (nonatomic, assign) NSInteger pageIndex;
- (void)setPageIndex:(NSInteger)pageIndex title:(NSString*)title;
@end
