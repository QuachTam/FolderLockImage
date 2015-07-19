//
//  Photo.h
//  FolderLock
//
//  Created by ATam on 7/19/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Base.h"

@class Folder;

@interface Photo : Base

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Folder *folder;

@end
