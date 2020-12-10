//
//  ProjectViewController.h
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "ProjectInfo.h"
#import "EDTabstyleView.h"
#import "EDBottomButtonView.h"
#import "EDRoundButton.h"
#import "FileUploadViewController.h"

@interface ProjectViewController : EDBaseViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, FileUploadViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic)  ProjectInfo * project;
@property (weak, nonatomic) IBOutlet EDTabstyleView *viewTabList;
@property (strong, nonatomic) IBOutlet UIView *viewTimeline;
@property (strong, nonatomic) IBOutlet UIView *viewArtists;
@property (strong, nonatomic) IBOutlet UIView *viewJoin;
@property (strong, nonatomic) IBOutlet UIView *viewJoinList;
@property (strong, nonatomic) IBOutlet UIView *viewJoinMsg;
@property (weak, nonatomic) IBOutlet UITableView *tblArtists;
@property (strong, nonatomic) IBOutlet UIImageView *imgProject;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UIView *viewTimelineBottom;
@property (strong, nonatomic) IBOutlet UITableView *tblTimeline;
@property (weak, nonatomic) IBOutlet UITableView *tblJoinList;

@property (strong, nonatomic) IBOutlet EDBottomButtonView *btmViewJoin;
@property (strong, nonatomic) IBOutlet EDBottomButtonView *btnViewTimeLine;
@property (strong, nonatomic) IBOutlet EDBottomButtonView *btmViewArtist;
@property (weak, nonatomic) IBOutlet EDBottomButtonView *btnViewJoinList;
@property (strong, nonatomic) IBOutlet UILabel *lbProjectTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbProjectContents;
@property (strong, nonatomic) IBOutlet UILabel *lbPartAskMessage;

@property (strong, nonatomic) IBOutlet UIView *viewTimelineIInsert;
@property (strong, nonatomic) IBOutlet UITextView *fldTimelineContents;
@property (strong, nonatomic) IBOutlet UITextView *fldPartAskContents;
@property (strong, nonatomic) IBOutlet UITextField *fldPartAskFileName;
@property (strong, nonatomic) IBOutlet UILabel *lbTimelineID;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnJoin1;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnJoin2;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayMuffin;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMuffin;
@property (weak, nonatomic) IBOutlet EDRoundButton *btnProjectComplete;
- (id) initWithProject:(ProjectInfo *) aProject;
@property (weak, nonatomic) IBOutlet EDRoundButton *btnRegText;
@end
