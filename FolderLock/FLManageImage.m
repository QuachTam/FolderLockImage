//
//  FLManageImage.m
//  FolderLock
//
//  Created by ATam on 7/27/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLManageImage.h"

@implementation FLManageImage

+ (UIImage*)getImage:(NSString*)nameImage folderID:(NSString*)folderID{
    NSString *folderPath = [self getPathWithFolder:folderID];
    NSString *getImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

+ (void)saveImage:(UIImage*)image withName:(NSString*)nameImage folderUUID:(NSString *)folderUUID{
    NSString *folderPath = [self getPathWithFolder:folderUUID];
    NSString *savedImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
}

+ (NSString*)getPathWithFolder:(NSString*)folderUUID{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", folderUUID]];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return folderPath;
}

@end
