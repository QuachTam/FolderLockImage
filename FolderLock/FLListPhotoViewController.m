//
//  FLListPhotoViewController.m
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLListPhotoViewController.h"
#import "FLListFolderTableViewCell.h"

static NSString *customListPhotoCell = @"FLListFolderTableViewCell";

@interface FLListPhotoViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *listPhotoModel;
@end

@implementation FLListPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listPhotoModel = [[NSMutableArray alloc] init];
    [self registerTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerTableViewCell {
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLListFolderTableViewCell class]) bundle:nil] forCellReuseIdentifier:customListPhotoCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listPhotoModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLListFolderTableViewCell *cell = [self.tbView dequeueReusableCellWithIdentifier:customListPhotoCell forIndexPath:indexPath];
    cell.leftUtilityButtons = [self leftButtons];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            break;
        }
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
}


- (NSArray *)leftButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:_LSFromTable(@"title.strings.edit", @"FLFolderListViewController", @"Edit")];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:_LSFromTable(@"title.strings.delete", @"FLFolderListViewController", @"Delete")];
    
    return rightUtilityButtons;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
