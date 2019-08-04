//
//  BannerViewController.m
//  Muffin
//
//  Created by escdream on 2018. 11. 10..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "BannerViewController.h"
#import "BannerItem.h"
#import "EDRoundView.h"
#import "CommonUtil.h"
#import "BannerTableViewCell.h"

@interface BannerViewController ()
{
    NSMutableArray * arrBanner;
}
@end

@implementation BannerViewController



- (void) initLayout
{

    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrBanner = [[NSMutableArray alloc] init];
    
    BannerItem * item = [[BannerItem alloc] init];
    item.title = @"올리브영";
    item.contents = @"올리브영 데이~18주는 기념 세일";
    item.point = 1000;
    item.imageName = @"banner_smp_01.png";
    [arrBanner addObject:item];

    item = [[BannerItem alloc] init];
    item.title = @"올리브영";
    item.contents = @"올리브영 데이~18주는 기념 세일";
    item.point = 1000;
    item.imageName = @"banner_smp_02.png";
    [arrBanner addObject:item];

    item = [[BannerItem alloc] init];
    item.title = @"올리브영";
    item.contents = @"올리브영 데이~18주는 기념 세일";
    item.point = 1000;
    item.imageName = @"banner_smp_03.png";
    [arrBanner addObject:item];


    CGRect r = _scrollClient.frame;
    CGRect br = r;
    
    for (int i=0; i<arrBanner.count; i++)
    {
        
        EDRoundView * banner = [[EDRoundView alloc] init];
        banner.radius = 10;
        br = CGRectMake(10, 10, r.size.width-20, (r.size.width-20) * 0.714);
        banner.frame  = br;
        
        UIImageView * img = [[UIImageView alloc] init];
        img.frame = banner.bounds;
        
        [banner addSubview:img];
        
        [_scrollClient addSubview:banner];
    }
    
    _tblBanner.rowHeight = 250;
    [ _tblBanner registerNib:[UINib nibWithNibName:@"BannerTableViewCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    
    [_tblBanner setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 249;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrBanner.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *myIdentifier = @"BannerCell";
    
    BannerTableViewCell *cell = (BannerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myIdentifier];

    BannerItem * item = (BannerItem *)arrBanner[indexPath.row];
    
    CGRect r = cell.frame;
    
    r.size.width = tableView.frame.size.width;
    cell.frame = r;
    [cell setBannerImage:item.imageName];
    [cell setPoint:item.point];
    [cell setLbTitle:item.contents];
    
    
    
    

        
//    cell.lbTitle.text = [NSString stringWithFormat:@"Test Row:%i!",indexPath.row];
    return cell;
}

@end
