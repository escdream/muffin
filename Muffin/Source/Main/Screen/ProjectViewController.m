//
//  ProjectViewController.m
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "FileUploadViewController.h"
#import "ProjectViewController.h"
#import "ProjectInfo.h"
#import "ResourceManager.h"
#import "CommonUtil.h"
#import "SystemUtil.h"
#import "EDBottomButtonView.h"
#import "FileUploadViewController.h"

#import "UIView+FirstResponder.h"

#import "SongInfo.h"
#import "PartAskInfo.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUtil.h"
#import "SampleQueueId.h"
#import "FTPFileUploder.h"
#import "UIView+Toast.h"

#define TABLE_ROW_HEIGHT_ARTISTS  45
#define TABLE_ROW_HEIGHT_TIMELINE  60

@interface ProjectViewController ()
{
    int m_selectIndex;
    
    UITableView * tblList;
    
    NSMutableArray * arrArtists;
    NSMutableArray * arrTimeline;
    NSMutableArray * arrGroupItem;
    NSMutableArray * arrSongInfo;

    NSMutableArray * arrPartAsk;

    UIImageView *maskPrjImage;
    
    NSString *strStatus;
    
    NSMutableArray * arrFiles;
    FTPFileUploder * uploader;
    
    UIButton * btnPrevPlay;
}

@end

@implementation ProjectViewController

@synthesize viewTabList, activityIndicator;


- (void) initIndicator
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];

    [activityIndicator setCenter:self.view.center];
    [self.view addSubview : activityIndicator];
}

- (void) initData
{
    btnPrevPlay = nil;
    strStatus = @"전체PJT";
    
    //그룹이미지 읽어오기
    [self doGroupImage];
    //타임라인 리스트 조회
    [self doTimeLineList];
    //아티스트 리스트 조회
    [self doArtistList];


    // 프로젝트 그룹 소속 여부 얻어오기(프로젝트 그룹정보)
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"GroupItem_Select";
    dic[@"GroupId"] = self.project.projectID;
    dic[@"UserId"] = [UserInfo instance].userID;

    [[EDHttpTransManager instance] callGroupItemInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             if (self->arrGroupItem != nil) [self->arrGroupItem removeAllObjects];
         
             self->arrGroupItem = [[NSMutableArray alloc] initWithArray:result];
             
             if (self->arrGroupItem.count != 0)
             {
                 NSDictionary * dic = self->arrGroupItem[0];
                 if (dic != nil)
                 {
                     NSString * strAdmin = [NSString stringWithFormat:@"%@", dic[@"Admin"]];
                     //관리자
                     if ([strAdmin isEqualToString: @"Y"])
                     {
                         //신청리스트 조회
                         NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                         
                         dic[@"Function"] = @"PartAsk_Select";
                         dic[@"GroupId"] = self.project.projectID;
                         
                         [[EDHttpTransManager instance] callPartAskInfo:dic withBlack:^(id result, NSError * error)
                          {
                              if (result != nil)
                              {
                                  if (self->arrPartAsk != nil) [self->arrPartAsk removeAllObjects];
                                  
                                  self->arrPartAsk = [[NSMutableArray alloc] initWithArray:result];
                                  if (self->arrPartAsk.count != 0)
                                  {
                                      NSDictionary * dic = self->arrPartAsk[0];
                                      if (dic != nil)
                                      {
                                          //신청메시지
                                          PartAskInfo * partAskInfo = [[PartAskInfo alloc] init];
                                          
                                          partAskInfo.groupID = dic[@"GroupId"];
                                          partAskInfo.userID = dic[@"UserId"];
                                          partAskInfo.reqMessage = dic[@"ReqMessage"];
                                          partAskInfo.resMessage = dic[@"ResMessage"];
                                          partAskInfo.progress = dic[@"Progress"];
                                          partAskInfo.askType = dic[@"AskType"];
                                          partAskInfo.fileName = dic[@"FileName"];
                                          partAskInfo.filePath = dic[@"FilePath"];
                                          
                                          self.fldPartAskContents.editable = false;
                                          self.fldPartAskFileName.enabled = false;
                                          self.btnJoin1.enabled = false;
                                          self.btnJoin2.enabled = false;
                                          
                                          [self.fldPartAskContents setText: partAskInfo.reqMessage];
                                          
                                          //음원
                                          if ([partAskInfo.askType isEqualToString: @"01"])
                                          {
                                              self.btnJoin1.enabled = true;
                                              [self.btnJoin1 setSelected: true];
                                          }
                                          //가사
                                          else
                                          {
                                              self.btnJoin2.enabled = true;
                                              [self.btnJoin2 setSelected: true];
                                          }
                                          
                                          [self.fldPartAskFileName setText: partAskInfo.fileName];
                                      }
                                  }
                                  else
                                  {
                                      //신청리스트가 없는 경우.. 머핀리스트 표시
                                      [self.viewTabList removeTab:2];
                                      [self.viewTabList addTab:@"List" subView:self.viewJoinList];
                                      [self.viewTabList changeTab:@"List" nIndex:2];
                                      
                                      self->arrPartAsk = nil;
                                      self->arrPartAsk = [[NSMutableArray alloc] init];
                                      
                                      
                                      NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                                      
                                      dic[@"Function"] = @"SongInfo_SelectGroup";
                                      dic[@"GroupId"] = self.project.projectID;
                                      
                                      [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
                                       {
                                           if (result != nil)
                                           {
                                               NSArray * arr = result;
                                               [self->arrPartAsk removeAllObjects];
                                               
                                               for (NSDictionary * dic in arr)
                                               {
                                                   SongInfo * muffin = [[SongInfo alloc] initWithData:dic];
                                                   
                                                   [self->arrPartAsk addObject:muffin];
                                               }
                                               [self.tblJoinList reloadData];
                                           }
                                       }];
                                  }
                              }
                          }];
                         
                         [self.btmViewJoin removeAllButton];
                         [self.btmViewJoin addButtons:@"수락" obj:self withSelector:@selector(onAdminConfirm) tag:0];
                         [self.btmViewJoin addButtons:@"거절" obj:self withSelector:@selector(onAdminCancel) tag:1];

                         
                         
                         [self.viewJoin addSubview:self.btmViewJoin];
                         [self.viewTabList removeTab:2];//
                         [self.viewTabList addTab:@"참여관리" subView:self.viewJoin];
                         [self.viewTabList changeTab:@"참여관리" nIndex:2];
                         //신청자 여부 조회
                     }
                     //일반구성원
                     else
                     {
                         //머핀리스트 표시..
                         [self.viewTabList removeTab:2];
                         [self.viewTabList addTab:@"List" subView:self.viewJoinList];
                         [self.viewTabList changeTab:@"List" nIndex:2];

                         self->arrPartAsk = nil;
                         self->arrPartAsk = [[NSMutableArray alloc] init];


                         NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

                         dic[@"Function"] = @"SongInfo_SelectGroup";
                         dic[@"GroupId"] = self.project.projectID;

                         [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
                         {
                             if (result != nil)
                             {
                                 NSArray * arr = result;
                                 [self->arrPartAsk removeAllObjects];
                              
                                 for (NSDictionary * dic in arr)
                                 {
                                     SongInfo * muffin = [[SongInfo alloc] initWithData:dic];
                                      
                                     [self->arrPartAsk addObject:muffin];
                                 }
                                [self.tblJoinList reloadData];
                             }
                         }];
                     }
                 }
             }
             else //미구성원
             {
                 //참여신청 여부 조회 -> 참여신청진행
                 NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                 
                 dic[@"Function"] = @"PartAsk_SelectUser";
                 dic[@"GroupId"] = self.project.projectID;
                 dic[@"UserId"] = [UserInfo instance].userID;
                 
                 [[EDHttpTransManager instance] callPartAskInfo:dic withBlack:^(id result, NSError * error)
                  {
                      if (result != nil)
                      {
                          if (self->arrPartAsk != nil) [self->arrPartAsk removeAllObjects];

                          self->arrPartAsk = [[NSMutableArray alloc] initWithArray:result];
                          if (self->arrPartAsk.count != 0)
                          {
                              NSDictionary * dic = self->arrPartAsk[0];
                              if (dic != nil)
                              {
                                  NSString * strProgress = [NSString stringWithFormat:@"%@", dic[@"Progress"]];
                                  //상태진행코드(Progress) 에 따라 화면전환 - 01:신청중 10:수락 99:거부 11:완료
                                  if ([strProgress isEqualToString:@"01"])
                                  {
                                      //"신청중" 메시지 표시
                                      self.lbPartAskMessage.textAlignment = NSTextAlignmentCenter;
                                      self.lbPartAskMessage.text = @"현재 Project 내부에서 확인 중입니다.";
//                                      [self.btmViewJoin setChangeButtonTitle:0 sTitle: @"확인"];
                                      
                                      [self.btmViewJoin removeAllButton];
                                      [self.btmViewJoin addButtons:@"확인" obj:self withSelector:@selector(onAfterReqConfrim) tag:2];
                                      [self.btmViewJoin addButtons:@"신청취소" obj:self withSelector:@selector(onAfterReqCancel) tag:3];
                                      [self.viewJoinMsg addSubview:self.btmViewJoin];
                                      
                                      [self.viewTabList removeTab:2];
                                      [self.viewTabList addTab:@"참여신청" subView:self.viewJoinMsg];
                                      [self.viewTabList changeTab:@"참여신청" nIndex:2];
                                  }
                                  //신청 완료 -> 머핀리스트 표시
                                  else if ([strProgress isEqualToString:@"10"] || [strProgress isEqualToString:@"11"])
                                  {
                                      //신청리스트가 없는 경우.. 머핀리스트 표시
                                      [self.viewTabList removeTab:2];
                                      [self.viewTabList addTab:@"List" subView:self.viewJoinList];
                                      [self.viewTabList changeTab:@"List" nIndex:2];
                                      
                                      self->arrPartAsk = nil;
                                      self->arrPartAsk = [[NSMutableArray alloc] init];
                                      
                                      [self doMuffinList];
                                  }
                                  //신청 거부 -> 화면전환? 메시지표시?
                                  else if ([strProgress isEqualToString:@"99"])
                                  {
                                      [self.btmViewJoin removeAllButton];
                                      [self.btmViewJoin addButtons:@"신청" obj:self withSelector:@selector(onReq) tag:0];
                                      [self.btmViewJoin addButtons:@"취소" obj:self withSelector:@selector(onBeforeReqCancel) tag:1];
                                      [self.viewJoin addSubview:self.btmViewJoin];
                                      
                                      [self.viewTabList removeTab:2];//
                                      [self.viewTabList addTab:@"참여신청" subView:self.viewJoin];
                                      [self.viewTabList changeTab:@"참여신청" nIndex:2];
                                  }
                              }
                          }
                          else
                          {
                              [self.btmViewJoin removeAllButton];
                              [self.btmViewJoin addButtons:@"신청" obj:self withSelector:@selector(onReq) tag:0];
                              [self.btmViewJoin addButtons:@"취소" obj:self withSelector:@selector(onBeforeReqCancel) tag:1];
                              [self.viewJoin addSubview:self.btmViewJoin];
                              
                              [self.viewTabList removeTab:2];//
                              [self.viewTabList addTab:@"참여신청" subView:self.viewJoin];
                              [self.viewTabList changeTab:@"참여신청" nIndex:2];
                          }
                      }
                  }];
             }
         }
     }];
    
    // 그룹 대표음악 얻어오기
    [self doGetGroupFirstMuffin];
    
    [self.viewTabList changeTab:@"Timeline" nIndex:0];
}

