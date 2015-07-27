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
#import "FLManageImage.h"

@implementation chooseFolderService
- (void)saveImageToFolder:(FLFolderModel*)folderModel image:(UIImage *)image success:(void(^)(void))success {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid=%@", folderModel.uuid];
        Folder *folder = [Folder MR_findFirstWithPredicate:predicate inContext:localContext];
        Photo *photo = [Photo MR_createEntityInContext:localContext];
        photo.uuid = [[[NSUUID UUID] UUIDString] lowercaseString];
        photo.createDate = [NSDate date];
        photo.url = photo.uuid;
        [FLManageImage saveImage:image withName:photo.uuid folderUUID:folder.uuid];
        [folder addPhotosObject:photo];
    }];
    if (success) {
        success();
    }
}



@end
