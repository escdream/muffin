//
//  PartAskInfo.h
//  Muffin
//
//  Created by escdream on 2018. 9. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartAskInfo : NSObject
@property (nonatomic, strong) NSString * groupID;
@property (nonatomic, strong) NSString * userID;
//@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * reqMessage;
@property (nonatomic, strong) NSString * resMessage;
@property (nonatomic, strong) NSString * progress;
@property (nonatomic, strong) NSString * askType;
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, strong) NSString * filePath;
@property (nonatomic, strong) NSDate * modeData;
@property (nonatomic, strong) NSDate * regData;

- (id) initWithData:(NSDictionary *) dicData;
@end
