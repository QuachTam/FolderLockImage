//
//  ListFolderModel.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "FLFolderModel.h"
#import "Folder.h"
#import "FLPhotoModel.h"
#import "FLUtinity.h"

@interface FLFolderModel()
@property (nonatomic, strong) Folder *folder;
@end
@implementation FLFolderModel
@synthesize uuid = _uuid;
@synthesize createDate = _createDate;

- (instancetype)initWithFolderEntity:(Folder*)entity {
    self = [super init];
    if (self) {
        self.folder = entity;
        self.uuid = entity.uuid;
    }
    return self;
}

- (NSString *)uuid {
    if (!_uuid) {
        _uuid = self.folder.uuid;
    }
    return _uuid;
}

-(NSString *)name {
    if (!_name) {
        _name = self.folder.name;
    }
    return _name;
}

- (NSString *)password {
    if (!_password) {
        _password = self.folder.password;
    }
    return _password;
}

- (NSString *)stringCreateDate {
    if (!_stringCreateDate) {
        if (self.folder.createDate) {
            _stringCreateDate = [FLUtinity convertStringFromDate:self.folder.createDate];
        }
    }
    return _stringCreateDate;
}

- (BOOL)isPassword {
    if (self.folder.password.length) {
        return YES;
    }
    return NO;
}

- (NSString *)urlIcon {
    if (!_urlIcon) {
        NSArray *listPhoto = [FLUtinity sortPhotoWithCreateDate:[self.folder.photos allObjects]];
        if (listPhoto.count) {
            Photo *entity = [listPhoto lastObject];
            _urlIcon = entity.url;
        }
    }
    return _urlIcon;
}

- (NSArray *)listPhotoModel {
    if (!_listPhotoModel) {
        NSMutableArray *listModel = [[NSMutableArray alloc] init];
        NSArray *listPhoto = [self.folder.photos allObjects];
        for (NSInteger index=0; index<listPhoto.count; index++) {
            FLPhotoModel *model = [[FLPhotoModel alloc] initWithPhotoEntity:[listPhoto objectAtIndex:index]];
            [listModel addObject:model];
        }
        _listPhotoModel = [FLUtinity sortPhotoWithCreateDate:listModel];
    }
    return _listPhotoModel;
}



@end
