//
//  UserListViewController.m
//  Muffin
//
//  Created by escdream on 2018. 8. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "UserListViewController.h"

@interface UserListViewController ()
{
    NSMutableArray * arrData;
}
@end

@implementation UserListViewController

- (void) initData
{
    [[EDHttpTransManager instance] callLoginInfo:@"" withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             if (self->arrData != nil) [self->arrData removeAllObjects];
             
             self->arrData = [[NSMutableArray alloc] initWithArray:result];
             
             [self.tblUserList reloadData];
         }
         
     }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"사용자 리스트";
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self initData];
    
    // Do any additional setup after loading the view from its nib.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary * dic = self->arrData[indexPath.row];
    
    cell.textLabel.text = dic[@"UserId"];
    
    return cell;
}

@end
