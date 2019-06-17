//
//  MainScreenViewController.m
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "MainScreenViewController.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "ResourceManager.h"
#import "ProjectInfo.h"
#import "BookMarkUser.h"
#import "GroupInfo.h"
#import "GroupItem.h"
#import "ProjectViewController.h"
#import "SystemUtil.h"
#import "CommonUtil.h"
#import "AudioPlayerViewController.h"
#import "SearchViewController.h"
#import "StartupPopupView.h"

#import "UserOtherViewController.h"
#import "BannerViewController.h"
#import "TagCollectonViewController.h"



@interface MainScreenViewController ()
{
    NSMutableArray * arrMakeList;
    NSMutableArray * arrArtistsList;
}


@end

@implementation MainScreenViewController

- (void) initLayout
{
    
//    CGRect ar = [CommonUtil getWindowArea];
//    
//    
//    CGRect r = _viewUserInfo.frame;
//    r.origin.y += ar.origin.y;
//    _viewUserInfo.frame = r;
//    
//    r = _tblInfoList.frame;
//    r.origin.y += ar.origin.y;
//    
//    if ([[SystemUtil instance] isIPhoneX])
//        r.size.height += 100;
//
//    
//    _tblInfoList.frame = r;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self initUserData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    m_keyboardManager = [[KeyboardManager alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self initLayout];

    // not login info
    if (![[UserInfo instance] isUserLogin])
    {
        [LoginViewController ShowLoginView:@"" animated:NO];
    }
    
//    [self initUserData];
    
    
//    [_viewTabs addTab:@"test1"];
//    [_viewTabs addTab:@"test2"];
//    [_viewTabs addTab:@"test3"];
//
//    UIView * v = (UIView *)(_viewTabs.tabViewList[0]);
//
//    _tblInfoList.frame = v.bounds;
//
//    [v addSubview:_tblInfoList];
//
}



- (void) initUserData
{
    // MakeList ------------------------------------
    arrMakeList = [[NSMutableArray alloc] init];
    
    // ArtistList ------------------------------------
    arrArtistsList = [[NSMutableArray alloc] init];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    dic[@"Function"] = @"GroupInfo_SelectUser";
    dic[@"UserId"] = [UserInfo instance].userID;
    [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             [self->arrMakeList removeAllObjects];
             for (NSDictionary * dic in arr)
             {
                 ProjectInfo * p = [[ProjectInfo alloc] initWithData:dic];
                 
                 [self->arrMakeList addObject:p];
                 
                 [self.tblInfoList reloadData];
             }
         }
         
     }];
    


    dic[@"Function"] = @"BookMarkUser_Select";
    dic[@"UserId"] = [UserInfo instance].userID;
    [[EDHttpTransManager instance] callBookmarkUserInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray *arr = result;
             [self->arrArtistsList removeAllObjects];
             for (NSDictionary * dic in arr)
             {
                 BookmarkUser * BMUser = [[BookmarkUser alloc] initWithData:dic];

                 [self->arrArtistsList addObject:BMUser];

                 [self.tblInfoList reloadData];
             }
         }
     }];
    
    _lbID.text = [UserInfo instance].userID;
    _lbPoint.text = [[NSString stringWithFormat:@"%d", [UserInfo instance].muffinPoint] decimalString];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return arrMakeList.count;
    else if (section == 1)
        return arrArtistsList.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = RGB(33, 33, 33);
    cell.textLabel.text = @"text";
    
    if (indexPath.section == 0)
    {
        ProjectInfo * p = arrMakeList[indexPath.row] ;
        cell.textLabel.text = p.projectName;
    }
    else if (indexPath.section == 1)
    {
        if (arrArtistsList.count != 0)
        {
            BookmarkUser * BMUser = arrArtistsList[indexPath.row];
            if (BMUser.BMUserId != nil)
            {
                cell.textLabel.text = BMUser.BMUserId;
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return TABLE_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted
{
    UIView * view = [[UIView  alloc] init];
    
    view.frame = CGRectMake(0, 0, tableView.frame.size.width, TABLE_HEADER_HEIGHT);
    
    view.backgroundColor = [UIColor whiteColor];
    UILabel * lb = [[UILabel alloc] initWithFrame:view.bounds];
    
    lb.font = [[ResourceManager sharedManager] getFontBoldWithSize:18.f];
    
    CGRect r = lb.frame;
    
    r.origin.x = 10;
    r.size.width -= 10;
    
    lb.frame = r;
    lb.textColor = RGB(33, 33, 33);
    
    [view addSubview:lb];
    if (section == 0)
    {
        lb.text = @"My Making List";
        
    }
    else if (section == 1)
    {
        lb.text = @"My Artists List";
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 1)];
        line.backgroundColor = [UIColor grayColor];
        [view addSubview:line];
    }

    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        ProjectViewController * project = [[ProjectViewController alloc] initWithProject:arrMakeList[indexPath.row]];
        
        [self.navigationController pushViewController:project animated:YES];
        
    }
    else if (indexPath.section == 1)
    {

        UserOtherViewController * BMUser = [[UserOtherViewController alloc] initWithBMUser:arrArtistsList[indexPath.row]];
        
        [self.navigationController pushViewController:BMUser animated:YES];

    }
}

- (IBAction)onLoginClcik:(id)sender {
    [LoginViewController ShowLoginView:@"" animated:YES];
}

- (IBAction)onPlayView:(id)sender {
     
    AudioPlayerViewController * controler = [[AudioPlayerViewController alloc] initWithNibName:@"AudioPlayerViewController" bundle:nil];
    
    [self presentViewController:controler animated:YES completion:nil];
}

- (IBAction)onSearchView:(id)sender {
    BannerViewController * controler = [[BannerViewController alloc] initWithNibName:@"BannerViewController" bundle:nil];
//    UserOtherViewController * controler = [[UserOtherViewController alloc] initWithNibName:@"UserOtherViewController" bundle:nil];
//    TagCollectonViewController * controler = [[TagCollectonViewController alloc] initWithNibName:@"TagCollectonViewController" bundle:nil];


    [self.navigationController pushViewController:controler animated:YES];
}

@end
