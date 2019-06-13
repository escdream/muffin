//
//  TagCollectonViewController.m
//  Muffin
//
//  Created by escdream on 2018. 11. 11..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "TagCollectonViewController.h"
#import "ResourceManager.h"
#import "CommonUtil.h"

@interface TagCollectonViewController ()
{
    NSMutableArray * arrJanre;
    NSMutableArray * arrAkgi;
    NSMutableArray * arrTag;
}


@end

@implementation TagCollectonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _viewJanre.titleText.text = @"장르";
    _viewAkgi.titleText.text = @"악기";
    _viewTag.titleText.text = @"Tag";
    
    _viewJanre.dataSource = self;
    _viewJanre.delegate = self;
    
    arrJanre = [[NSMutableArray alloc] init];
    [arrJanre addObject:@"전체"];
    [arrJanre addObject:@"발라드"];
    [arrJanre addObject:@"댄스"];
    [arrJanre addObject:@"팝"];
    [arrJanre addObject:@"전체"];
    [arrJanre addObject:@"발라드"];
    [arrJanre addObject:@"댄스"];
    [arrJanre addObject:@"전체"];
    [arrJanre addObject:@"발라드"];
    [arrJanre addObject:@"댄스"];
    [arrJanre addObject:@"팝"];
    [arrJanre addObject:@"전체"];
    [arrJanre addObject:@"발라드"];
    [arrJanre addObject:@"댄스"];
    [arrJanre addObject:@"전체"];
    [arrJanre addObject:@"발라드"];
    [arrJanre addObject:@"댄스"];
    [arrJanre addObject:@"팝"];
    [arrJanre addObject:@"전체"];
    [arrJanre addObject:@"발라드"];
    [arrJanre addObject:@"댄스"];

    _viewJanre.autoHeight = YES;
    [_viewJanre setViewOnly:YES];
    _viewJanre.textField.hidden = YES;
    _viewJanre.showTitleText = YES;
    
    arrAkgi = [[NSMutableArray alloc] init];
    [arrAkgi addObject:@"전체"];
    [arrAkgi addObject:@"피아노"];
    [arrAkgi addObject:@"기타(클래식)"];
    [arrAkgi addObject:@"기타(일렉)"];
    [arrAkgi addObject:@"기타(재즈)"];
    [arrAkgi addObject:@"드럼"];
    [arrAkgi addObject:@"타악기"];
    [arrAkgi addObject:@"금관악기"];
    [arrAkgi addObject:@"목관악기"];
    [arrAkgi addObject:@"현악기"];
    _viewAkgi.dataSource = self;
    _viewAkgi.delegate = self;
    _viewAkgi.autoHeight = YES;
    [_viewAkgi setViewOnly:YES];
    _viewAkgi.textField.hidden = YES;
    _viewAkgi.showTitleText = YES;
    
    arrTag = [[NSMutableArray alloc] init];
    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];
    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];
    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];
    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];
    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];
    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];
    [arrTag addObject:@"#롹"];
    [arrTag addObject:@"#발라드"];
    [arrTag addObject:@"#레게"];
    [arrTag addObject:@"#아무거나"];
    [arrTag addObject:@"#이런"];
    
    _viewTag.dataSource = self;
    _viewTag.delegate = self;
    _viewTag.autoHeight = YES;
    [_viewTag setViewOnly:YES];
    _viewTag.textField.hidden = YES;
    _viewTag.showTitleText = YES;
    
    
    CGSize sz = CGSizeMake(30, 30);
    
    UIImage * onImage = [CommonUtil getLocalImageWithSize:sz  filename:@"btn_on.png"] ;
    UIImage * offImage = [CommonUtil getLocalImageWithSize:sz filename:@"btn_off.png" ] ;
    
    [_btnRadio1 setImage:offImage forState:UIControlStateNormal];
    [_btnRadio1 setImage:onImage  forState:UIControlStateSelected];
    
    _btnRadio1.selected = YES;
    
    [_btnRadio2 setImage:offImage forState:UIControlStateNormal];
    [_btnRadio2 setImage:onImage  forState:UIControlStateSelected];

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

- (void) setCurrentButton:(long) currentGanre
{
    
    NSMutableArray * arrButtons = [[NSMutableArray alloc] init];
    [arrButtons addObject:_btnSelect1];
    [arrButtons addObject:_btnSelect2];
    [arrButtons addObject:_btnSelect3];

    for (int i=0; i<arrButtons.count; i++)
    {
        UIButton * btn = arrButtons[i];
        btn.selected = (btn.tag == currentGanre);
        NSLog(@"%d  %d", btn.tag, btn.selected);
        
        if (btn.selected)
            btn.backgroundColor = RGB(0x36, 0x1f, 0x69);
        else
            btn.backgroundColor = RGB(242, 242, 242);
    }
}