-(void) doTimeLineList
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"TimeLine_Select";
    dic[@"GroupId"] = self.project.projectID;
    [[EDHttpTransManager instance] callAllTimelineInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             if (self->arrTimeline != nil) [self->arrTimeline removeAllObjects];
             
             self->arrTimeline = [[NSMutableArray alloc] initWithArray:result];
             
             if (self->arrTimeline.count != 0)
             {
                 [self.tblTimeline reloadData];
                 
                 // 마지막 셀로 위치
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tblTimeline numberOfRowsInSection:0] - 1 inSection:0];
                 [self.tblTimeline scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
         }
         
     }];
}

-(void) doArtistList
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"GroupItemAll_Select";
    dic[@"GroupId"] = self.project.projectID;
    [[EDHttpTransManager instance] callGroupItemInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             if (self->arrArtists != nil) [self->arrArtists removeAllObjects];
             
             self->arrArtists = [[NSMutableArray alloc] initWithArray:result];
             
             if (self->arrArtists.count != 0)
             {
                 [self.tblArtists reloadData];
                 
                 // 마지막 셀로 위치
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tblArtists numberOfRowsInSection:0] - 1 inSection:0];
                 [self.tblArtists scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
         }
         
     }];
}

-(void) doGetGroupFirstMuffin
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"SongInfo_SelectGroup";
    dic[@"GroupId"] = self.project.projectID;
    
    [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             if (self->arrSongInfo != nil) [self->arrTimeline removeAllObjects];
             
             self->arrSongInfo = [[NSMutableArray alloc] initWithArray:result];
             
             [self setShowPlayer:YES];
         }
     }];
}

-(void) doMuffinList
{
    self->arrPartAsk = nil;
    self->arrPartAsk = [[NSMutableArray alloc] init];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"SongInfo_SelectGroup";
    dic[@"GroupId"] = self.project.projectID;
    
    [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             [self->arrPartAsk removeAllObjects];
             
             for (NSDictionary * dic in arr)
             {
                 SongInfo * muffin = [[SongInfo alloc] initWithData:dic];
                 
                 [self->arrPartAsk addObject:muffin];
             }
             [self.tblJoinList reloadData];
         }
     }];
}

-(void) doGroupImage
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"Function"] = @"GroupInfo_Select";
    dic[@"GroupId"] = self.project.projectID;
//    dic[@"UserId"] = [UserInfo instance].userID;
    [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             NSDictionary * dic = arr[0];
             if (dic != nil)
             {
                 // 이미지를 읽어올 주소
                 NSString *imgPath = dic[@"ImagePath"];
                 NSString *imgName = dic[@"ImageId"];
                 
                 NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imgPath, imgName]];
                 NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
                 // 데이터가 정상적으로 읽혔는지 확인한다. 네트워크가 연결되지 않았다면 nil이다.
                 if(dataImage)
                 {
                     self.imgProject.image = [UIImage imageWithData:dataImage];
                 }
             }
         }
     }];
}

