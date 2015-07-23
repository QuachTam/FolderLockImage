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

@interface FLFolderModel()
@property (nonatomic, strong) Folder *folder;
@end
@implementation FLFolderModel
- (instancetype)initWithFolderEntity:(Folder*)entity {
    self = [super init];
    if (self) {
        self.folder = entity;
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

- (NSString *)createDate {
    if (!_createDate) {
        if (self.folder.createDate) {
            _createDate = [self convertStringFromDate:self.folder.createDate];
        }
    }
    return _createDate;
}

- (BOOL)isPassword {
    if (self.folder.password.length) {
        return YES;
    }
    return NO;
}

- (NSArray *)listPhotoModel {
    if (!_listPhotoModel) {
        NSMutableArray *listModel = [[NSMutableArray alloc] init];
        NSArray *listPhoto = [self.folder.photos allObjects];
        for (NSInteger index=0; index<listPhoto.count; index++) {
            FLPhotoModel *model = [[FLPhotoModel alloc] initWithPhotoEntity:[listPhoto objectAtIndex:index]];
            [listModel addObject:model];
        }
        _listPhotoModel = [self sortPhoto:listModel];
    }
    return _listPhotoModel;
}

- (NSArray *)sortPhoto:(NSArray *)listPhotoModel {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [listPhotoModel sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

- (NSString *)convertStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}
@end
