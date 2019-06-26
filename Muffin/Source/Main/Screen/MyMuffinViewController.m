//
//  MyMuffinViewController.m
//  Muffin
//
//  Created by escdream on 16/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MyMuffinViewController.h"
#import "SongInfo.h"
#import "SongTableViewCell.h"
#import "ResourceManager.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUtil.h"


@interface MyMuffinViewController ()
{
    NSMutableArray * arrMuffin;
    UIButton * mButton;
    SongTableViewCell *playCell;
}

@end

@implementation MyMuffinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrMuffin = [[NSMutableArray alloc] init];
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

- (void) initData
{
    //북마크머핀 조회
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"BookMarkMuffin_Select";
    dic[@"UserId"] = [UserInfo instance].userID;
    
    [[EDHttpTransManager instance] callBookmarkMuffinInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             [self->arrMuffin removeAllObjects];

             for (NSDictionary * dic in arr)
             {
                 SongInfo * muffin = [[SongInfo alloc] initWithData:dic];
                 
                 [self->arrMuffin addObject:muffin];
             }
             
             [_tblMuffin reloadData];
         }
     }];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
            lb.text = @"Muffin List";
        }
        
        return view;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMuffin.count;
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
    muffinInfo = arrMuffin[indexPath.row];
    
    //북마크 버튼 숨기기
    cell.showFavorite = NO;
    
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return TABLE_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_ROW_HEIGHT;
}

- (void)playMuffin:(UIButton*)sender
{

}

- (void)stopMuffin:(UIButton*)sender
{
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [sender setImage:backButtonImage forState:UIControlStateNormal];
    
    [[AudioUtil player] stop];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

@end
