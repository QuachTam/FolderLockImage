//
//  FLPhotoModel.m
//  FolderLock
//
//  Created by ATam on 7/22/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLPhotoModel.h"
#import "FLUtinity.h"
#import "Folder.h"

@implementation FLPhotoModel
@synthesize createDate = _createDate;

- (instancetype)initWithPhotoEntity:(Photo*)entity {
    self = [super init];
    if (self) {
        self.entity = entity;
        self.uuid = self.entity.uuid;
    }
    return self;
}

- (NSString *)name {
    if (!_name) {
        _name = self.entity.name ? self.entity.name : @"";
    }
    return _name;
}

- (NSString *)url {
    if (!_url) {
        _url = self.entity.url ? self.entity.url : @"";
    }
    return _url;
}

- (NSString *)stringCreateDate {
    if (!_stringCreateDate) {
        _stringCreateDate = [FLUtinity convertStringFromDate:self.entity.createDate];
    }
    return _stringCreateDate;
}

- (NSString *)folderUUID {
    if (!_folderUUID) {
        _folderUUID = self.entity.folder.uuid;
    }
    return _folderUUID;
}

- (NSDate *)createDate {
    if (!_createDate) {
        _createDate = self.entity.createDate;
    }
    return _createDate;
}
@end

