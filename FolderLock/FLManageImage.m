//
//  FLManageImage.m
//  FolderLock
//
//  Created by ATam on 7/27/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLManageImage.h"
static NSString *thumbnail = @"_thumbnail";
@implementation FLManageImage

+ (NSString *)getURLPathImage:(NSString*)nameImage folderID:(NSString*)folderID {
    NSString *folderPath = [self getPathWithFolder:folderID];
    NSString *getImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    NSURL *URL = [NSURL fileURLWithPath:getImagePath];
    NSString *stringURL = [URL absoluteString];
    return stringURL;
}

+ (NSString*)getURLPathThumbnailImage:(NSString *)nameImage folderID:(NSString *)folderID {
    NSString *folderPath = [self getPathWithFolder:folderID];
    NSString *stringThumbnail = [NSString stringWithFormat:@"%@%@", nameImage, thumbnail];
    NSString *getImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", stringThumbnail]];
    NSURL *URL = [NSURL fileURLWithPath:getImagePath];
    NSString *stringURL = [URL absoluteString];
    return stringURL;
}

+ (NSString*)getContentOfFilemage:(NSString*)nameImage folderID:(NSString*)folderID {
    NSString *folderPath = [self getPathWithFolder:folderID];
    NSString *getImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    return getImagePath;
}

+ (UIImage*)getImage:(NSString*)nameImage folderID:(NSString*)folderID{
    NSString *folderPath = [self getPathWithFolder:folderID];
    NSString *getImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

+ (void)saveImage:(UIImage*)image withName:(NSString*)nameImage folderUUID:(NSString *)folderUUID{
    NSString *folderPath = [self getPathWithFolder:folderUUID];
    NSString *savedImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    NSString *savedImageThumbnailPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [NSString stringWithFormat:@"%@%@", nameImage, thumbnail]]];
    UIImage *imageFull = [self fillImage:image];
    NSData *imageData = UIImagePNGRepresentation(imageFull);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    NSData *imageDataThumbnail = UIImageJPEGRepresentation(imageFull, 0.5f);
    [imageDataThumbnail writeToFile:savedImageThumbnailPath atomically:NO];
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

+(void)deleteImageWithName:(NSString*)nameImage folderUUID:(NSString*)folderUUID {
    NSString *folderPath = [self getPathWithFolder:folderUUID];
    NSString *imagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSError *error;
    [fileManage removeItemAtPath:imagePath error:&error];
}

+(void)deleteFolder:(NSString*)folderUUID {
    NSString *folderPath = [self getPathWithFolder:folderUUID];
    NSError *error = nil;
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error]) {
        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
    }
}

+(UIImage*)fillImage:(UIImage*)image{
    if(!(image.imageOrientation == UIImageOrientationUp ||
         image.imageOrientation == UIImageOrientationUpMirrored))
    {
        CGSize imgsize = image.size;
        UIGraphicsBeginImageContext(imgsize);
        [image drawInRect:CGRectMake(0.0, 0.0, imgsize.width, imgsize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}
@end
