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
#import "FLPhotoModel.h"

@interface chooseFolderService ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation chooseFolderService

- (instancetype)init{
    self = [super init];
    if (self) {
        self.listModelFolder = [[NSArray alloc] init];
    }
    return self;
}

- (void)saveImageToFolder:(FLFolderModel*)folderModel image:(UIImage *)image success:(void(^)(void))success {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Folder *folder = [Folder entityWithUuid:folderModel.uuid inContext:localContext];
        Photo *photo = [Photo entityWithUuid:[[[NSUUID UUID] UUIDString] lowercaseString] inContext:localContext];
        photo.createDate = [NSDate date];
        photo.url = photo.uuid;
        [FLManageImage saveImage:image withName:photo.uuid folderUUID:folder.uuid];
        [folder addPhotosObject:photo];
    }];
    if (success) {
        success();
    }
}

- (void)saveMoveImageToFolder:(FLFolderModel*)folderModel photoModel:(FLPhotoModel*)photoModel success:(void(^)(void))success {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Folder *folder = [Folder entityWithUuid:folderModel.uuid inContext:localContext];
        Photo *photo = [Photo entityWithUuid:photoModel.uuid inContext:localContext];
        
        Folder *folderOld = photo.folder;
        UIImage *imagePhoto = [FLManageImage getImage:photo.uuid folderID:folderOld.uuid];
        [folderOld removePhotosObject:photo];
        
        [FLManageImage saveImage:imagePhoto withName:photo.uuid folderUUID:folder.uuid];
        [FLManageImage deleteImageWithName:photo.uuid folderUUID:folderOld.uuid];
        
        [folder addPhotosObject:photo];
    }];
    if (success) {
        success();
    }
}

- (void)fetchDatabase {
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Folder"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    NSArray *listFolder = [self.fetchedResultsController fetchedObjects];
    NSMutableArray *listFolderModel = [[NSMutableArray alloc] init];
    for (NSInteger index=0; index<listFolder.count; index++) {
        FLFolderModel *model = [[FLFolderModel alloc] initWithFolderEntity:[listFolder objectAtIndex:index]];
        [listFolderModel addObject:model];
    }
    self.listModelFolder = listFolderModel;
    if (self.didFinishFetchResults) {
        self.didFinishFetchResults();
    }
}

-(NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    return _managedObjectContext;
}
@end
