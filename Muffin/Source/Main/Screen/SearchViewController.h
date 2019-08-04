//
//  SearchViewController.h
//  Muffin
//
//  Created by escdream on 2018. 9. 5..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDTabstyleView.h"
#import "UserInfoViewController.h"
#import "EDRoundButton.h"

@interface SearchViewController : EDBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * tblResultHot;
    UITableView * tblResultNew;
    UITableView * tblResultAll;
    
    UITableView * tblSearch;
    
    NSMutableArray * arrHot;
    NSMutableArray * arrNew;
    NSMutableArray * arrAll;
    
    NSMutableArray * arrSearch;
    
    UIButton * mButton;
}

@property (strong, nonatomic) IBOutlet EDTabstyleView *tabResult;
@property (strong, nonatomic) IBOutlet UIView *viewSearch;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIView *viewGanre;
@property (strong, nonatomic) IBOutlet UIView *viewTabs;
@property (nonatomic, assign) NSString *viewType;

@property (strong, nonatomic) IBOutlet EDRoundButton *btnSearchCase1;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSearchCase2;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSearchCase3;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSearchCase4;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSearchCase5;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSearchCase6;

@end
