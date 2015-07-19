//
//  Base.h
//  FolderLock
//
//  Created by ATam on 7/19/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Base : NSManagedObject

@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSString * uuid;

@end
