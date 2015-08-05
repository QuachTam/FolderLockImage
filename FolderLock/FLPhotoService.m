//
//  FLPhotoService.m
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLPhotoService.h"
#import <MagicalRecord/MagicalRecord.h>
#import "FLPhotoModel.h"
#import "FLFolderModel.h"
#import "FLManageImage.h"

@interface FLPhotoService ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation FLPhotoService

- (void)saveImageToFolder:(FLFolderModel*)folderModel image:(NSArray *)ListImage success:(void(^)(void))success {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Folder *folder = [Folder entityWithUuid:folderModel.uuid inContext:localContext];
        for (NSInteger index=0; index<ListImage.count; index++) {
            Photo *photo = [Photo entityWithUuid:[[[NSUUID UUID] UUIDString] lowercaseString] inContext:localContext];
            photo.url = photo.uuid;
            UIImage *image = [ListImage objectAtIndex:index];
            [FLManageImage saveImage:image withName:photo.uuid folderUUID:folder.uuid];
            [folder addPhotosObject:photo];
        }
    }];
    if (success) {
        success();
    }
}

- (void)deleteImageInFolder:(FLFolderModel*)folderModel photoMode:(FLPhotoModel*)photoModel success:(void(^)(void))success{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Folder *folder = [Folder entityWithUuid:folderModel.uuid inContext:localContext];
        Photo *photo = [Photo entityWithUuid:photoModel.uuid inContext:localContext];
        [FLManageImage deleteImageWithName:photo.uuid folderUUID:folder.uuid];
        [photo MR_deleteEntityInContext:localContext];
    }];
    if (success) {
        success();
    }
}
@end
