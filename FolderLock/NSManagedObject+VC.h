//
//  NSManagedObject+VC.h
//  FolderLock
//
//  Created by ATam on 7/27/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (VC)
+ (instancetype)entityWithUuid:(NSString *)uuid inContext:(NSManagedObjectContext *)context;
@end
