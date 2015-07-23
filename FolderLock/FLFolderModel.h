//
//  ListFolderModel.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"

@interface FLFolderModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSArray *listPhotoModel;
@property (nonatomic, readwrite) BOOL isPassword;
@property (nonatomic, strong) NSString *password;
- (instancetype)initWithFolderEntity:(Folder*)entity;
@end
