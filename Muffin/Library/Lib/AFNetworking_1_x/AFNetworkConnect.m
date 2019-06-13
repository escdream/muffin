//
//  AFNetworkConnect.m
//  OneShotpadForMeritzStockSample
//
//  Created by Min joungKim on 2016. 7. 12..
//  Copyright © 2016년 rowem. All rights reserved.
//

#import "AFNetworkConnect.h"
#import "AFHTTPClient+Synchronous.h"
#import "AFHTTPRequestOperation.h"
#import "XMLReaderEx.h"


@implementation AFNetworkConnect


+ (void)callAsyncHTTP:(NSString *)path param:(NSMutableDictionary *)params withBlock:(void(^)(id result, NSError *error))completion
{
    
    //#ifdef DEBUG
    NSLog(@"request api  : %@", path);
    NSLog(@"request param: %@", params);
    //#endif
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    httpClient.allowsInvalidSSLCertificate = YES;
    httpClient.defaultSSLPinningMode = AFSSLPinningModeCertificate;
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:path
                                                      parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
        // Print the response body in text
        NSData *data = (NSData *) responseObject;
        
        if( data == nil )
        {
            completion(nil, nil);
            return;
        }
        
        //#ifdef DEBUG
        NSString *receivedDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data : %@", receivedDataString);
        //#endif
        NSError* error;
        
        //        operation.request.URL.absoluteString
        
        
        NSData *requestParam = operation.request.HTTPBody;
        NSDictionary* jsonRequestDict = [NSJSONSerialization JSONObjectWithData:requestParam options:kNilOptions error:&error];
        //NSString *requestParamString = [[NSString alloc] initWithData:requestParam encoding:NSUTF8StringEncoding];
        
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        
        completion(jsonDict, nil);
        
        
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                         
                                         completion(nil, error);
                                         
                                         
                                     }];
    
    [operation start];
    
    
    
}


+ (void)callAsyncHTTPWithHeader:(NSString *)path param:(NSMutableDictionary *)params headers:(NSMutableDictionary *)headers  withBlock:(void(^)(id result, NSError *error))completion
{
    
    //#ifdef DEBUG
    NSLog(@"request api  : %@", path);
    NSLog(@"request param: %@", params);
    //#endif
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    httpClient.allowsInvalidSSLCertificate = YES;
    //    httpClient.defaultSSLPinningMode = AFSSLPinningModeCertificate;
    
    NSArray * keys = headers.allKeys;
    for (NSString * key in keys)
    {
        [httpClient setDefaultHeader:key value:headers[key]];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:path
                                                      parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
        // Print the response body in text
        NSData *data = (NSData *) responseObject;
        
        if( data == nil )
        {
            completion(nil, nil);
            return;
        }
        
        //#ifdef DEBUG
        

        
        
        @try {

        NSString *receivedDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
        NSString *size = [receivedDataString substringWithRange:NSMakeRange(0,10)];
        NSString *sBody = [receivedDataString substringWithRange:NSMakeRange(10, receivedDataString.length - 10)];
            
        if ([receivedDataString hasPrefix:@"{"])
            sBody = [receivedDataString copy];
            
//        NSLog(@"data : %@", sBody);
        //#endif
        NSError* error;
        
        //        operation.request.URL.absoluteString
        
        
        NSData *requestParam = operation.request.HTTPBody;
        NSDictionary* jsonRequestDict = [NSJSONSerialization JSONObjectWithData:requestParam options:kNilOptions error:&error];
        //NSString *requestParamString = [[NSString alloc] initWithData:requestParam encoding:NSUTF8StringEncoding];
        
        NSData * dBody =  [sBody dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *parseError = nil;
//        NSDictionary *jsonDict =  [XMLReaderEx dictionaryForXMLString:sBody error:parseError];
//        NSLog(@" %@", jsonDict);
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:dBody options:kNilOptions error:&error];
        
        
            completion(jsonDict, nil);

        } @catch (NSException *exception) {
            completion(nil, nil);
        } @finally {
        }
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error){
        completion(nil, error);
    }];
    
    [operation start];
}



@end
