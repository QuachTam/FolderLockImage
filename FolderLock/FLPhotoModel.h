//
//  FLPhotoModel.h
//  FolderLock
//
//  Created by ATam on 7/22/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface FLPhotoModel : NSObject
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;

@property (nonatomic, retain) Photo *entity;

- (instancetype)initWithPhotoEntity:(Photo*)entity;
@end
