//
//  MainHomeViewController.h
//  Muffin
//
//  Created by JoonHo Kang on 26/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDTabstyleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainHomeViewController : EDBaseViewController
{
    UITableView * tblResultHot;
    UITableView * tblResultNew;
    UITableView * tblResultAll;
    
    NSMutableArray * arrHot;
    NSMutableArray * arrNew;
    NSMutableArray * arrAll;
}

@property (weak, nonatomic) IBOutlet EDTabstyleView *tabResult;

@end

NS_ASSUME_NONNULL_END
