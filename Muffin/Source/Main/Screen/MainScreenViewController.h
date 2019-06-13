//
//  MainScreenViewController.h
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDRoundView.h"
#import "KeyboardManager.h"
#import "EDTabstyleView.h"
@interface MainScreenViewController : EDBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    
    KeyboardManager * m_keyboardManager;
}
@property (weak, nonatomic) IBOutlet UILabel *lbID;

@property (weak, nonatomic) IBOutlet UILabel *lbPoint;
@property (weak, nonatomic) IBOutlet UITableView *tblInfoList; 

@property (weak, nonatomic) IBOutlet EDRoundView *viewUserInfo;
@property (weak, nonatomic) IBOutlet EDTabstyleView *viewTabs;

@end