- (void)playMuffin:(UIButton*)sender
{
    if (self->arrSongInfo.count == 0)
        return;
    
    // 대표음악 재생
    NSDictionary * dic = self->arrSongInfo[0];
    SongInfo * muffinInfo = [[SongInfo alloc] initWithData:dic];

    if(muffinInfo != nil)
    {
        UIButton *btnPlay = (UIButton *)sender;
        
        if ([btnPlay.currentImage isEqual:[UIImage imageNamed:@"play_btn.png"]])
        {
            NSString* strFilePath = muffinInfo.musicPath;
            NSString* strFileID = muffinInfo.musicFileID;
            NSString* strMuffinURL = [strFilePath stringByAppendingString:strFileID];
            NSURL* url = [NSURL URLWithString:strMuffinURL];
            
            if (url != nil) {
                STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
                [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
                
                UIImage *backButtonImage = [UIImage imageNamed:@"btn_on.png"];
                [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
            }
        }
        else
        {
            [self stopMuffin:btnPlay];
        }
    }
}

- (void)playMuffinList:(UIButton*)sender
{
    if (self->arrPartAsk.count == 0)
        return;
    
    SongInfo * muffinInfo = arrPartAsk[sender.tag];
    if(muffinInfo != nil)
    {
        UIButton *btnPlay = (UIButton *)sender;
        if ([btnPlay.currentImage isEqual:[UIImage imageNamed:@"btn_s_play.png"]])
        {
            NSString* strFilePath = muffinInfo.musicPath;
            NSString* strFileID = muffinInfo.musicFileID;
            NSString* strMuffinURL = [strFilePath stringByAppendingString:strFileID];
            NSURL* url = [NSURL URLWithString:strMuffinURL];

            if (url != nil) {
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
        }
        else
        {
            [self stopMuffinList:btnPlay];
            
            btnPrevPlay = nil;
        }
    }
}

- (void)stopMuffin:(UIButton*)sender
{
    UIImage *backButtonImage = [UIImage imageNamed:@"play_btn.png"];
    [sender setImage:backButtonImage forState:UIControlStateNormal];
    
    [[AudioUtil player] stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)stopMuffinList:(UIButton*)sender
{
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [sender setImage:backButtonImage forState:UIControlStateNormal];
    
    [[AudioUtil player] stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//관리자 확인
- (void) onAdminConfirm;
{
    if (self->arrPartAsk.count == 0)
    {
        return;
    }
    
    PartAskInfo * partAskInfo = [[PartAskInfo alloc] initWithData:self->arrPartAsk[0]];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"PartAsk_UpdateProgress";
    dic[@"GroupId"] = partAskInfo.groupID;// self.project.projectID;
    dic[@"UserId"] = partAskInfo.userID;//[UserInfo instance].userID;
    dic[@"Progress"] = @"11"; // 01:신청 10:수락 99:거부 11:완료
    
    [[EDHttpTransManager instance] callPartAskInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             //
         }
         else
         {
             //상태 업데이트(완료) 후 그룹아이템 등록
             dic[@"Function"] = @"GroupItem_Insert";
             dic[@"GroupId"] = partAskInfo.groupID;
             dic[@"UserId"] = partAskInfo.userID;
             dic[@"Position"] = @"01";//작사
             [[EDHttpTransManager instance] callGroupItemInfo:dic withBlack:^(id result, NSError * error)
              {
                  if (result != nil)
                  {
                      //
                  }
                  //그룹 아이템 등록 후 muffin 등록
                  else
                  {
                      dic[@"Function"] = @"SongInfo_Insert";
                      dic[@"GroupId"] = partAskInfo.groupID;
                      dic[@"SongName"] = [partAskInfo.userID stringByAppendingString: @" Song"]; //임시 입력
                      dic[@"MusicFileId"] = partAskInfo.fileName;
                      dic[@"PublicYN"] = @"Y";  //임시 입력

                      [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
                       {
                           if (result != nil)
                           {
                           }
                           else
                           {
                               //muffin 등록 후 신청리스트 재조회
                               dic[@"Function"] = @"PartAsk_Select";
                               dic[@"GroupId"] = self.project.projectID;
                               
                               [[EDHttpTransManager instance] callPartAskInfo:dic withBlack:^(id result, NSError * error)
                                {
                                    if (result != nil)
                                    {
                                        if (self->arrPartAsk != nil) [self->arrPartAsk removeAllObjects];
                                        
                                        self->arrPartAsk = [[NSMutableArray alloc] initWithArray:result];
                                        if (self->arrPartAsk.count != 0)
                                        {
                                            NSDictionary * dic = self->arrPartAsk[0];
                                            if (dic != nil)
                                            {
                                                PartAskInfo * partAskInfo = [[PartAskInfo alloc] init];
                                                
                                                partAskInfo.groupID = dic[@"GroupId"];
                                                partAskInfo.userID = dic[@"UserId"];
                                                partAskInfo.reqMessage = dic[@"ReqMessage"];
                                                partAskInfo.resMessage = dic[@"ResMessage"];
                                                partAskInfo.progress = dic[@"Progress"];
                                                partAskInfo.askType = dic[@"AskType"];
                                                partAskInfo.fileName = dic[@"FileName"];
                                                partAskInfo.filePath = dic[@"FilePath"];
                                                
                                                self.fldPartAskContents.editable = false;
                                                self.fldPartAskFileName.enabled = false;
                                                self.btnJoin1.enabled = false;
                                                self.btnJoin2.enabled = false;
                                                
                                                [self.fldPartAskContents setText: partAskInfo.reqMessage];
                                                
                                                //음원
                                                if ([partAskInfo.askType isEqualToString: @"01"])
                                                {
                                                    self.btnJoin1.enabled = true;
                                                    [self.btnJoin1 setSelected: true];
                                                }
                                                //가사
                                                else
                                                {
                                                    self.btnJoin2.enabled = true;
                                                    [self.btnJoin2 setSelected: true];
                                                }
                                                
                                                [self.fldPartAskFileName setText: partAskInfo.fileName];
                                            }
                                        }
                                        else
                                        {
                                            //참여관리 '수락' 완료 -> 아티스트 리스트 탭전환 && 재조회
                                            [self doArtistList];
                                            [self.viewTabList tabChange:1];
                                            
                                            //신청리스트가 없는 경우.. 머핀리스트 재조회
                                            [self doMuffinList];
                                            [self.viewTabList removeTab:2];
                                            [self.viewTabList addTab:@"List" subView:self.viewJoinList];
//                                            [self.viewTabList tabChange:2];

                                        }
                                    }
                                    //신청리스트가 없으면 머핀리스트 표시
                                    else
                                    {
                                        //참여관리 '수락' 완료 -> 아티스트 리스트 탭전환 && 재조회
                                        [self doArtistList];
                                        [self.viewTabList tabChange:1];
                                        
                                        //신청리스트가 없는 경우.. 머핀리스트 재조회
                                        [self doMuffinList];
                                        [self.viewTabList removeTab:2];
                                        [self.viewTabList addTab:@"List" subView:self.viewJoinList];
//                                            [self.viewTabList tabChange:2];
                                    }
                                }];
                           }
                       }];
                  }
              }];
            
//             NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

             
//             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

//관리자 취소
- (void) onAdminCancel;
{
    if (self->arrPartAsk.count == 0)
    {
        return;
    }
    
    PartAskInfo * partAskInfo = [[PartAskInfo alloc] initWithData:self->arrPartAsk[0]];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"PartAsk_UpdateProgress";
    dic[@"GroupId"] = partAskInfo.groupID;// self.project.projectID;
    dic[@"UserId"] = partAskInfo.userID;//[UserInfo instance].userID;
    dic[@"Progress"] = @"99"; // 01:신청 10:수락 99:거부 11:완료
    
    [[EDHttpTransManager instance] callPartAskInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             //
         }
         else
         {
             NSString *sMsg = @"취소가 완료 되었습니다.";
             if (![sMsg isEqualToString:@""] && sMsg != nil)
             {
                 UIWindow *window = UIApplication.sharedApplication.delegate.window;
                 [window.rootViewController.view makeToast:sMsg];
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

//비구성원 참여신청
- (void) onReq;
{
    if ( [self.fldPartAskContents.text length] < 1 && [self.fldPartAskContents.text isEqualToString:@""] )
    {
        NSString *sMsg = @"참여신청 메시지를 입력하십시오.";
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:sMsg];
        
        return;
    }
    
    if ( [self.fldPartAskFileName.text length] < 1 && [self.fldPartAskFileName.text isEqualToString:@""] )
    {
        NSString *sMsg = @"음원 또는 가사 파일을 선택하십시오.";
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:sMsg];
        
        return;
    }
    
    //선택 파일(음원 or 가사) 업로드 완료 -> upload delegate에서 신청 프로세스..
    if (self.btnJoin1.selected)
        [self doFilesUpload: @"mp3"];
    else if (self.btnJoin2.selected)
        [self doFilesUpload: @"txt"];
}

//비구성원 참여신청 취소
- (void) onBeforeReqCancel;
{
    //참여신청
    NSString *sMsg = @"참여신청을 취소합니다.";
    if (![sMsg isEqualToString:@""] && sMsg != nil)
    {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:sMsg];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//비구성원 참여신청 상태확인
- (void) onAfterReqConfrim;
{
    //참여신청 처리 상태
//    if ([[self.btmViewJoin getButtonTitle:0] isEqualToString:@"확인"])
//    {
        NSString *sMsg = @"내부 검토 중 입니다.";
        if (![sMsg isEqualToString:@""] && sMsg != nil)
        {
            UIWindow *window = UIApplication.sharedApplication.delegate.window;
            [window.rootViewController.view makeToast:sMsg];
        }
        return;
//    }
}

//비구성원 참여신청 상태취소
- (void) onAfterReqCancel;
{
    //참여신청 취소
//    if ([[self.btmViewJoin getButtonTitle:1] isEqualToString:@"신청취소"])
//    {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        
        dic[@"Function"] = @"PartAsk_Delete";
        dic[@"GroupId"] = self.project.projectID;
        dic[@"UserId"] = [UserInfo instance].userID;
        
        [[EDHttpTransManager instance] callPartAskInfo:dic withBlack:^(id result, NSError * error)
         {
             if (result != nil)
             {
                 //
             }
             else  // 참여취소 완료 후 화면전환
             {
                 NSString *sMsg = @"참여신청이 취소되었습니다.";
                 if (![sMsg isEqualToString:@""] && sMsg != nil)
                 {
                     UIWindow *window = UIApplication.sharedApplication.delegate.window;
                     [window.rootViewController.view makeToast:sMsg];
                 }
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
//    }
}


- (void) okClick
{
//    NSLog(@"okClick");
//    NSString * sTabTitle = [self.viewTabList currentTabTitle];
//
//    if ( [sTabTitle isEqualToString:@"Timeline"] )
//    {
        if ( [strStatus isEqualToString: @"전체PJT"] )
        {
            if (self->arrGroupItem.count == 0)
            {
                NSString *sMsg = @"조회 데이터가 없습니다.";
                if (![sMsg isEqualToString:@""] && sMsg != nil)
                {
                    UIWindow *window = UIApplication.sharedApplication.delegate.window;
                    [window.rootViewController.view makeToast:sMsg];
                }
            }
            else
            {
                NSDictionary * dic = self->arrGroupItem[0];
                if (dic != nil) //구성원이면
                {
                    // 프로젝트 그룹에 속해있는 경우... 내부 타임라인 조회
                    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

                    dic[@"Function"] = @"TimeLine_Select";
                    dic[@"GroupId"] = self.project.projectID;
                    [[EDHttpTransManager instance] callTimelineInfo:dic withBlack:^(id result, NSError * error)
                     {
                         if (result != nil)
                         {
                             if (self->arrTimeline != nil) [self->arrTimeline removeAllObjects];
                             
                             self->arrTimeline = [[NSMutableArray alloc] initWithArray:result];
                             
                             if (self->arrTimeline.count > 0)
                             {
                                 [self.tblTimeline reloadData];

                                 strStatus = @"내부PJT";
                                 // 마지막 셀로 위치
                                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tblTimeline numberOfRowsInSection:0] - 1 inSection:0];
                                 [self.tblTimeline scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

                                 [self.btnViewTimeLine setChangeButtonTitle:0 sTitle: @"전체PJT" tag:0];
                             }
                             else
                             {
                                 NSString *sMsg = @"조회 데이터가 없습니다.";
                                 if (![sMsg isEqualToString:@""] && sMsg != nil)
                                 {
                                     UIWindow *window = UIApplication.sharedApplication.delegate.window;
                                     [window.rootViewController.view makeToast:sMsg];
                                 }
                             }
                         }
                     }];
                }
                // 프로젝트 그룹에 속해있지 않은 경우... 메시지 표시
                else
                {
                    NSString *sMsg = @"구성원이 아닙니다.";
                    if (![sMsg isEqualToString:@""] && sMsg != nil)
                    {
                        UIWindow *window = UIApplication.sharedApplication.delegate.window;
                        [window.rootViewController.view makeToast:sMsg];
                    }
                }
            }
        }
        else
        {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];// controller -> AlltimelineController
            
            dic[@"Function"] = @"TimeLine_Select";
            dic[@"GroupId"] = self.project.projectID;
            [[EDHttpTransManager instance] callAllTimelineInfo:dic withBlack:^(id result, NSError * error)
             {
                 if (result != nil)
                 {
                     if (self->arrTimeline != nil) [self->arrTimeline removeAllObjects];
                     
                     self->arrTimeline = [[NSMutableArray alloc] initWithArray:result];
                     
                     [self.tblTimeline reloadData];
                     
                     if (self->arrTimeline.count > 0)
                     {
                         // 마지막 셀로 위치
                         strStatus = @"전체PJT";

                         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tblTimeline numberOfRowsInSection:0] - 1 inSection:0];
                         [self.tblTimeline scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

                         [self.btnViewTimeLine setChangeButtonTitle:0 sTitle: @"내부PJT" tag:1];
                     }
                     else
                     {
                         NSString *sMsg = @"조회 데이터가 없습니다.";
                         if (![sMsg isEqualToString:@""] && sMsg != nil)
                         {
                             UIWindow *window = UIApplication.sharedApplication.delegate.window;
                             [window.rootViewController.view makeToast:sMsg];
                         }
                     }
                 }
                 
             }];
        }
//    }
}

- (void) onWriteTimelineClick
{
    CGRect r = self.viewTimeline.frame;
    
    self.viewTimelineIInsert.frame = r;
    
    [self.viewTimeline addSubview:self.viewTimelineIInsert];
    
    
    UIView * v = self.fldTimelineContents.superview;
    
    r = v.frame;
    r.size.width = self.viewTimeline.frame.size.width - 20;
    r.origin.x   = 10;
    v.frame = r;
    

    r = v.bounds;
    
    CGRectInset(r, 3, 3);

    self.fldTimelineContents.frame = r;

    self.fldTimelineContents.text = @"";
    
    [self.btnViewTimeLine clearLayout];
    [self.btnViewTimeLine addButtons:@"글올리기" obj:self withSelector:@selector(onTimelineUpload) tag:0];
    [self.btnViewTimeLine addButtons:@"취소" obj:self withSelector:@selector(onWriteCancelClick) tag:1];
    [self.btnViewTimeLine addButtons:@"" obj:self withSelector:nil tag:2];

    self.lbTimelineID.text = [UserInfo instance].userID;
}

- (void) onTimelineUpload
{
    if ([self.fldTimelineContents.text isEqualToString:@""])
    {
        NSString *sMsg = @"입력한 글자가 없습니다.";
        if (![sMsg isEqualToString:@""] && sMsg != nil)
        {
            UIWindow *window = UIApplication.sharedApplication.delegate.window;
            [window.rootViewController.view makeToast:sMsg];
        }
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"Function"] = @"TimeLine_Insert";
    dic[@"GroupId"] = self.project.projectID;
    dic[@"UserId"] = [UserInfo instance].userID;
    dic[@"Message"] = self.fldTimelineContents.text;

    if ( [strStatus isEqualToString: @"내부PJT"] ) //내부PJT
    {
        [[EDHttpTransManager instance] callTimelineInfo:dic withBlack:^(id result, NSError * error)
         {
             if (result != nil)
             {
                 if (self->arrTimeline != nil) [self->arrTimeline removeAllObjects];
                 
                 self->arrTimeline = [[NSMutableArray alloc] initWithArray:result];
                 
                 [self.tblTimeline reloadData];

                 // 마지막 셀로 위치
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tblTimeline numberOfRowsInSection:0] - 1 inSection:0];
                 [self.tblTimeline scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
             else  // 글올리기 완료 후 내부PJT 조회..
             {
                 NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                 
                 dic[@"Function"] = @"TimeLine_Select";
                 dic[@"GroupId"] = self.project.projectID;
                 [[EDHttpTransManager instance] callTimelineInfo:dic withBlack:^(id result, NSError * error)
                  {
                      if (result != nil)
                      {
                          if (self->arrTimeline != nil) [self->arrTimeline removeAllObjects];
                          
                          self->arrTimeline = [[NSMutableArray alloc] initWithArray:result];
                          
                          [self.tblTimeline reloadData];
                          
                          // 마지막 셀로 위치
                          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tblTimeline numberOfRowsInSection:0] - 1 inSection:0];
                          [self.tblTimeline scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                          [self onWriteCancelClick];
                      }
                  }];
             }
         }];
    }
    else
    {
        [[EDHttpTransManager instance] callAllTimelineInfo:dic withBlack:^(id result, NSError * error)
         {
             if (result != nil)
             {
                 if (self->arrTimeline != nil) [self->arrTimeline removeAllObjects];
                 
                 self->arrTimeline = [[NSMutableArray alloc] initWithArray:result];
                 
                 [self.tblTimeline reloadData];
             }
             else // 글올리기 완료 후 전체PJT 조회..
             {
                 NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];// controller -> AlltimelineController
                 
                 dic[@"Function"] = @"TimeLine_Select";
                 dic[@"GroupId"] = self.project.projectID;
                 [[EDHttpTransManager instance] callAllTimelineInfo:dic withBlack:^(id result, NSError * error)
                  {
                      if (result != nil)
                      {
                          if (self->arrTimeline != nil) [self->arrTimeline removeAllObjects];
                          
                          self->arrTimeline = [[NSMutableArray alloc] initWithArray:result];
                          
                          [self.tblTimeline reloadData];
                          
                          // 마지막 셀로 위치
                          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tblTimeline numberOfRowsInSection:0] - 1 inSection:0];
                          [self.tblTimeline scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                          [self onWriteCancelClick];
                      }
                  }];
             }
         }];
    }
}

- (void) onWriteCancelClick
{
    [self.viewTimelineIInsert removeFromSuperview];
    
    [self.btnViewTimeLine clearLayout];
    
    if ( [strStatus isEqualToString: @"전체PJT"] )
        [self.btnViewTimeLine addButtons:@"내부PJT" obj:self withSelector:@selector(okClick) tag:0];
    else
        [self.btnViewTimeLine addButtons:@"전체PJT" obj:self withSelector:@selector(okClick) tag:1];
    
    [self.btnViewTimeLine addButtons:@"글쓰기" obj:self withSelector:@selector(onWriteTimelineClick) tag:2];
    [self.btnViewTimeLine addButtons:@"0" obj:self withSelector:nil tag:3];
}


- (void) setShowPlayer:(BOOL)showPlayer
{
    if (showPlayer)
    {
        //make PlayButton
        UIButton * btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPlay.frame = CGRectMake(10, 0, 60, 40);
        btnPlay.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
        
        UIImage *backButtonImage = [UIImage imageNamed:@"play_btn.png"];
        
        if (self->arrSongInfo.count == 0)
            [btnPlay setImage:backButtonImage forState:UIControlStateDisabled];
        else
            [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
        
        [btnPlay addTarget:self action:@selector(playMuffin:) forControlEvents:UIControlEventTouchUpInside];
        btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIBarButtonItem * customItem = [[UIBarButtonItem alloc] initWithCustomView:btnPlay];
        
        self.navigationItem.rightBarButtonItem = customItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) adjustSizeLayoutEx
{
    
    
    [CommonUtil  iosChangeScaleView:_viewTimeline  fontSizeFix:1.0];
    [CommonUtil  iosChangeScaleView:_viewArtists   fontSizeFix:1.0];
    [CommonUtil  iosChangeScaleView:_viewJoin      fontSizeFix:1.0];
    [CommonUtil  iosChangeScaleView:_viewJoinList  fontSizeFix:1.0];

    
    [CommonUtil iosScaleRect:_viewJoin];
    
    CGRect r = viewTabList.getClientRect;
    
    if (IS_IPHONE_X)
        r.size.height -= 40;
    
    _viewTimeline.frame = r;
    _viewArtists.frame  = r;
    _viewJoin.frame = r;
    _viewJoinList.frame = r;
    
    
    CGRect br = r;
    
    br.origin.y = CGRectGetMaxY(r)-40;
    
    
    br.size.height = 40;
    
    _btmViewJoin.frame = br;
    _btmViewArtist.frame = br;
    _btnViewTimeLine.frame = br;
    
    [_viewTimeline.superview addSubview:_btnViewTimeLine];
//    [_viewArtists.superview addSubview:_btmViewArtist];
    [_viewJoin.superview addSubview:_btmViewJoin];
    
    [_btmViewJoin buildLayout];
//    [_btmViewArtist buildLayout];
    [_btnViewTimeLine buildLayout];
}


- (void) initLayout
{
    [viewTabList addTab:@"Timeline" subView:_viewTimeline];
    [viewTabList addTab:@"Artists" subView:_viewArtists];
    [viewTabList addTab:@"참여신청" subView:_viewJoin];
    [self.viewTabList changeTab:@"Timeline" nIndex:0];
    
    _lbProjectTitle.text = self.project.projectName;
    _lbProjectContents.text = self.project.projectCnte;
    
    _btnJoin1.selected = YES;
}

- (void)viewDidLoad {
    
//    [self.btmViewArtist addButtons:@"확인" obj:self withSelector:@selector(okClick)];
//    [self.btmViewArtist addButtons:@"취소" obj:self withSelector:@selector(okClick)];

    [self.btnViewTimeLine addButtons:@"내부PJT" obj:self withSelector:@selector(okClick) tag:0];
    [self.btnViewTimeLine addButtons:@"글쓰기" obj:self withSelector:@selector(onWriteTimelineClick) tag:2];
//    [self.btnViewTimeLine addButtons:@"0" obj:self withSelector:nil];

//    [self.btmViewJoin addButtons:@"신청" obj:self withSelector:@selector(okClick) tag:0];
//    [self.btmViewJoin addButtons:@"취소" obj:self withSelector:@selector(okClick) tag:1];

    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    self.title = self.project.projectName;
 
    arrTimeline = [[NSMutableArray alloc] init];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(showRightView)];
    
    maskPrjImage = [[UIImageView alloc] init];
    maskPrjImage.image = [UIImage imageNamed:@"maskimg.png"];
//    _imgProject.maskView = maskPrjImage;

    [self initLayout];

    self.showTitleLogo = NO;
    self.showPlayer    = NO;
    
    [self setTitleText:self.project.projectName];
    
//    [self setShowPlayer:YES];
    
    [_lbPartAskMessage setNumberOfLines:0];
    
    [self initData];
    [self initIndicator];
    [self setFTP];

    [self adjustSizeLayoutEx];
    self.showBack = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.btnViewTimeLine setChangeButtonTitle:0 sTitle: @"내부PJT" tag:1];
}


- (id) initWithProject:(ProjectInfo *) aProject
{
    self = [super initWithNibName:@"ProjectViewController" bundle:nil];
    if (self)
    {
        self.project = aProject;

    }
    
    return self;
}


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    maskPrjImage.frame = _imgProject.bounds;
    
}

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated    {
    [[AudioUtil player] stop];
    [super viewWillDisappear:animated];
}

//- (void)appearKeyboard:(NSNotification *)noti   {
//
//    CGRect frame = {0.0f, 0.0f, 0.0f, 250.0f};
//    CGFloat animationDuration = 0.0f;
//
//    [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frame];
//    [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
//     getValue:&animationDuration];
//
//    _tblTimeline.frame = CGRectMake(0.0f,0.0f,320.0f,416.0f-frame.size.height);
//
//    [UIView animateWithDuration:animationDuration animations:^(void) {
//
//    } completion:^(BOOL finished) {
//
//        if (finished) {
//
//            [_tblTimeline scrollToRowAtIndexPath:
//             [NSIndexPath indexPathForRow:0 inSection:0]
//                              atScrollPosition:UITableViewScrollPositionMiddle
//                                      animated:YES];
//        }
//    }];
//}
//
//- (void)disappearKeyboard:(NSNotification *)noti    {
//    _tblTimeline.frame = CGRectMake(0.0f,0.0f,320.0f,416.0f);
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tblArtists)
    {
        return arrArtists.count;
    }
    else if (tableView == _tblTimeline)
    {
        return arrTimeline.count;
    }
    else if (tableView == _tblJoinList)
    {
        return arrPartAsk.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == _tblJoinList)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_PartList"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_PartList"];
        }
//        ProjectInfo * p = arrPartAsk[indexPath.row] ;
//        cell.textLabel.text = p.projectName;

        SongInfo * muffinInfo;
        muffinInfo = arrPartAsk[indexPath.row];
        
        if (muffinInfo != nil)
        {
            //make TextLabel
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:10];
            cell.textLabel.textColor = [UIColor purpleColor]; //RGB(33, 33, 33);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = [UIColor blackColor]; //RGB(33, 33, 33);
            
            //make PlayButton
            UIButton * btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
            btnPlay.frame = CGRectMake(tableView.frame.size.width - 85, (TABLE_ROW_HEIGHT_ARTISTS / 2) - 15, 75, 30);
            btnPlay.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
            
            UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
            [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
            [btnPlay addTarget:self action:@selector(playMuffinList:) forControlEvents:UIControlEventTouchUpInside];//
            btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btnPlay.tag = indexPath.row;
//            cell.accessoryView = btnPlay;
            [cell.contentView  addSubview:btnPlay];

            //관심등록버튼
            UIButton *btnPlus = [UIButton buttonWithType:UIButtonTypeContactAdd];
            btnPlus.frame = CGRectMake(tableView.frame.size.width - btnPlay.frame.size.width - 3, (TABLE_ROW_HEIGHT_ARTISTS / 2) - 15 , 30, 30);
            [btnPlus addTarget:self action:@selector(addMyMuffin:) forControlEvents:UIControlEventTouchUpInside];
            [btnPlus setTag:indexPath.row];
            btnPlus.backgroundColor = [UIColor clearColor];
            //            cell.accessoryView = btnPlus;
            [cell.contentView  addSubview:btnPlus];
            
            cell.textLabel.text = muffinInfo.groupName;
            cell.detailTextLabel.text = muffinInfo.songName;
        }
    }
    else if (tableView == _tblArtists)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

            UILabel * lb = [[UILabel alloc] init];
            lb.frame = CGRectMake(/*TABLE_ROW_HEIGHT_ARTISTS*/ + 5, 0, tableView.frame.size.width - (TABLE_ROW_HEIGHT_ARTISTS * 2), TABLE_ROW_HEIGHT_ARTISTS);
            lb.font  = [[ResourceManager sharedManager] getFontWithSize:12.0f];
            lb.textColor = [UIColor purpleColor];
            lb.tag   = 102;
            
            [cell.contentView  addSubview:lb];
            
            //관심등록버튼
            UIButton *btnPlus = [UIButton buttonWithType:UIButtonTypeContactAdd];
            btnPlus.frame = CGRectMake(tableView.frame.size.width - 45, (TABLE_ROW_HEIGHT_ARTISTS / 2) - 15 , 30, 30);
            [btnPlus addTarget:self action:@selector(addMyArtist:) forControlEvents:UIControlEventTouchUpInside];
            [btnPlus setTag:indexPath.row];
            btnPlus.backgroundColor = [UIColor clearColor];
//            cell.accessoryView = btnPlus;
            [cell.contentView  addSubview:btnPlus];
        }
        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSDictionary * dic = arrArtists[indexPath.row];
        
        
        UILabel * lb = [cell.contentView viewWithTag:102];
        if (lb)
        {
            if ( (![dic[@"PositionNm"] isEqualToString:@""]) && ([dic[@"PositionNm2"] isEqualToString:@""]) && ([dic[@"PositionNm3"] isEqualToString:@""]) )
            {
                lb.text = [NSString stringWithFormat:@"%@ (%@) : %@", dic[@"UserId"], dic[@"Username"], dic[@"PositionNm"]];
            }

            if ( (![dic[@"PositionNm"] isEqualToString:@""]) &&  (![dic[@"PositionNm2"] isEqualToString:@""]) && ([dic[@"PositionNm3"] isEqualToString:@""]) )
            {
                lb.text = [NSString stringWithFormat:@"%@ (%@) : %@, %@", dic[@"UserId"], dic[@"Username"], dic[@"PositionNm"], dic[@"PositionNm2"]];
            }
            
            if ( (![dic[@"PositionNm"] isEqualToString:@""]) &&  (![dic[@"PositionNm2"] isEqualToString:@""]) && (![dic[@"PositionNm3"] isEqualToString:@""]) )
            {
                lb.text = [NSString stringWithFormat:@"%@ (%@) : %@, %@, %@", dic[@"UserId"], dic[@"Username"], dic[@"PositionNm"],     dic[@"PositionNm2"], dic[@"PositionNm3"]];
            }
        }
    }
    else if (tableView == _tblTimeline)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_timeline"];

        NSDictionary * dic = arrTimeline[indexPath.row];

        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_timeline"];
            
            // 썸네일
