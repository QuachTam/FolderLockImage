//
//  FLManageImage.h
//  FolderLock
//
//  Created by ATam on 7/27/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLManageImage : NSObject
+ (UIImage*)getImage:(NSString*)nameImage folderID:(NSString*)folderID;
+ (NSString*)getContentOfFilemage:(NSString*)nameImage folderID:(NSString*)folderID;
+ (void)saveImage:(UIImage*)image withName:(NSString*)nameImage folderUUID:(NSString *)folderUUID;
+(void)deleteImageWithName:(NSString*)nameImage folderUUID:(NSString*)folderUUID;
+(void)deleteFolder:(NSString*)folderUUID;
+ (NSString *)getURLPathImage:(NSString*)nameImage folderID:(NSString*)folderID;
+ (NSString*)getURLPathThumbnailImage:(NSString *)nameImage folderID:(NSString *)folderID;
@end
