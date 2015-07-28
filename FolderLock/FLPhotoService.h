//
//  FLPhotoService.h
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLPhotoService : NSObject
@property (nonatomic, strong) NSArray *listPhotoModel;
@property (nonatomic, copy, readwrite) void(^resultsChangeInsert)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^resultsChangeDelete)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^resultsChangeUpdate)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^resultsChangeMove)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^willChangeContent)();
@property (nonatomic, copy, readwrite) void(^didChangeContent)();

@property (nonatomic, copy, readwrite) void(^didFinishFetchResults)();
- (void)fetchDatabase;
@end
