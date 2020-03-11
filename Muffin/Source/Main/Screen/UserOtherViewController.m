//
//  UserOtherViewController.m
//  Muffin
//
//  Created by escdream on 2018. 11. 10..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "UserOtherViewController.h"
#import "ProjectViewController.h"

#import "ProjectInfo.h"
#import "BookMarkUser.h"
#import "ResourceManager.h"
#import "CommonUtil.h"
#import "SystemUtil.h"
#import "UIView+FirstResponder.h"

#define TABLE_ROW_HEIGHT_PROJECT 60

@interface UserOtherViewController ()
{
    NSMutableArray * arrProject;
}
@end

@implementation UserOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrProject = [[NSMutableArray alloc] init];
    
    
    _viewRound1.radius = _viewRound1.frame.size.height / 2;
    _viewRound2.radius = _viewRound1.frame.size.height / 2;
    _viewRound3.radius = _viewRound1.frame.size.height / 2;
    
    [self initTopData];
    [self initData];
    [self initUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithProject:(ProjectInfo *) aProject
{
    self = [super initWithNibName:@"UserOtherViewController" bundle:nil];
    if (self)
    {
        self.project = aProject;
    }
    
    return self;
}


- (id) initWithBMUser:(BookmarkUser *) aBMUser
{
    self = [super initWithNibName:@"UserOtherViewController" bundle:nil];
    if (self)
    {
        self.BMUser = aBMUser;
    }
    
    return self;
}

- (void) initTopData
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"Function"] = @"GroupInfo_SelectSum";
    dic[@"UserId"] = self.BMUser.BMUserId;
    dic[@"Total"] = @"";
    dic[@"PIng"] = @"";
    dic[@"PEnd"] = @"";
    
    [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             if (arr.count >= 1)
             {
                 self.lbTotal.text = arr[0][@"TOTAL"];
                 self.lbWorking.text = arr[0][@"PING"];
                 self.lbComplete.text = arr[0][@"PEND"];
             }
             else
             {
                 self.lbTotal.text = @"0";
                 self.lbWorking.text = @"0";
                 self.lbComplete.text = @"0";
             }
         }
     }];
}


- (void) initData
{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"Function"] = @"GroupInfo_SelectUser";
    dic[@"UserId"] = self.BMUser.BMUserId;
    
    [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             [self->arrProject removeAllObjects];
             for (NSDictionary * dic in arr)
             {
                 ProjectInfo * p = [[ProjectInfo alloc] initWithData:dic];
                 
                 [self->arrProject addObject:p];
                 
                 [self.self.tblProjectList reloadData];
             }
             
         }
         
     }];
}

- (void) initUserData
{
    _lbUserId.text = self.BMUser.BMUserId;
    //    _lbUserId.text = [UserInfo instance].userID;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrProject.count;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_ROW_HEIGHT;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = RGB(33, 33, 33);
    cell.textLabel.text = @"text";
    
    ProjectInfo * p = arrProject[indexPath.row] ;
    cell.textLabel.text = p.projectName;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectViewController * project = [[ProjectViewController alloc] initWithProject:arrProject[indexPath.row]];
    
    [self.navigationController pushViewController:project animated:YES];
}

@end
