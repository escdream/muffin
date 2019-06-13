// AFHTTPClient+Synchronous.m
//
// Copyright (c) 2013 Paul Melnikow
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPClient+Synchronous.h"
#import "AFHTTPRequestOperation+ResponseObject.h"

@class WebConnect;

NSString * const AFHTTPClientErrorDomain = @"com.alamofire.httpclient";
NSInteger const AFHTTPClientBackgroundTaskExpiredError = -1001;

@implementation AFHTTPClient (Synchronous)

- (id)synchronouslyPerformMethod:(NSString *)method
                            path:(NSString *)path
                      parameters:(NSDictionary *)parameters
                       operation:(AFHTTPRequestOperation *__autoreleasing *)operationPtr
                           error:(NSError *__autoreleasing *)outError
{
    NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
//    NSLog(@"%@", request.allHTTPHeaderFields);

    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:request success:nil failure:nil];
    

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    // By registering the operation as a long-running background task, if the app enters
    // background, it is more likely to complete. However, it does not guarantee that the
    // method will return.
    //
    // When a background task is about to run out of time, the expiration handler is run
    // on the main queue.
    //
    // Using this feature while blocking the main thread causes a deadlock. Then the
    // operation never gets to call `endBackgroundTask:` and the system terminates the
    // app. Refer to the docs for
    // `-[AFURLConnectionOperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:`
    // and `-[NSOperation beginBackgroundTaskWithExpirationHandler:]`
    
    if (![NSThread isMainThread]) {
        [op setShouldExecuteAsBackgroundTaskWithExpirationHandler:^(void) {
            if (outError) *outError =
                [NSError errorWithDomain:AFHTTPClientErrorDomain
                                    code:AFHTTPClientBackgroundTaskExpiredError
                                userInfo:@{ NSLocalizedDescriptionKey: @"Background operation time expired" }];
        }];
        // At this point this thread may wake up but probably isn't guaranteed to do so.
    }
#endif
    
    [op start];
    [op waitUntilFinished];
    
    if (operationPtr != nil) *operationPtr = op;
    if (outError != nil) *outError = [op error];
    return [op responseObject];
}

- (id)synchronouslyGetPath:(NSString *)path
                parameters:(NSDictionary *)parameters
                 operation:(AFHTTPRequestOperation *__autoreleasing *)operationPtr
                     error:(NSError *__autoreleasing *)outError
{
    return [self synchronouslyPerformMethod:@"GET" path:path parameters:parameters operation:operationPtr error:outError];
}

- (id)synchronouslyPostPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                  operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
                      error:(NSError *__autoreleasing *) outError
{
    NSData *data = [self synchronouslyPerformMethod:@"POST" path:path parameters:parameters operation:operationPtr error:outError];
    NSString *receivedDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data : %@", receivedDataString);
    if( data == nil )
    {
        return nil;
    }
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    
    if( json == nil )
    {
        json = [self serverReqXMLParsing:data];
    }
    
    if( json )
    {
        id data = [json objectForKey:@"WARNING"];
        if( data )
        {
            id errorCode = [data objectForKey:@"errorCode"];
            id msg = [data objectForKey:@"msg"];
            
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            [dicM setObject:[errorCode objectForKey:@"@value"] forKey:@"resCode"];
            [dicM setObject:[msg objectForKey:@"@value"] forKey:@"resMsg"];
            
            return dicM;
        }
    }
    
    return json;
}

- (id)synchronouslyPutPath:(NSString *)path
                parameters:(NSDictionary *)parameters
                 operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
                     error:(NSError *__autoreleasing *) outError
{
    return [self synchronouslyPerformMethod:@"PUT" path:path parameters:parameters operation:operationPtr error:outError];
}

- (id)synchronouslyDeletePath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                    operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
                        error:(NSError *__autoreleasing *) outError
{
    return [self synchronouslyPerformMethod:@"DELETE" path:path parameters:parameters operation:operationPtr error:outError];
}

- (id)synchronouslyPatchPath:(NSString *)path
                  parameters:(NSDictionary *)parameters
                   operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
                       error:(NSError *__autoreleasing *) outError
{
    return [self synchronouslyPerformMethod:@"PATCH" path:path parameters:parameters operation:operationPtr error:outError];
}

- (NSDictionary*) serverReqXMLParsing:(NSData*)rquest
{
//    NSData *resultData = rquest;
    
    NSError *parsingError = nil;
    NSDictionary *xmlData ;//= [SP_XMLReader dictionaryForXMLData:resultData error:&parsingError];
    
    if (parsingError) {
        NSLog(@"error : %@", parsingError.localizedDescription);
        //return jsonDic;
    }
    
    NSLog(@"xmlData : %@" , xmlData);
    
    return xmlData;
}
@end
