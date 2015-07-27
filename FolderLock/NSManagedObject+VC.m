//
//  NSManagedObject+VC.m
//  FolderLock
//
//  Created by ATam on 7/27/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "NSManagedObject+VC.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation NSManagedObject (VC)
+ (instancetype)entityWithUuid:(NSString *)uuid inContext:(NSManagedObjectContext *)context {
    if (!uuid || uuid == (id)[NSNull null] || uuid.length == 0) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid=%@",uuid];
    id object = [[self class] MR_findFirstWithPredicate:predicate inContext:context];
    if (!object) {
        object = [[self class] MR_createEntityInContext:context];
        [object setValue:uuid forKey:VCUUID];
        [object setValue:[NSDate date] forKey:@"createDate"];
    }
    return object;
}
@end
