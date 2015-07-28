//
//  FLUtinity.m
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLUtinity.h"

@implementation FLUtinity

+ (NSString *)convertStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSArray *)sortPhotoWithCreateDate:(NSArray *)array {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}
@end
