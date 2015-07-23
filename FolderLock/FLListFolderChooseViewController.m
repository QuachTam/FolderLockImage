//
//  ListFolderChooseViewController.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "FLListFolderChooseViewController.h"
#import "FLListFolderTableViewCell.h"
#import "FLButtonHelper.h"
#import "chooseFolderService.h"

static NSString *chooseIdentifier = @"FLListFolderTableViewCell";

@interface FLListFolderChooseViewController ()
{
    NSIndexPath *lastIndexPath;
}
@property (nonatomic, strong) chooseFolderService *service;
@end

@implementation FLListFolderChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Choose Folder";
    // Do any additional setup after loading the view from its nib.[self setTitle:@"List Folder"];
    UIButton *cancelButton = fl_buttonCancel();
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIButton *saveButton = fl_buttonSave();
    [saveButton addTarget:self action:@selector(saveImageToFolder:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    [self registerTableViewCell];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)registerTableViewCell {
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLListFolderTableViewCell class]) bundle:nil] forCellReuseIdentifier:chooseIdentifier];
}

- (void)saveImageToFolder:(id)sender {
    if (!self.service) {
        self.service = [[chooseFolderService alloc] init];
    }
    if (lastIndexPath && self.image) {
        [self.service saveImageToFolder:[self.listFolder objectAtIndex:lastIndexPath.row] image:self.image success:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listFolder.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLListFolderTableViewCell *cell = [self.tbView dequeueReusableCellWithIdentifier:chooseIdentifier forIndexPath:indexPath];
    [cell setValueForCell:[self.listFolder objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger newRow = indexPath.row;
    NSInteger oldRow = (lastIndexPath != nil) ? lastIndexPath.row : -1;
    if(newRow != oldRow)
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = indexPath;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
