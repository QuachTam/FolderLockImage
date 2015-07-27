//
//  FLBaseModel.m
//  FolderLock
//
//  Created by ATam on 7/27/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLBaseModel.h"

@implementation FLBaseModel
- (instancetype)init
{
    if (self = [super init]) {
        self.uuid = [[NSUUID UUID].UUIDString lowercaseString];
        self.createDate = [NSDate date];
    }
    return self;
}
@end
