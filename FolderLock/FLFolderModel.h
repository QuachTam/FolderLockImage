//
//  ListFolderModel.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"
#import "FLBaseModel.h"

@interface FLFolderModel : FLBaseModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *stringCreateDate;
@property (nonatomic, strong) NSString *urlIcon;
@property (nonatomic, strong) NSArray *listPhotoModel;
@property (nonatomic, readwrite) BOOL isPassword;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *rePassword;
- (instancetype)initWithFolderEntity:(Folder*)entity;
@end