//            UIImageView * imgView = [[UIImageView alloc] init];
//            imgView.image = [UIImage imageNamed:@"face00.png"];


            // 이미지를 읽어올 주소
            NSString *imgPath = dic[@"ImagePath"];
            NSString *imgName = dic[@"ImageId"];
            
            NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imgPath, imgName]];
            NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
            UIImageView *imgView = [[UIImageView alloc] init];
            // 데이터가 정상적으로 읽혔는지 확인한다. 네트워크가 연결되지 않았다면 nil이다.
            if(dataImage)
            {
                imgView.image = [UIImage imageWithData:dataImage];
            }
            
            UIImageView *maskImage = [[UIImageView alloc] init];
            maskImage.image = [UIImage imageNamed:@"maskimg.png"];
            imgView.maskView = maskImage;
            
            imgView.frame = CGRectMake(2, 2, TABLE_ROW_HEIGHT_TIMELINE - 2, TABLE_ROW_HEIGHT_TIMELINE - 2);
            maskImage.frame = imgView.frame;
            
            // UserID
            UILabel * lbUserId = [[UILabel alloc] init];
            lbUserId.frame = CGRectMake(imgView.frame.size.width + 4, 2, tableView.frame.size.width - (TABLE_ROW_HEIGHT_TIMELINE * 2), TABLE_ROW_HEIGHT_TIMELINE / 3);
