//
//  UserInfo.h
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserInfo : NSObject

@property (nonatomic, strong) NSString * userID;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userSex;
@property (nonatomic, strong) NSString * userPW;
@property (nonatomic, strong) NSString * userNickName;
@property (nonatomic, strong) NSString * userImagePath;
@property (nonatomic, strong) NSString * userImageID;
@property (nonatomic, strong) NSString * userEmail;
@property (nonatomic, assign) int        userLevel;
@property (nonatomic, assign) MuffineUserLoginState   userLoginState;
@property (nonatomic, strong) UIImage * faceBookImage;
@property (nonatomic, strong) NSString * faceBookEmail;
@property (nonatomic, strong) UIImage * userImage;

@property (nonatomic, assign) int muffinPoint;

+ (UserInfo *) instance;

- (void) userLogout;


- (BOOL) isUserLogin;
- (void) resetUserInfo;
@end
