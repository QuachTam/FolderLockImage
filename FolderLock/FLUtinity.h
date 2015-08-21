//
//  FLUtinity.h
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUtinity : NSObject
+ (NSString *)convertStringFromDate:(NSDate *)date;
+ (NSString *)convertStringDateDetailFromDate:(NSDate *)date;
+ (NSArray *)sortPhotoWithCreateDate:(NSArray *)array asceding:(BOOL)ascending;
+ (BOOL)countShowAds;
@end
