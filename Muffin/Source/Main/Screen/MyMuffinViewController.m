//
//  MyMuffinViewController.m
//  Muffin
//
//  Created by escdream on 16/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MyMuffinViewController.h"
#import "SongInfo.h"
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
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic = nil;
    
    [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    {
        SongInfo * muffinInfo;
        

        muffinInfo = arrMuffin[indexPath.row];
        
        if (muffinInfo != nil)
        {
            //make TextLabel
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:10];
            cell.textLabel.textColor = [UIColor purpleColor]; //RGB(33, 33, 33);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = [UIColor blackColor]; //RGB(33, 33, 33);
            
            //make PlayButton
            UIButton * btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
            btnPlay.frame = CGRectMake(10, 0, 60, 40);
            btnPlay.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
            
            UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
            [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
            [btnPlay addTarget:self action:@selector(playMuffin:) forControlEvents:UIControlEventTouchUpInside];//
            btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btnPlay.tag = [muffinInfo.songID intValue];
            
            mButton = btnPlay;
            cell.accessoryView = btnPlay;
            cell.textLabel.text = muffinInfo.groupName;
            cell.detailTextLabel.text = muffinInfo.songName;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