//            lbUserId.frame = CGRectMake(5, 7, tableView.frame.size.width - (TABLE_ROW_HEIGHT_ARTISTS * 2), TABLE_ROW_HEIGHT_ARTISTS / 2);
            lbUserId.font  = [[ResourceManager sharedManager] getFontWithSize:15.0f];
            lbUserId.textColor = [UIColor purpleColor];
            lbUserId.tag   = 101;
            
            // 작성일자
            UILabel * lbDate = [[UILabel alloc] init];
            lbDate.frame = CGRectMake(tableView.frame.size.width - 70, 7, 70, TABLE_ROW_HEIGHT_TIMELINE / 3);
            lbDate.font  = [[ResourceManager sharedManager] getFontWithSize:10.0f];
            lbDate.textColor = [UIColor purpleColor];
            lbDate.tag   = 102;
            
            // 메시지
            UILabel * lbMsg = [[UILabel alloc] init];
            lbMsg.frame = CGRectMake(imgView.frame.size.width + 4, lbUserId.frame.origin.y + lbUserId.frame.size.height, tableView.frame.size.width - (TABLE_ROW_HEIGHT_TIMELINE * 2), TABLE_ROW_HEIGHT_TIMELINE / 2 );
//            lbMsg.frame = CGRectMake(5, lbDate.frame.size.height + 7, tableView.frame.size.width - (TABLE_ROW_HEIGHT_ARTISTS * 2), TABLE_ROW_HEIGHT_ARTISTS / 2 );
            lbMsg.font  = [[ResourceManager sharedManager] getFontWithSize:12.0f];
            lbMsg.textColor = [UIColor blackColor];
            lbMsg.tag   = 103;
            
            [cell.contentView addSubview:imgView];
            [cell.contentView addSubview:lbUserId];
            [cell.contentView addSubview:lbDate];
            [cell.contentView addSubview:lbMsg];
        }
        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel * lbUserId = [cell.contentView viewWithTag:101];
        if (lbUserId)
        {
            lbUserId.text = [NSString stringWithFormat:@"%@", dic[@"UserId"]];
        }
        UILabel * lbDate = [cell.contentView viewWithTag:102];
        if (lbDate)
        {
            lbDate.text = [NSString stringWithFormat:@"%@",dic[@"RegDate"] ];
        }
        UILabel * lbMsg = [cell.contentView viewWithTag:103];
        if (lbMsg)
        {
            lbMsg.text = [NSString stringWithFormat:@"%@", dic[@"Message"]];
        }
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (tableView == _tblArtists) return 0;
        //return TABLE_HEADER_HEIGHT;
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblArtists)
        return TABLE_ROW_HEIGHT_ARTISTS;
    else if (tableView == _tblTimeline)
        return TABLE_ROW_HEIGHT_TIMELINE;
    
    return TABLE_ROW_HEIGHT_ARTISTS;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted
{
//    if (tableView == _tblArtists)
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

        return view;
    }
    
