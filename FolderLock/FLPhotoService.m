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

@interface FLPhotoService ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation FLPhotoService
- (instancetype)init{
    self = [super init];
    if (self) {
        self.listPhotoModel = [[NSArray alloc] init];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    return _managedObjectContext;
}

- (void)fetchDatabase {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid"];
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Folder"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
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
        FLPhotoModel *model = [[FLPhotoModel alloc] initWithPhotoEntity:[listFolder objectAtIndex:index]];
        [listFolderModel addObject:model];
    }
    self.listPhotoModel = listFolderModel;
    if (self.didFinishFetchResults) {
        self.didFinishFetchResults();
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:self.listPhotoModel];
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            FLPhotoModel *model = [[FLPhotoModel alloc] initWithPhotoEntity:anObject];
            [arrayTemp addObject:model];
            self.listPhotoModel = [self sortArray:arrayTemp];
            
            NSInteger currentIndex = [self profileWithIndexPath:model.uuid];
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
            if (self.resultsChangeInsert) {
                self.resultsChangeInsert([NSArray arrayWithObject:currentIndexPath]);
            }
            break;
        }
        case NSFetchedResultsChangeDelete: {
            NSInteger index = [self profileWithIndexPath:[anObject valueForKey:@"uuid"]];
            if (index>=0) {
                NSIndexPath *indexPathCurrent = [NSIndexPath indexPathForRow:index inSection:0];
                [arrayTemp removeObjectAtIndex:index];
                self.listPhotoModel = [self sortArray:arrayTemp];
                if (self.resultsChangeDelete) {
                    self.resultsChangeDelete([NSArray arrayWithObject:indexPathCurrent]);
                }
            }
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            NSInteger index = [self profileWithIndexPath:[anObject valueForKey:@"uuid"]];
            if (index>=0) {
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                if (self.resultsChangeUpdate) {
                    self.resultsChangeUpdate([NSArray arrayWithObject:currentIndexPath]);
                }
            }
            break;
        }
        case NSFetchedResultsChangeMove: {
            if (self.resultsChangeDelete) {
                self.resultsChangeDelete([NSArray arrayWithObject:indexPath]);
            }
            if (self.resultsChangeInsert) {
                self.resultsChangeInsert([NSArray arrayWithObject:newIndexPath]);
            }
            break;
        }
    }
}

- (NSArray *)sortArray:(NSArray *)array {
    NSSortDescriptor *ruleSort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:YES];
    NSArray *arrSortDescriptor = [NSArray arrayWithObject:ruleSort];
    NSArray *arrSorted = [array sortedArrayUsingDescriptors:arrSortDescriptor];
    return arrSorted;
}

- (NSInteger)profileWithIndexPath:(NSString *)folderUUID {
    NSInteger currentIndex = -1;
    for (NSInteger index=0; index<self.listPhotoModel.count; index++) {
        FLPhotoModel *folderModel = [self.listPhotoModel objectAtIndex:index];
        if ([folderModel.uuid isEqualToString:folderUUID]) {
            currentIndex = index;
            break;
        }
    }
    return currentIndex;
}

@end
