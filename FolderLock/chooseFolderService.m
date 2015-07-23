//
//  chooseFolderService.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "chooseFolderService.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Folder.h"
#import "Photo.h"

@implementation chooseFolderService
- (void)saveImageToFolder:(FLFolderModel*)folderModel image:(UIImage *)image success:(void(^)(void))success {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid=%@", folderModel.uuid];
        Folder *folder = [Folder MR_findFirstWithPredicate:predicate inContext:localContext];
        Photo *photo = [Photo MR_createEntityInContext:localContext];
        photo.uuid = [[[NSUUID UUID] UUIDString] lowercaseString];
        photo.createDate = [NSDate date];
        [self saveImage:image withName:photo.uuid];
        [folder addPhotosObject:photo];
    }];
    if (success) {
        success();
    }
}

- (UIImage*)getImage:(NSString*)nameImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

- (void)saveImage:(UIImage*)image withName:(NSString*)nameImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameImage]];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
}
@end
