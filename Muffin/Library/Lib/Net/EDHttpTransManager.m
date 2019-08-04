//
//  EDHttpTransManager.m
//  Muffin
//
//  Created by escdream on 2018. 8. 27..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDHttpTransManager.h"
#import "UIView+Toast.h"
@import JGProgressHUD;

static EDHttpTransManager * global_httpManager;


@implementation EDHttpTransManager
{
    JGProgressHUD *progress;
}

+ (EDHttpTransManager *) instance;
{
    if (global_httpManager == nil)
    {
        global_httpManager = [[EDHttpTransManager alloc] init];
    }
    
    return global_httpManager;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (NSMutableDictionary *) getXnetBaseData
{
    NSMutableDictionary * Params = [[NSMutableDictionary alloc] init];
    
    Params[@"xnet"] = [[NSMutableDictionary alloc] init];
    
    Params[@"xnet"][@"ds"] = [[NSMutableArray alloc] init];
    Params[@"xnet"][@"tr"] = [[NSMutableDictionary alloc] init];
    Params[@"xnet"][@"tr"][@"message"] = [[NSMutableDictionary alloc] init];
    Params[@"xnet"][@"tr"][@"message"][@"trmsg"] = @"";
    Params[@"xnet"][@"tr"][@"message"][@"trcode"] = @"0";
    Params[@"xnet"][@"tr"][@"data"]    = [[NSMutableArray alloc] init];
    
    return Params;
}

- (NSMutableDictionary *) makeParamData:(NSString *)sKey  sValue:(NSString *)sValue
{
    NSMutableDictionary * pName = [[NSMutableDictionary alloc] init];
    pName[@"name"] =  [sKey encodeBase64String];
    pName[@"value"] = [sValue encodeBase64String];
    
    return pName;
}


- (void) processUserInfo:(NSString *)sCmd dicParam:(NSMutableDictionary *)dicParams  withBlack:(void(^)(id result, NSError * error))completion;
{
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.UserInfoController";

    httpHeader[@"Function"] = sCmd;
    
    
    NSArray * paramNames = [dicParams allKeys];
    for (NSString * sKeyName in paramNames)
    {
        NSString * sValue = dicParams[sKeyName];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:sKeyName sValue:sValue]];
    }
    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];

            
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            NSDictionary * ds = nil;
            if (ads.count > 0)
            {
                ds = ads[0];
            }

            if (ds != nil)
            {
                NSArray * adata = ds[@"data"];
                
                NSMutableArray * arrData = [[NSMutableArray alloc] init];
                
                NSArray * cols = ds[@"col"];
                
                for (int i=0; i<adata.count; i++)
                {
                    NSString * encData = adata[i][0];
                    NSArray * dsData = [encData componentsSeparatedByString:@","];
                    
                    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                    
                    for (int j=0; j<cols.count; j++)
                    {
                        dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                    }
                    
                    [arrData addObject:dataDic];
                    
                }

                completion(arrData, nil);
            }
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
    
}


