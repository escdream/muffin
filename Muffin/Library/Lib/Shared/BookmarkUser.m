//
//  BookmarkUser.m
//  Muffin
//
//  Created by escdream on 2018. 9. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "BookmarkUser.h"

@implementation BookmarkUser

- (id) initWithData:(NSDictionary *) dicData
{
    self = [super init];
    
    if (self)
    {
        
        self.BMUserId = dicData[@"BMUserId"];
        self.UserId = dicData[@"UserId"];
        self.BMSeq = dicData[@"BMSeq"];
        self.Username = dicData[@"Username"];
        
    }
    
    return self;
}


@end