//    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)addMyArtist:(id)sender {
    NSInteger nIndex = [sender tag];
    NSDictionary * dicArtists = arrArtists[nIndex];
    
    if (dicArtists != nil) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        dic[@"Function"] = @"BookMarkUser_Insert";
        dic[@"UserId"] = [UserInfo instance].userID;
        dic[@"BMUserId"] = dicArtists[@"UserId"];
        dic[@"Username"] = dicArtists[@"Username"];
        dic[@"BMSEQ"] = @"001";

        [[EDHttpTransManager instance] callBookmarkUserInfo:dic withBlack:^(id result, NSError * error)
         {
             if (result != nil)
             {
        
             }
             else
             {
                 UIWindow *window = UIApplication.sharedApplication.delegate.window;
                 [window.rootViewController.view makeToast:@"등록되었습니다."];
             }
         }];
    }
    else {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:@"등록할 Artist가 존재하지 않습니다."];
    }
}

- (void)addMyMuffin:(id)sender {
    NSInteger nIndex = [sender tag];
    SongInfo * muffinInfo = arrPartAsk[nIndex];
    
    if (muffinInfo != nil) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        dic[@"Function"] = @"BookMarkMuffin_Insert";
        dic[@"UserId"] = [UserInfo instance].userID;
        dic[@"BMSongId"] = muffinInfo.songID;           //머핀ID
        dic[@"SongName"] = muffinInfo.songName;         //머핀이름
        dic[@"MusicPath"] = muffinInfo.musicPath;       //경로
        dic[@"MusicFileId"] = muffinInfo.musicFileID;   //파일며
        dic[@"BMSEQ"] = @"001";
        
        [[EDHttpTransManager instance] callBookmarkMuffinInfo:dic withBlack:^(id result, NSError * error)
         {
             if (result != nil)
             {
                 
             }
             else
             {
                 UIWindow *window = UIApplication.sharedApplication.delegate.window;
                 [window.rootViewController.view makeToast:@"등록되었습니다."];
             }
         }];
    }
    else {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:@"등록할 Muffin이 존재하지 않습니다."];
    }
}


