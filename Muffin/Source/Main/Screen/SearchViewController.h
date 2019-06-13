//
//  SearchViewController.h
//  Muffin
//
//  Created by escdream on 2018. 9. 5..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDTabstyleView.h"
#import "STKAudioPlayer.h"
#import "UserInfoViewController.h"

@interface SearchViewController : EDBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * tblResultHot;
    UITableView * tblResultNew;
    UITableView * tblResultAll;
    
    NSMutableArray * arrHot;
    NSMutableArray * arrNew;
    NSMutableArray * arrAll;
    
    UIButton * mButton;
}

@property (strong, nonatomic) IBOutlet EDTabstyleView *tabResult;
@property (strong, nonatomic) IBOutlet UIView *viewSearch;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIView *viewGanre;
@property (strong, nonatomic) IBOutlet UIView *viewTabs;
@property (nonatomic, assign) NSString *viewType;


@end
