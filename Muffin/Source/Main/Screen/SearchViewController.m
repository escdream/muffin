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
#import "ResourceManager.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUtil.h"
#import "SampleQueueId.h"
#import "HangulUtils.h"

@interface SearchViewController ()

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
    

    
    tblSearch.frame = _tabResult.frame;
    [_txtSearch addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

    tblResultHot.frame = [_tabResult getClientRect];
    tblResultNew.frame = [_tabResult getClientRect];
    tblResultAll.frame = [_tabResult getClientRect];
    btnPrevPlay = nil;
}

- (void) initData
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic = nil;
    
    if ([viewType isEqualToString: @"SearchMuffin"])
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
    else if ([viewType isEqualToString: @"MuffinProject"])
    {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        dic = nil;
        
//        dic[@"Function"] = @"";
//        dic[@"UserId"] = [UserInfo instance].userID;
        
//        [[EDHttpTransManager instance] callProjectInfo:@"" withBlack:^(id result, NSError * error)
        [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
         {
             if (result != nil)
             {
                 NSArray * arr = result;
                 [self->arrAll removeAllObjects];
                 [self->arrHot removeAllObjects];
                 [self->arrNew removeAllObjects];
                 
                 for (NSDictionary * dic in arr)
                 {
                     ProjectInfo * p = [[ProjectInfo alloc] initWithData:dic];
                     
                     [self->arrAll addObject:p];
                     [self->arrHot addObject:p];
                     [self->arrNew addObject:p];
                 }

                 [self->tblResultAll reloadData];
                 [self->tblResultHot reloadData];
                 [self->tblResultNew reloadData];
             }
             
         }];
    }
}

- (void)playMuffin:(UIButton*)sender
{
    mButton = sender;
    ([mButton.currentImage isEqual:[UIImage imageNamed:@"btn_s_play.png"]]);
    
    SongInfo * muffinInfo = arrHot[sender.tag - 1];
    if(muffinInfo != nil)
    {
        muffinInfo.bIsSelected = true;
        
        UIButton *btnPlay = (UIButton *)sender;
        if ([btnPlay.currentImage isEqual:[UIImage imageNamed:@"btn_s_play.png"]])
        {
            NSString* strFilePath = muffinInfo.musicPath;
            NSString* strFileID = muffinInfo.musicFileID;
            NSString* strMuffinURL = [strFilePath stringByAppendingString:strFileID];
            NSURL* url = [NSURL URLWithString:strMuffinURL];

            STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
            [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];

            UIImage *backButtonImage = [UIImage imageNamed:@"btn_on.png"];
            [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
            
            if (btnPrevPlay != btnPlay)
            {
                UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
                [btnPrevPlay setImage:backButtonImage forState:UIControlStateNormal];
            }
            btnPrevPlay = sender;
        }
        else
        {
            muffinInfo.bIsSelected = false;
            [self stopMuffin:btnPlay];
            btnPrevPlay = nil;
        }
    }
}

- (void)stopMuffin:(UIButton*)sender
{
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [sender setImage:backButtonImage forState:UIControlStateNormal];
    
    [[AudioUtil player] stop];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClose:(id)sender
{
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [((UIButton *)sender) setImage:backButtonImage forState:UIControlStateNormal];

    [[AudioUtil player] stop];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self initLayout];
    [self initData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated    {
    [[AudioUtil player] stop];
    [super viewWillDisappear:animated];
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
    
//    if (tableView == tblResultHot)
        return arrHot.count;
//    else if (tableView == tblResultNew)
//        return arrNew.count;
//    else
//        return arrAll.count;
//
//    return arrHot.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        if ([viewType isEqualToString: @"SearchMuffin"])
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    }
    
    if ([viewType isEqualToString: @"SearchMuffin"])
    {
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
        else
            muffinInfo = arrSearch[indexPath.row];

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
    else
    {
        ProjectInfo * p;
        if (tableView == tblResultHot)
        {
            p = arrHot[indexPath.row];
        }
        else if (tableView == tblResultNew)
        else if (tableView == tblResultHot)
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
}

@end
