//
//  EDHttpTransManager.h
//  Muffin
//
//  Created by escdream on 2018. 8. 27..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkConnect.h"
#import "NSString+Format.h"

@interface EDHttpTransManager : NSObject

+ (EDHttpTransManager *) instance;

- (void) callLoginInfo:(NSString *)sCmd  withBlack:(void(^)(id result, NSError * error))completion;
- (void) processUserInfo:(NSString *)sCmd dicParam:(NSMutableDictionary *)dicParams  withBlack:(void(^)(id result, NSError * error))completion;

- (void) callMuffinProjectList:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;
- (void) callMuffinInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;

//- (void) callProjectInfo:(NSString *)sCmd  withBlack:(void(^)(id result, NSError * error))completion;
- (void) callProjectInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;

- (void) callGroupItemInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;

- (void) callAllTimelineInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;
- (void) callTimelineInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;

- (void) callProjectCommand:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;

- (void) callBookmarkUserInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;
- (void) callBookmarkMuffinInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;

- (void) callPartAskInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion;

- (NSMutableDictionary *) getXnetBaseData;


@end