- (IBAction)onBtnPlayMuffinClick:(id)sender
{
    //관리자
    if (self->arrGroupItem.count != 0)
    {
        NSDictionary * dic = self->arrGroupItem[0];
        if (dic != nil)
        {
            NSString * strAdmin = [NSString stringWithFormat:@"%@", dic[@"Admin"]];
            //관리자일 경우 머핀재생
            if ([strAdmin isEqualToString: @"Y"])
            {
                PartAskInfo * partAskInfo = [[PartAskInfo alloc] initWithData:self->arrPartAsk[0]];
                
                if(partAskInfo != nil)
                {
                    UIButton *btnPlay = (UIButton *)sender;
                    btnPlay.selected = !btnPlay.selected;
                    
                    if ( btnPlay.isSelected )
                    {
                        NSString* sFilePath = partAskInfo.filePath;
                        NSString* sFileName = partAskInfo.fileName;
                        NSString* sMuffinURL = [sFilePath stringByAppendingString: sFileName];
                        NSURL* url = [NSURL URLWithString:sMuffinURL];
                        
                        if (url != nil) {
                            STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
                            [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
                        }
                    }
                    else
                    {
                        [[AudioUtil player] stop];
                    }
                }
            }
        }
    }
    //미구성원일 경우 파일브라우저 표시
    else
    {
        FileUploadViewController * controler = [[FileUploadViewController alloc] initWithNibName:@"FileUploadViewController" bundle:nil];
        controler.delegate = self;

        if (self.btnJoin1.selected)
            controler.sBrowserType = @"mp3";
        else if (self.btnJoin2.selected)
            controler.sBrowserType = @"txt";

        [self presentViewController:controler animated:YES completion:nil];
    }
}

-(void) getData:(NSString *)data
{
    _fldPartAskFileName.text = data;
    
    if(self.btnAddMuffin.selected == YES)
    {
        [self doFilesUpload: @"mp3"];
    }
}

- (IBAction)onAddMuffin:(id)sender {
    FileUploadViewController * controler = [[FileUploadViewController alloc] initWithNibName:@"FileUploadViewController" bundle:nil];
    controler.delegate = self;
    
    controler.sBrowserType = @"mp3";
    self.btnAddMuffin.selected = YES;
    
    [self presentViewController:controler animated:YES completion:nil];
}

- (IBAction)onBtnJoinClick:(id)sender {
    UIButton * btn = sender;
    if (btn.tag == 301)
    {
        _btnJoin1.selected = YES;
        _btnJoin2.selected = NO;
    }
    else if (btn.tag == 302)
    {
        _btnJoin1.selected = NO;
        _btnJoin2.selected = YES;
    }
}

#pragma mark - FTP File Upload..

- (void) setFTP;
{
    arrFiles = [[NSMutableArray alloc] init];
    uploader = [[FTPFileUploder alloc] init];
    uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/image_g";
    uploader.ftpUserName = @"ourworld3";
    uploader.ftpUserPassword = @"ourworld6249!";
    uploader.delegate = self;
    
    //    [self openFileExplorer];
}

- (void)doFilesUpload:(NSString *)sFileType {
    NSString * fileName = self.fldPartAskFileName.text;
    NSString * fullPath = [self getFileToDocumentDirectoryWithFiles:fileName];

    if ([sFileType isEqualToString: @"mp3"])
        uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/muffin";
    else if ([sFileType isEqualToString: @"txt"])
        uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/muffin";
    
    [uploader upload:fullPath];
}

-(NSString *)getFileToDocumentDirectoryWithFiles: (NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = documentsDirectory;// [documentsDirectory stringByAppendingPathComponent:@"/images"];
    
    fileName = [NSString stringWithFormat:@"%@/%@", dataPath, fileName];
    return fileName;
}

-(NSString *)getRandomNumber{
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); // returned as a double
    long digits = (long)time; // this is the first 10 digits
    int decimalDigits = (int)(fmod(time, 1) * 1000); // this will get the 3 missing digits
    //long timestamp = (digits * 1000) + decimalDigits;
    NSString *timestampString = [NSString stringWithFormat:@"%ld%d",digits ,decimalDigits];
    return timestampString;
}

