//
//  UserOtherViewController.h
//  Muffin
//
//  Created by escdream on 2018. 11. 10..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDRoundView.h"
#import "ProjectInfo.h"
#import "BookMarkUser.h"

@interface UserOtherViewController : EDBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)  ProjectInfo * project;
@property (strong, nonatomic)  BookmarkUser * BMUser;
@property (strong, nonatomic) IBOutlet UILabel *lbUserId;

@property (strong, nonatomic) IBOutlet EDRoundView *viewRound1;
@property (strong, nonatomic) IBOutlet EDRoundView *viewRound2;
@property (strong, nonatomic) IBOutlet EDRoundView *viewRound3;
@property (strong, nonatomic) IBOutlet UILabel *lbTotal;
@property (strong, nonatomic) IBOutlet UILabel *lbWorking;
@property (strong, nonatomic) IBOutlet UILabel *lbComplete;
@property (strong, nonatomic) IBOutlet UITableView *tblProjectList;

- (id) initWithProject:(ProjectInfo *) aProject;
- (id) initWithBMUser:(BookmarkUser *) aBMUser;
@end
