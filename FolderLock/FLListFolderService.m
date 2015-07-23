//
//  ListFolderService.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "FLListFolderService.h"
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
#import "FLFolderModel.h"
#import "Folder.h"

@interface FLListFolderService ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation FLListFolderService

- (instancetype)init{
    self = [super init];
    if (self) {
        self.listModelFolder = [[NSArray alloc] init];
    }
    return self;
}

-(NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    return _managedObjectContext;
}

- (void)fetchDatabase {
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
        FLFolderModel *model = [[FLFolderModel alloc] initWithFolderEntity:[listFolder objectAtIndex:index]];
        [listFolderModel addObject:model];
    }
    self.listModelFolder = listFolderModel;
    if (self.didFinishFetchResults) {
        self.didFinishFetchResults();
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:self.listModelFolder];
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            FLFolderModel *model = [[FLFolderModel alloc] initWithFolderEntity:anObject];
            [arrayTemp addObject:model];
            self.listModelFolder = [self sortArray:arrayTemp];
            
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
                self.listModelFolder = [self sortArray:arrayTemp];
                if (self.resultsChangeDelete) {
                    self.resultsChangeDelete([NSArray arrayWithObject:indexPathCurrent]);
                }
            }
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            if (self.resultsChangeUpdate) {
                self.resultsChangeUpdate([NSArray arrayWithObject:indexPath]);
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
    NSSortDescriptor *ruleSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:YES];
    NSArray *arrSortDescriptor = [NSArray arrayWithObject:ruleSort];
    NSArray *arrSorted = [array sortedArrayUsingDescriptors:arrSortDescriptor];
    return arrSorted;
}

- (NSInteger)profileWithIndexPath:(NSString *)folderUUID {
    NSInteger currentIndex = -1;
    for (NSInteger index=0; index<self.listModelFolder.count; index++) {
        FLFolderModel *folderModel = [self.listModelFolder objectAtIndex:index];
        if ([folderModel.uuid isEqualToString:folderUUID]) {
            currentIndex = index;
            break;
        }
    }
    return currentIndex;
}

- (void)deleteFolder:(FLFolderModel*)folderModel{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid=%@", folderModel.uuid];
        Folder *folder = [Folder MR_findFirstWithPredicate:predicate inContext:localContext];
        [folder MR_deleteEntityInContext:localContext];
    }];
}
@end
