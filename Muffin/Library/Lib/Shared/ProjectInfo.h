//
//  ProjectInfo.h
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectInfo : NSObject
@property (nonatomic, strong) NSString * projectID;
@property (nonatomic, strong) NSString * groupID;
@property (nonatomic, strong) NSString * projectName;
@property (nonatomic, strong) NSString * projectCnte;
@property (nonatomic, strong) NSString * projectKind;
@property (nonatomic, strong) NSString * songWriteID;
@property (nonatomic, strong) NSString * songWriteName;
@property (nonatomic, strong) NSString * songMusicID;
@property (nonatomic, strong) NSString * songMusicName;
@property (nonatomic, strong) NSString * MusicFileID;
@property (nonatomic, strong) NSString * WorkCnte; // 내용
@property (nonatomic, strong) NSString * progress;
@property (nonatomic, strong) NSString * publicYN;
@property (nonatomic, strong) NSString * imageId;
@property (nonatomic, strong) NSString * systemId;
@property (nonatomic, strong) NSString * MLIKE;
@property (nonatomic, strong) NSString * UseYN;
@property (nonatomic, strong) NSString * Tag1;
@property (nonatomic, strong) NSString * Tag2;
@property (nonatomic, strong) NSString * Tag3;
@property (nonatomic, strong) NSString * Tag4;
@property (nonatomic, strong) NSString * Tag5;
@property (nonatomic, strong) NSString * PUpdate;
@property (nonatomic, strong) NSString * RegDate;

- (id) initWithData:(NSDictionary *) dicData;


@end
