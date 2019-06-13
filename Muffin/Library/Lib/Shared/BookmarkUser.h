//
//  BookmarkUser.h
//  Muffin
//
//  Created by escdream on 2018. 9. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookmarkUser : NSObject
@property (nonatomic, strong) NSString * BMUserId;
@property (nonatomic, strong) NSString * UserId;
@property (nonatomic, strong) NSString * BMSeq;
@property (nonatomic, strong) NSString * Username;

- (id) initWithData:(NSDictionary *) dicData;

@end


