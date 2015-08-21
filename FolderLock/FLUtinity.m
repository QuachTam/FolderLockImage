//
//  FLUtinity.m
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLUtinity.h"

@implementation FLUtinity

+ (NSString *)convertStringDateDetailFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)convertStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSArray *)sortPhotoWithCreateDate:(NSArray *)array asceding:(BOOL)ascending{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate"
                                                 ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

+ (BOOL)countShowAds {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults valueForKey:@"countShowAds"];
    NSInteger count = [string integerValue];
    if (count<3) {
        count++;
    }else{
        count = 0;
    }
    [defaults setValue:[NSString stringWithFormat:@"%ld", count] forKey:@"countShowAds"];
    if (count==0) {
        return YES;
    }else{
        return NO;
    }
    return YES;
}

@end
