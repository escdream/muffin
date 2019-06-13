//
//  SongInfo.m
//  Muffin
//
//  Created by escdream on 2018. 9. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "SongInfo.h"

@implementation SongInfo

- (id) initWithData:(NSDictionary *) dicData
{
    self = [super init];
    
    if (self)
    {
        
        self.songID = dicData[@"SongId"];
        self.groupID = dicData[@"GroupId"];
        self.groupName = dicData[@"GroupName"];
        self.songName = dicData[@"SongName"];
        self.musicPath = dicData[@"MusicPath"];
        self.musicFileID = dicData[@"MusicFileId"];
        self.publicYN = dicData[@"PublicYN"];
//        self.MLIKE = dicData[@"MLIKE"]; // --> 확인필요
        self.regDate = dicData[@"RegDate"];
        self.progress = dicData[@"Progress"];
        
    }
    
    return self;
}

@end
