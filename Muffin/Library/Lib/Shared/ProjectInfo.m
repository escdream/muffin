//
//  ProjectInfo.m
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "ProjectInfo.h"

@implementation ProjectInfo

- (id) initWithData:(NSDictionary *) dicData
{
    self = [super init];
    
    if (self)
    {
        
        self.projectID = dicData[@"GroupId"];
        self.projectName = dicData[@"GroupName"];
        self.projectKind = dicData[@"GroupKind"];
        self.projectCnte = dicData[@"GroupDesc"];
        self.imageId = dicData[@"ImageId"];
        self.systemId = dicData[@"SystemId"];
        self.Tag1 = dicData[@"TAG1"];
        self.Tag2 = dicData[@"TAG2"];
        self.Tag3 = dicData[@"TAG3"];
        self.Tag4 = dicData[@"TAG4"];
        self.Tag5 = dicData[@"TAG5"];

    }
    
    return self;
}


@end
