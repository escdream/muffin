//
//  MainHomeViewController.m
//  Muffin
//
//  Created by JoonHo Kang on 26/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MainHomeViewController.h"
#import "LoginViewController.h"
#import "CommonUtil.h"
#import "ProjectInfo.h"
#import "SongInfo.h"
#import "SongTableViewCell.h"

@interface MainHomeViewController ()
{
    SongTableViewCell *playCell;
}

@end

@implementation MainHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    m_keyboardManager = [[KeyboardManager alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view from its nib.
    
    tblResultHot = [[UITableView alloc] init];
    tblResultNew = [[UITableView alloc] init];
    tblResultAll = [[UITableView alloc] init];
    
    tblResultHot.delegate = self;
    tblResultNew.delegate = self;
    tblResultAll.delegate = self;
    
    tblResultHot.dataSource = self;
    tblResultNew.dataSource = self;
    tblResultAll.dataSource = self;
    
    arrHot = [[NSMutableArray alloc] init];
    arrNew = [[NSMutableArray alloc] init];
    arrAll = [[NSMutableArray alloc] init];
    
    // not login info
    if (![[UserInfo instance] isUserLogin])
    {
        [LoginViewController ShowLoginView:@"" animated:NO];
    }
    
    [self initLayout];
    [self initData];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) initLayout
{
    [_tabResult addTab:@"Hot" subView:tblResultHot];
    [_tabResult addTab:@"New" subView:tblResultNew];
    [_tabResult addTab:@"All" subView:tblResultAll];
    
    
    tblResultHot.frame = [_tabResult getClientRect];
    tblResultNew.frame = [_tabResult getClientRect];
    tblResultAll.frame = [_tabResult getClientRect];

}

- (void) initData
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic = nil;

//    if ([viewType isEqualToString: @"SearchMuffin"])
    {
        [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
         {
             if (result != nil)
             {
                 NSArray * arr = result;
                 [self->arrAll removeAllObjects];
                 [self->arrHot removeAllObjects];
                 [self->arrNew removeAllObjects];

                 for (NSDictionary * dic in arr)
                 {
                     SongInfo * muffin = [[SongInfo alloc] initWithData:dic];

                     [self->arrAll addObject:muffin];
                     [self->arrHot addObject:muffin];
                     [self->arrNew addObject:muffin];
                 }

                 [self->tblResultAll reloadData];
                 [self->tblResultHot reloadData];
                 [self->tblResultNew reloadData];
             }
         }];
    }
////    else if ([viewType isEqualToString: @"MuffinProject"])
//    {
//        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//        dic = nil;
//        [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
//         {
//             if (result != nil)
//             {
//                 NSArray * arr = result;
//                 [self->arrAll removeAllObjects];
//                 [self->arrHot removeAllObjects];
//                 [self->arrNew removeAllObjects];
//
//                 for (NSDictionary * dic in arr)
//                 {
//                     ProjectInfo * p = [[ProjectInfo alloc] initWithData:dic];
//
//                     [self->arrAll addObject:p];
//                     [self->arrHot addObject:p];
//                     [self->arrNew addObject:p];
//                 }
//
//                 [self->tblResultAll reloadData];
//                 [self->tblResultHot reloadData];
//                 [self->tblResultNew reloadData];
//             }
//         }];
//    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //    if (tableView == tblResultHot)
    return arrHot.count;
    //    else if (tableView == tblResultNew)
    //        return arrNew.count;
    //    else
    //        return arrAll.count;
    //
    //    return arrHot.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"song_cell"];
    
    if (cell == nil)
    {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"song_cell"];
        cell.delegate = (id)self;
    }
    
    SongInfo * muffinInfo;
    
    if (tableView == tblResultHot)
    {
        muffinInfo = arrHot[indexPath.row];
    }
    else if (tableView == tblResultNew)
    {
        muffinInfo = arrNew[indexPath.row];
    }
    else if (tableView == tblResultAll)
    {
        muffinInfo = arrAll[indexPath.row];
    }

    cell.showFavorite = (indexPath.row % 2) == 0;

    
    cell.songInfo = muffinInfo;

    
    return cell;
}


- (void) onSongPlayInfo:(SongTableViewCell *)cell songInfo:(SongInfo *) songInfo isPlaying:(BOOL) isPlaying;
{
    if (isPlaying)
    {
        if (playCell != cell)
        {
            if (playCell != nil)
                [playCell stopSong];
            
            playCell = cell;
            [playCell performSelector:@selector(playSong) withObject:nil afterDelay:0.3f];
        }
        else
        {
            [playCell playSong];
        }
    }
    else
    {
        [playCell stopSong];
        playCell = nil;
    }
}

- (void) onRefresh;
{
    [self initData];
}

@end
