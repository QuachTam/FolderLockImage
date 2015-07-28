//
//  FLPhotoModel.h
//  FolderLock
//
//  Created by ATam on 7/22/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
#import "FLBaseModel.h"

@interface FLPhotoModel :FLBaseModel
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, strong) NSString * stringCreateDate;
@property (nonatomic, strong) NSString * folderUUID;
@property (nonatomic, retain) Photo *entity;

- (instancetype)initWithPhotoEntity:(Photo*)entity;
@end
