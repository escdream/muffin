//
//  SearchViewController.m
//  Muffin
//
//  Created by escdream on 2018. 9. 5..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "SearchViewController.h"
#import "CommonUtil.h"
#import "ProjectInfo.h"
#import "ProjectViewController.h"
#import "SongInfo.h"
#import "SongTableViewCell.h"
#import "ResourceManager.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUtil.h"
#import "SampleQueueId.h"
#import "HangulUtils.h"
#import "MFAudioPlayerController.h"
#import "Muffin-Swift.h"


@interface SearchViewController ()
{
    SongTableViewCell *playCell;
}

@end


@implementation SearchViewController
{
    UIButton * btnPrevPlay;
}
@synthesize viewType;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    NSLog(@"become first");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
}

- (void)textChanged:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    
    NSString * parameterStr=textField.text ;
    
    if([parameterStr isEqualToString:@""])
    {
        tblSearch.hidden = YES;
        [self->tblResultAll reloadData];
        [self->tblResultHot reloadData];
        [self->tblResultNew reloadData];
        [tblSearch removeFromSuperview];
    }
    else
    {
        tblSearch.hidden = NO;
        [_tabResult.superview addSubview:tblSearch];
        [self filteredText:parameterStr];
    }
}

- (void) filteredText:(NSString *) searchString
{
    [arrSearch removeAllObjects];
    
    NSInteger searchStringLen  = [searchString length];
    NSString *choSearchStr=@"";
    NSString *dupSearchBartext = [[HangulUtils GetInstance:NO] doubleChosungReplace:searchString];
    
    NSInteger dupSearchStringLen = [dupSearchBartext length];
    NSString *dupChoSearchStr=@"";
    
    for (SongInfo * muffin in self->arrAll)
    {
        NSString *name = muffin.songName;
        
        NSString *group = muffin.groupName;

        NSRange rangeName = [[name uppercaseString] rangeOfString:[searchString uppercaseString]];
        NSRange rangeCode = [[group uppercaseString] rangeOfString:[searchString uppercaseString]];
        
        if ([name length] <= searchStringLen) {
            choSearchStr = [NSString stringWithFormat:@"%@", name];
        } else {
            choSearchStr = [name substringToIndex:searchStringLen];
        }
        
        // 쌍자음 초성검색.
        if ([name length] <= dupSearchStringLen) {
            dupChoSearchStr = [NSString stringWithFormat:@"%@", name];
        } else {
            dupChoSearchStr = [name substringToIndex:dupSearchStringLen];
        }
        
        choSearchStr = [[HangulUtils GetInstance:NO] getChosungs:choSearchStr];
        
        if (rangeName.location != NSNotFound || rangeCode.location != NSNotFound ||
            [[searchString uppercaseString] isEqualToString:choSearchStr]  )//|| [dupSearchBartext isEqualToString:[[HangulUtils GetInstance:NO] getChosungs:dupChoSearchStr]])
        {
            [arrSearch addObject:muffin];
        }
    }
    
    [tblSearch reloadData];
    
}

- (void) initLayout
{
    self.title = @"Search";
    
    CGRect sr = [CommonUtil getWindowArea];
    
    CGRect r = _viewGanre.frame;
    r.origin.y = sr.size.height - r.size.height ;
    _viewGanre.frame = r;

    r = _viewTabs.frame;
    
    r.size.height = sr.size.height - (_viewGanre.frame.size.height) - r.origin.y - 40.0f;

    _viewTabs.frame = r;
    
    
    r = _tabResult.frame;
    
    r.size.height = _viewTabs.frame.size.height - _viewSearch.frame.size.height - 4.0f;
    _tabResult.frame = r;
    
//    [_tabResult addTab:@"Hot"];
    [_tabResult addTab:@"Hot" subView:tblResultHot];
    [_tabResult addTab:@"New" subView:tblResultNew];
    [_tabResult addTab:@"All" subView:tblResultAll];
    [_tabResult doTabClick: 0];

    
    tblSearch.frame = _tabResult.frame;
    [_txtSearch addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

    tblResultHot.frame = [_tabResult getClientRect];
    tblResultNew.frame = [_tabResult getClientRect];
    tblResultAll.frame = [_tabResult getClientRect];
    btnPrevPlay = nil;
    
    [_btnSearchCase1 setTitle:@"Ballard" forState:UIControlStateNormal];
    [_btnSearchCase2 setTitle:@"Dance" forState:UIControlStateNormal];
    [_btnSearchCase3 setTitle:@"Classic" forState:UIControlStateNormal];
    [_btnSearchCase4 setTitle:@"R&B" forState:UIControlStateNormal];
}

- (IBAction)onClickSearchCase1:(id)sender {
    _btnSearchCase1.selected = !_btnSearchCase1.selected;

    if(_btnSearchCase2.selected)
        _btnSearchCase2.selected = NO;
    if(_btnSearchCase3.selected)
        _btnSearchCase3.selected = NO;
    if(_btnSearchCase4.selected)
        _btnSearchCase4.selected = NO;
    
    NSString *tabTitle = [_tabResult currentTabTitle];
    if(_btnSearchCase1.selected){
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"01"];//Hot,01:발라드
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"01"];//New,01:발라드
        else
            [self doSearchMuffin:@"3" muffinKind:@"01"];//All,01:발라드
    }
    else {
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"99"];//Hot,99:전체
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"99"];//New,99:전체
        else
            [self doSearchMuffin:@"3" muffinKind:@"99"];//All,99:전체
    }
}

