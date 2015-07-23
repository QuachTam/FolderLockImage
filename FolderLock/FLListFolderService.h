//
//  ListFolderService.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLFolderModel.h"

@interface FLListFolderService : NSObject
@property (nonatomic, strong) NSArray *listModelFolder;
@property (nonatomic, copy, readwrite) void(^resultsChangeInsert)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^resultsChangeDelete)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^resultsChangeUpdate)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^resultsChangeMove)(NSArray *arrayIndexPath);
@property (nonatomic, copy, readwrite) void(^willChangeContent)();
@property (nonatomic, copy, readwrite) void(^didChangeContent)();

@property (nonatomic, copy, readwrite) void(^didFinishFetchResults)();
- (void)fetchDatabase;
- (void)deleteFolder:(FLFolderModel*)folderModel;
@end