- (void) UploadProcess:(FTPFileUploder *) FileUploader nState:(int)nState sMessage:(NSString *) sMessage;
{
    NSLog(@"ftp log : %@[%d]", sMessage, nState);
    NSString * sMsg;
    if (nState < 0)
    {
        [activityIndicator stopAnimating];
        activityIndicator.hidden= TRUE;
        
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:@"업로드 실패"];
    }
    //업로드 중..
    else if ( nState == 20000)
    {
        activityIndicator.hidden= FALSE;
        [activityIndicator startAnimating];
    }
    //업로드 완료
    else if ( nState == 99999)
    {
        [activityIndicator stopAnimating];
        activityIndicator.hidden= TRUE;
        
        if(self.btnAddMuffin.selected == YES)
        {
            self.btnAddMuffin.selected = NO;
            sMsg = @"Muffin 등록이 완료되었습니다.";

            //관리자 머핀등록 완료
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            dic[@"Function"] = @"SongInfo_Insert";
            dic[@"GroupId"] = self.project.projectID;
            dic[@"SongName"] = [[UserInfo instance].userID stringByAppendingString: @" Song"]; //임시 입력
            dic[@"MusicFileId"] = _fldPartAskFileName.text;
            dic[@"PublicYN"] = @"Y";  //임시 입력
            
            [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
             {
                 if (result != nil)
                 {
                 }
                 else
                 {
                     //머핀등록 완료 후 머핀리스트 재조회
                     [self doMuffinList];
                 }
             }
             ];
            
        }
        else
        {
            [self doPartInsert];
            sMsg = @"참여신청이 완료되었습니다.";
        }
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:sMsg];
    }
}

//참여신청
- (void) doPartInsert
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"Function"] = @"PartAsk_Insert";
    dic[@"GroupId"] = self.project.projectID;
    dic[@"UserId"] = [UserInfo instance].userID;
    dic[@"ReqMessage"] = self.fldPartAskContents.text;
    dic[@"RespMessage"] = @"";
    //음원
    if (self.btnJoin1.isSelected)
        dic[@"AskType"] = @"01";
    //가사
    else if(self.btnJoin2.isSelected)
        dic[@"AskType"] = @"02";
    
    //파일명(임시 - ex> 1.mp3, 2.mp3, 3.mp3 ...)
    dic[@"FileName"] = self.fldPartAskFileName.text;
    dic[@"FilePath"] = @"";
    
    [[EDHttpTransManager instance] callPartAskInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             //
         }
         else  // 참여신청 완료 후 화면전환
         {
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

@end

