//
//  SongInfo.h
//  Muffin
//
//  Created by escdream on 2018. 9. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject
@property (nonatomic, strong) NSString * songID;
@property (nonatomic, strong) NSString * groupID;
@property (nonatomic, strong) NSString * groupName;
@property (nonatomic, strong) NSString * songName;
@property (nonatomic, strong) NSString * musicPath;
@property (nonatomic, strong) NSString * musicFileID;
@property (nonatomic, strong) NSString * publicYN;
@property (nonatomic, assign) CGFloat MLIKE;
@property (nonatomic, strong) NSString * regDate;
@property (nonatomic, strong) NSString * progress;
@property (nonatomic, strong) NSString * songKind;
@property (nonatomic, strong) NSString * imageID;
@property (nonatomic, strong) NSString * imagePath;

@property (nonatomic, assign) BOOL bIsSelected;
@property (nonatomic, strong) UIImage * groupImage;


- (id) initWithData:(NSDictionary *) dicData;

@end