- (IBAction)onClickSearchCase2:(id)sender {
    _btnSearchCase2.selected = !_btnSearchCase2.selected;

    if(_btnSearchCase1.selected)
        _btnSearchCase1.selected = NO;
    if(_btnSearchCase3.selected)
        _btnSearchCase3.selected = NO;
    if(_btnSearchCase4.selected)
        _btnSearchCase4.selected = NO;

    NSString *tabTitle = [_tabResult currentTabTitle];
    if(_btnSearchCase2.selected){
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"02"];//Hot, 댄스
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"02"];//New, 댄스
        else
            [self doSearchMuffin:@"3" muffinKind:@"02"];//All, 댄스

    }
    else {
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"99"];//Hot,99:전체
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"99"];//New,99:전체
        else
            [self doSearchMuffin:@"3" muffinKind:@"99"];//All,99:전체
    }

}
- (IBAction)onClickSearchCase3:(id)sender {
    _btnSearchCase3.selected = !_btnSearchCase3.selected;
    
    if(_btnSearchCase1.selected)
        _btnSearchCase1.selected = NO;
    if(_btnSearchCase2.selected)
        _btnSearchCase2.selected = NO;
    if(_btnSearchCase4.selected)
        _btnSearchCase4.selected = NO;

    NSString *tabTitle = [_tabResult currentTabTitle];
    if(_btnSearchCase3.selected){
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"03"];//Hot, 클래식
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"03"];//New, 클래식
        else
            [self doSearchMuffin:@"3" muffinKind:@"03"];//All, 클래식
    }
    else {
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"99"];//Hot,99:전체
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"99"];//New,99:전체
        else
            [self doSearchMuffin:@"3" muffinKind:@"99"];//All,99:전체
    }
}
- (IBAction)onClickSearchCase4:(id)sender {
    _btnSearchCase4.selected = !_btnSearchCase4.selected;

    if(_btnSearchCase1.selected)
        _btnSearchCase1.selected = NO;
    if(_btnSearchCase2.selected)
        _btnSearchCase2.selected = NO;
    if(_btnSearchCase3.selected)
        _btnSearchCase3.selected = NO;

    NSString *tabTitle = [_tabResult currentTabTitle];
    if(_btnSearchCase4.selected){
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"04"];//Hot, R&B
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"04"];//New, R&B
        else
            [self doSearchMuffin:@"3" muffinKind:@"04"];//All, R&B
    }
    else {
        if ([tabTitle isEqualToString:@"Hot"] )
            [self doSearchMuffin:@"1" muffinKind:@"99"];//Hot,99:전체
        else if ([tabTitle isEqualToString:@"New"] )
            [self doSearchMuffin:@"2" muffinKind:@"99"];//New,99:전체
        else
            [self doSearchMuffin:@"3" muffinKind:@"99"];//All,99:전체
    }
}

- (void) initData
{
    /*
     type 1:HOT 2:NEW 3:ALL
     Kind  01:발라드 02:댄스 03:클래식 04:알앤비 05:락 06:레게 99:전체
     */
    if ([viewType isEqualToString: @"SearchMuffin"])
    {
        [self doSearchMuffin:@"1" muffinKind:@"99"];//HOT
        [self doSearchMuffin:@"2" muffinKind:@"99"];//NEW
        [self doSearchMuffin:@"3" muffinKind:@"99"];//ALL

    }
    else if ([viewType isEqualToString: @"MuffinProject"])
    {
        [self doSearchMuffinProject:@"1"];//HOT
//        [self doSearchMuffinProject:@"2"];//NEW
//        [self doSearchMuffinProject:@"3"];//ALL
    }

}

- (void)doSearchMuffin:(NSString *)sType muffinKind:(NSString*)sKind{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"SongInfo_SelectWhere";
    dic[@"Type"] = sType;
    dic[@"Kind"] = sKind;
 
    [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             
             if ([sType isEqualToString:@"1"]) {
                 [self->arrHot removeAllObjects];
             }
             else if ([sType isEqualToString:@"2"]) {
                 [self->arrNew removeAllObjects];
             }
             else if ([sType isEqualToString:@"3"]) {
                 [self->arrAll removeAllObjects];
             }

             for (NSDictionary * dic in arr)
             {
                 SongInfo * muffin = [[SongInfo alloc] initWithData:dic];
                 
                 if ([sType isEqualToString:@"1"]) {
                     [self->arrHot addObject:muffin];
                 }
                 else if ([sType isEqualToString:@"2"]) {
                     [self->arrNew addObject:muffin];
                 }
                 else if ([sType isEqualToString:@"3"]) {
                     [self->arrAll addObject:muffin];
                 }
             }
             
             [self->tblResultHot reloadData];
             [self->tblResultNew reloadData];
             [self->tblResultAll reloadData];
         }
     }];
}

