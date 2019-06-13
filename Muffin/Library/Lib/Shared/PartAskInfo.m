//
//  PartAskInfo.m
//  Muffin
//
//  Created by escdream on 2018. 9. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "PartAskInfo.h"

@implementation PartAskInfo

- (id) initWithData:(NSDictionary *) dicData
{
    self = [super init];
    
    if (self)
    {
        
        self.groupID = dicData[@"GroupId"];
        self.userID = dicData[@"UserId"];
        self.reqMessage = dicData[@"ReqMessage"];
        self.resMessage = dicData[@"ResMessage"];
        self.progress = dicData[@"Progress"];
        self.askType = dicData[@"AskType"];
        self.fileName = dicData[@"FileName"];
        self.filePath = dicData[@"FilePath"];
        
    }
    
    return self;
}
@end