- (IBAction)onClickRadio:(id)sender {
    
    UIButton * btn = sender;
    
    switch (btn.tag)
    {
        case 101 :
            {
                _btnRadio1.selected = YES;
                _btnRadio2.selected = NO;
                break;
            };
        case 102 :
            {
                _btnRadio1.selected = NO;
                _btnRadio2.selected = YES;
                break;
            };
        case 201 :
            {
                [self setCurrentButton:201];
                break;
            };
        case 202 :
            {
                [self setCurrentButton:202];

                break;
            };
        case 203 :
            {
                [self setCurrentButton:203];

                break;
            };
    }

    
}



- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    if (tokenField == _viewTag)
        return 20;
    else
        return 30;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    
    if (tokenField == _viewJanre)
        return arrJanre.count;
    if (tokenField == _viewAkgi)
        return arrAkgi.count;
    if (tokenField == _viewTag)
        return arrTag.count;
    return 0;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{

    NSMutableArray * tokens = arrJanre;

    if (tokenField == _viewAkgi)
        tokens = arrAkgi;
    else if (tokenField == _viewTag)
        tokens = arrTag;

    EDRoundView * view = [[EDRoundView alloc] init];
    if (tokenField == _viewTag)
    {
        view.radius = 10;
        view.borderColor = RGB(0x3e, 0x3e, 0x3e);
        view.borderWidth = 1.0f;
        
        UILabel * lb = [[UILabel alloc] init];
        lb.text = tokens[index];
        CGSize size = [lb sizeThatFits:CGSizeMake(1000, 20)];
        lb.textAlignment = NSTextAlignmentCenter;
        view.frame = CGRectMake(0, 0, size.width , 20);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = view.frame;
        [btn setTitleColor:RGB(0x3e, 0x3e, 0x3e) forState:UIControlStateNormal];
        [btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
        [btn setTitle:tokens[index] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnTagClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = RGB(242, 242, 242);
        btn.titleLabel.font = [[ResourceManager sharedManager] getFontWithSize:9];
        
        [view addSubview:btn];
        view.clipsToBounds = YES;
        lb.frame = view.bounds;
    }
    else
    {
        view.radius = 15;
        view.borderColor = RGB(0x31, 0x1f, 0x69);
        view.borderWidth = 1.0f;
        
        UILabel * lb = [[UILabel alloc] init];
        lb.text = tokens[index];
        CGSize size = [lb sizeThatFits:CGSizeMake(1000, 30)];
        lb.textAlignment = NSTextAlignmentCenter;
        
        size.width = (tokenField.frame.size.width / 4) - 8;
        view.frame = CGRectMake(0, 0, size.width , 30);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = view.frame;
        [btn setTitleColor:RGB(0x31, 0x1f, 0x69) forState:UIControlStateNormal];
        [btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
        [btn setTitle:tokens[index] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnTagClick:)  forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = RGB(255, 255, 255);
        btn.titleLabel.font = [[ResourceManager sharedManager] getFontWithSize:12];
        
        [view addSubview:btn];
        view.clipsToBounds = YES;
        lb.frame = view.bounds;
    }
    return view;
}

#pragma mark - ZFTokenField Delegate

- (void) autoSizeChangeInField:(ZFTokenField *)tokenField frame:(CGRect)frame;
{
//    CGRect r = frame;
    
    CGRect sr = _viewSongType.frame;
    
    CGRect jr = _viewJanre.frame;
    
    jr.origin.y = CGRectGetMaxY(sr) + 5;
    _viewJanre.frame = jr;
    
    CGRect ar = _viewAkgi.frame;
    CGRect tr = _viewTag.frame;

    ar.origin.y = CGRectGetMaxY(jr) + 5;
    _viewAkgi.frame = ar;
    
    tr.origin.y = CGRectGetMaxY(ar) + 5;
    
    _viewTag.frame = tr;
    
    
    
    _viewScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(tr) + 10);
    
    
}

- (void) btnTagClick:(UIButton *) btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected)
        btn.backgroundColor = RGB(0x3e, 0x3e, 0x3e);
    else
        btn.backgroundColor = RGB(242, 242, 242);
}

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
{
//    [tokens addObject:text];
    [tokenField reloadData];
}

- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
//    [tokens removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return NO;
}

@end