- (void)doSearchMuffinProject:(NSString *)sType {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic = nil;
//    dic[@"Type"] = sType;
    
    [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
//             if ([sType isEqualToString:@"1"]) {
                 [self->arrHot removeAllObjects];
//             }
//             else if ([sType isEqualToString:@"2"]) {
                 [self->arrNew removeAllObjects];
//             }
//             else if ([sType isEqualToString:@"3"]) {
                 [self->arrAll removeAllObjects];
//             }

             for (NSDictionary * dic in arr)
             {
                 ProjectInfo * p = [[ProjectInfo alloc] initWithData:dic];
                 
                 if ([sType isEqualToString:@"1"]) {
                     [self->arrHot addObject:p];
                 }
                 else if ([sType isEqualToString:@"2"]) {
                     [self->arrNew addObject:p];
                 }
                 else if ([sType isEqualToString:@"3"]) {
                     [self->arrAll addObject:p];
                 }
             }

             [self->tblResultHot reloadData];
             [self->tblResultNew reloadData];
             [self->tblResultAll reloadData];
         }
         
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

    
    arrSearch = [[NSMutableArray alloc] init];
    tblSearch = [[UITableView alloc] init];

    tblSearch.delegate = self;
    tblSearch.dataSource = self;
    
    [[AudioUtil player] setDelegate:self];
    
    [self initLayout];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:animated];
}

/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState;
{
    NSLog(@"state = %d, previousState=%d ", state, previousState);
}
/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId;
{
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    
    NSLog(@"Started: %@", [queueId.url description]);
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId;
{
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    NSLog(@"didFinishBufferingSourceWithQueueItemId: %@", [queueId.url description]);
}
/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration;
{
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    NSLog(@"didFinishPlayingQueueItemId: %@", [queueId.url description]);
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode;
{
}
/// Raised when datasource read stream metadata
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didReadStreamMetadata:(NSDictionary*)dictionary;
{
    NSLog(@"didReadStream : %@", dictionary);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted
{
    if ([viewType isEqualToString: @"SearchMuffin"])
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
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblSearch)
        return arrSearch.count;
    
    if (tableView == tblResultHot)
        return arrHot.count;
    else if (tableView == tblResultNew)
        return arrNew.count;
    else
        return arrAll.count;

//    return arrHot.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        if ([viewType isEqualToString: @"SearchMuffin"])
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
            
            cell.showFavorite = NO;
            cell.showPlayer   = NO;
            
            cell.songInfo = muffinInfo;
            
            
            return cell;
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    }
    
    if ([viewType isEqualToString: @"SearchMuffin"])
    {
    }
    else
    {
        ProjectInfo * p;
        if (tableView == tblResultHot)
        {
            p = arrHot[indexPath.row];
        }
        else if (tableView == tblResultNew)
        {
            p = arrNew[indexPath.row];
        }
        else if (tableView == tblResultAll)
        {
            p = arrAll[indexPath.row];
        }
        else
        {
            p = arrSearch[indexPath.row];
            p = arrAll[indexPath.row];
        }

        
        if(p != nil)
        {
            //make TextLabel
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = RGB(33, 33, 33);

            cell.textLabel.text = p.projectName;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if ([viewType isEqualToString: @"SearchMuffin"])
    {
        return TABLE_HEADER_HEIGHT;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([viewType isEqualToString: @"MuffinProject"])
    {
        ProjectViewController * project;
        
        if (tableView == tblResultHot)
        {
            project = [[ProjectViewController alloc] initWithProject:arrHot[indexPath.row]];
        }
        else if (tableView == tblResultNew)
        {
            project = [[ProjectViewController alloc] initWithProject:arrNew[indexPath.row]];
        }
        else
        {
            project = [[ProjectViewController alloc] initWithProject:arrAll[indexPath.row]];
        }

        [self.navigationController pushViewController:project animated:YES];
    }
    else
    {
        SongInfo * songInfo = nil;
        NSArray * arrList = nil;
        
        if (tableView == tblResultHot)
            arrList = arrHot;
        else if (tableView == tblResultNew)
            arrList = arrNew;
        else
            arrList = arrAll;
        
        songInfo = arrList[indexPath.row];
        
        MFAudioPlayerController * player = [[MFAudioPlayerController alloc] initWithNibName:@"MFAudioPlayerController" bundle:nil];
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        
        [window.rootViewController presentViewController:player animated:YES completion:nil];
        player.songInfo = songInfo;
        [player setPlayList:arrList];
    }
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
@end
