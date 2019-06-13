//
//  GroupInfo.h
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfo : NSObject
@property (nonatomic, strong) NSString * groupID;
@property (nonatomic, strong) NSString * groupName;
@property (nonatomic, strong) NSString * groupKind;
@property (nonatomic, strong) NSString * imageID;
@property (nonatomic, strong) NSString * systemID;
@property (nonatomic, strong) NSString * groupDesc;
@property (nonatomic, assign) CGFloat MLIKE;

@end