- (void) callLoginInfo:(NSString *)sCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.UserInfoController";
    if ([sCmd isEqualToString:@""])
        httpHeader[@"Function"] = @"UserInfoAll_Select";
    else
        httpHeader[@"Function"] = @"UserInfo_Select";


    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:sCmd]];

    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            
            //
            //            NSString * encData = ds[@"data"][@"text"];
            //
            //            encData =  [encData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //            encData =  [encData stringByReplacingOccurrencesOfString:@" " withString:@""];
            //
            //            NSArray * dsData = [encData componentsSeparatedByString:@","];
            //
            //            NSLog(@"%@", dsData);
            //
            //
            //
            //
            //
            //            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            //
            //
            //            int rowCount = dsData.count / cols.count;
            //
            //
            //            for (int i=0; i<rowCount; i++)
            //            {
            //                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
            //
            //                for (int j=0; j<cols.count; j++)
            //                {
            //                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[(i*cols.count)+j] decodeBase64String];
            //                }
            //
            //                [arrData addObject:dataDic];
            //            }
            
            //
            //
            //            for (int i=0; i<dsData.count; i++)
            //            {
            //                NSString * str = dsData[i];
            //
            //                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //
            //                NSLog(@"%@", [str decodeBase64String]);
            //            }
            //
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callMuffinInfo:(NSMutableDictionary *) dicCmd withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.SongInfoController";
    if (dicCmd == nil || dicCmd.count == 0)
        httpHeader[@"Function"] = @"SongInfoAll_Select";
    else
        httpHeader[@"Function"] = dicCmd[@"Function"];
    
    if ( [dicCmd[@"Function"] isEqualToString: @"SongInfo_SelectGroup"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
    }
    else if ( [dicCmd[@"Function"] isEqualToString: @"SongInfo_Insert"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongType" sValue:dicCmd[@"SongType"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongName" sValue:dicCmd[@"SongName"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongWords" sValue:dicCmd[@"SongWords"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"MusicFileId" sValue:dicCmd[@"MusicFileId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"PublicYN" sValue:dicCmd[@"PublicYN"]]];
    }
    else if ( [dicCmd[@"Function"] isEqualToString: @"SongInfo_InsertWords"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongName" sValue:dicCmd[@"SongName"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongWords" sValue:dicCmd[@"SongWords"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"PublicYN" sValue:dicCmd[@"PublicYN"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongKind" sValue:dicCmd[@"SongKind"]]];
    }
    else if ( [dicCmd[@"Function"] isEqualToString: @"SongInfo_UpdateWords"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongId" sValue:dicCmd[@"SongId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongWords" sValue:dicCmd[@"SongWords"]]];
    }

    else if ( [dicCmd[@"Function"] isEqualToString: @"SongInfo_SelectWhere"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Type" sValue:dicCmd[@"Type"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Kind" sValue:dicCmd[@"Kind"]]];
    }
    else
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
    }
    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

//- (void)callProjectInfo:(NSString *)sCmd  withBlack:(void(^)(id result, NSError * error))completion
- (void) callProjectInfo:(NSMutableDictionary *) dicCmd withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];

/*
    httpHeader[@"Class"] = @"muffin.Service.GroupInfoController";
    if ([sCmd isEqualToString:@""])
        httpHeader[@"Function"] = @"GroupInfoAll_Select";
    else
        httpHeader[@"Function"] = @"GroupInfo_Select";
    
    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:sCmd]];
*/

    httpHeader[@"Class"] = @"muffin.Service.GroupInfoController";
    if (dicCmd == nil || dicCmd.count == 0)
        httpHeader[@"Function"] = @"GroupInfoAll_Select";
    else
        httpHeader[@"Function"] = dicCmd[@"Function"];
    
    if( [dicCmd[@"Function"] isEqualToString: @"GroupInfo_Select"] )
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
    else
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];

    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            

            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callGroupItemInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.GroupItemController";
    if (dicCmd == nil || dicCmd.count == 0)
        httpHeader[@"Function"] = @"GroupItemAll_Select";
    else
        httpHeader[@"Function"] = dicCmd[@"Function"];
    
    if ( [dicCmd[@"Function"] isEqualToString: @"GroupItem_InsertAdmin"] ||
         [dicCmd[@"Function"] isEqualToString: @"GroupItem_Insert"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Position" sValue:dicCmd[@"Position"]]];
    }
    else
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
    }
    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callTimelineInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.TimeLineController";
    if (dicCmd == nil || dicCmd.count == 0)
        httpHeader[@"Function"] = @"GroupItemAll_Select";
    else
        httpHeader[@"Function"] = dicCmd[@"Function"];
    
    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Message" sValue:dicCmd[@"Message"]]];

    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callAllTimelineInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.AllTimeLineController";
    if (dicCmd == nil || dicCmd.count == 0)
        httpHeader[@"Function"] = @"GroupItemAll_Select";
    else
        httpHeader[@"Function"] = dicCmd[@"Function"];
    
    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
    [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Message" sValue:dicCmd[@"Message"]]];
    
    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callProjectCommand:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.GroupInfoController";
    httpHeader[@"Function"] = dicCmd[@"Function"];
    
    if ([dicCmd[@"Function"] isEqualToString: @"GroupInfo_LastSelect"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupName" sValue:dicCmd[@"GroupName"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupKind" sValue:dicCmd[@"GroupKind"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"ImageId" sValue:dicCmd[@"ImageId"]]];
    }
    else if ([dicCmd[@"Function"] isEqualToString: @"GroupInfoProgress_Update"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Progress" sValue:dicCmd[@"Progress"]]];
    }
    else
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupName" sValue:dicCmd[@"GroupName"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupKind" sValue:dicCmd[@"GroupKind"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"ImageId" sValue:dicCmd[@"ImageId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SystemId" sValue:dicCmd[@"SystemId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupDesc" sValue:dicCmd[@"GroupDesc"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Tag1" sValue:dicCmd[@"Tag1"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Tag2" sValue:dicCmd[@"Tag2"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Tag3" sValue:dicCmd[@"Tag3"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Tag4" sValue:dicCmd[@"Tag4"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Tag5" sValue:dicCmd[@"Tag5"]]];
    }
        

    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callBookmarkUserInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.BookMarkUserController";
    httpHeader[@"Function"] = dicCmd[@"Function"];

    if ( [dicCmd[@"Function"] isEqualToString: @"BookMarkUser_Insert"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"BMUserId" sValue:dicCmd[@"BMUserId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Username" sValue:dicCmd[@"Username"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"BMSEQ" sValue:dicCmd[@"BMSEQ"]]];
    }
    else if ( [dicCmd[@"Function"] isEqualToString: @"BookMarkUser_Select"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
    }
    else if ( [dicCmd[@"Function"] isEqualToString: @"SongItemAll_Select"])
    {
        
    }
    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callBookmarkMuffinInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.BookMarkMuffinController";
    httpHeader[@"Function"] = dicCmd[@"Function"];
    
    if ( [dicCmd[@"Function"] isEqualToString: @"BookMarkMuffin_Insert"] )
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"BMSongId" sValue:dicCmd[@"BMSongId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"SongName" sValue:dicCmd[@"SongName"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"MusicPath" sValue:dicCmd[@"MusicPath"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"MusicFileId" sValue:dicCmd[@"MusicFileId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"BMSeq" sValue:dicCmd[@"BMSEQ"]]];
    }
    else if ( [dicCmd[@"Function"] isEqualToString: @"BookMarkMuffin_Select"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
    }
    else
    {
        
    }
    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

- (void) callPartAskInfo:(NSMutableDictionary *) dicCmd  withBlack:(void(^)(id result, NSError * error))completion
{
    
    NSMutableDictionary * Params = [self getXnetBaseData];
    NSMutableDictionary * httpHeader = [[NSMutableDictionary alloc] init];
    
    httpHeader[@"Class"] = @"muffin.Service.PartAskController";
    if (dicCmd == nil || dicCmd.count == 0)
        httpHeader[@"Function"] = @"PartAskAll_Select";
    else
        httpHeader[@"Function"] = dicCmd[@"Function"];
    
    if ([dicCmd[@"Function"] isEqualToString: @"PartAsk_SelectUser"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
    }
    else if ([dicCmd[@"Function"] isEqualToString: @"PartAsk_Insert"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"ReqMessage" sValue:dicCmd[@"ReqMessage"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"RespMessage" sValue:dicCmd[@"RespMessage"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"AskType" sValue:dicCmd[@"AskType"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"FileName" sValue:dicCmd[@"FileName"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"FilePath" sValue:dicCmd[@"FilePath"]]];
    }
    else if ([dicCmd[@"Function"] isEqualToString: @"PartAsk_UpdateProgress"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"Progress" sValue:dicCmd[@"Progress"]]];
    }
    else if ([dicCmd[@"Function"] isEqualToString: @"PartAsk_Delete"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"UserId" sValue:dicCmd[@"UserId"]]];
    }
    else if ([dicCmd[@"Function"] isEqualToString: @"PartAsk_Select"])
    {
        [Params[@"xnet"][@"tr"][@"data"] addObject:[self makeParamData:@"GroupId" sValue:dicCmd[@"GroupId"]]];
    }
    else
    {
        //
    }
    
    NSURL *URL = [NSURL URLWithString:@"http://ourworld3.cafe24.com/data/servlet/FrontService"];
    [AFNetworkConnect callAsyncHTTPWithHeader:URL.absoluteString param:Params headers:httpHeader withBlock:^(id result, NSError *error) {
        
        if( result != nil )
        {
            
            NSDictionary * returnDic = (NSDictionary *)result;
            
            NSArray * ads = returnDic[@"xnet"][@"ds"];
            NSDictionary * ds = ads[0];
            
            
            NSString * sMsg = returnDic[@"xnet"][@"tr"][@"message"][@"trmsg"];
            
            if (![sMsg isEqualToString:@""] && sMsg != nil)
            {
                UIWindow *window = UIApplication.sharedApplication.delegate.window;
                [window.rootViewController.view makeToast:[sMsg decodeBase64String]];
            }
            NSLog(@"msg = %@", [sMsg decodeBase64String]);
            
            
            NSArray * adata = ds[@"data"];
            
            
            NSMutableArray * arrData = [[NSMutableArray alloc] init];
            
            NSArray * cols = ds[@"col"];
            
            for (int i=0; i<adata.count; i++)
            {
                NSString * encData = adata[i][0];
                NSArray * dsData = [encData componentsSeparatedByString:@","];
                
                NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
                
                for (int j=0; j<cols.count; j++)
                {
                    dataDic[[cols[j][@"nm"] trim] ] = [dsData[j] decodeBase64String];
                }
                
                [arrData addObject:dataDic];
                
            }
            
            completion(arrData, nil);
        }
        else
        {
            completion(nil, error);
            NSLog(@"Token Error %@", error);
        }
    }];
}

@end
