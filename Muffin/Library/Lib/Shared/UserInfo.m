//
//  UserInfo.m
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "UserInfo.h"


static UserInfo * m_UserInfo;
@implementation UserInfo

+ (UserInfo *) instance
{
    if (m_UserInfo == nil)
    {
        m_UserInfo = [[UserInfo alloc] init];
    }
    
    return m_UserInfo;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self resetUserInfo];
    }
    
    return self;
}

- (void) userLogout
{
    [self resetUserInfo];
}


- (BOOL) isUserLogin
{
    return _userLoginState > UserInfoStateNone;
}

- (void) resetUserInfo
{
    _userID = @"";
    _userName = @"";
    _userEmail = @"";
    _userSex = @"";
    _userName = @"";
    _userImagePath = @"";
    _userImageID = @"";
    _userPW = @"";
    _userLevel = -1;
    _userLoginState = UserInfoStateNone;
    _muffinPoint = 0;

//    _userID = @"max";
//    _userName = @"나야나!!";
//    _userEmail = @"email@gmail.com";
//    _userSex = @"1";
//    _userName = @"아무개";
//    _userImageID = @"";
//    _userPW = @"1111";
//    _userLevel = 0;
//    _userLoginState = UserInfoStateNormal;
//    _muffinPoint = 1627;

//    _userImage = [UIImage imageNamed:@"user_pho_smp_02.png"];

}

@end
