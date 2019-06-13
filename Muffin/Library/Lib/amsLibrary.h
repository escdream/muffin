//
//  amsLibrary.h
//  amsLibrary
//
//  Created by 안랩 on 11. 7. 15..
//  Copyright 2011 안랩. All rights reserved.
//
//--------------------------------------------------------
// version: 1.1.0.1

#import <Foundation/Foundation.h>

// JS : JB Scanner
#define JS_JAILBREAKED 210
#define JS_NORMAL 200
#define JS_KEYERROR 404


@interface amsLibrary : NSObject

@property (readonly) NSInteger timestamp; // 1.1.0.1 이후 부터 지원 됨

- (id)init;

/**
 JB Scanner를 확인하여 결과를 반환 한다.
 
 Arguments
    AuthCode: 사용 권한 인증 코드
 
 Returns
    NSInteger type
        단말기에서 구해진 현재 시간의 UNIX timestamp 값 + 확인 결과 값 (JS_JAILBREAKED, JS_NORMAL, JS_KEYERROR)
    현재 시간의 UNIX timestamp 값: NSData의 tiemIntervalSince1970
 
    확인 결과 값:
        JS_JAILBREAKED
        JS_NORMAL
        JS_KEYERROR
 
 Example #1
    amsLibrary *ams = [[amsLibrary alloc] init];
    for (int i=0; i<3; i++)
    {
        NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
        NSInteger roundedValue = round(timeInSeconds);
        //NSLog(@"Jailbreak Scan Interval : %ld" , (long)roundedValue);
     
        NSInteger a3142Result = [ams a3142:@"your auth code"];
        //NSLog(@"Jailbreak Scan Result : %ld" , (long)a3142Result);
     
        NSLog(@"Jailbreak Scan Result : %ld" , (long)(a3142Result - roundedValue));
    }
 
 Example #2
    // It support 1.1.0.1 or later
 
    amsLibrary *ams = [[amsLibrary alloc] init];
    NSInteger result = [ams a3142:@"your auth code"];
    NSInteger code = abs(result - ams.timestamp);
    if(code == JS_JAILBREAKED)
        // It's jail broken
    else if(code == JS_NORMAL)
        // It's normal device
    else if(code == JS_KEYERROR)
        // You has been entered wrong authCode
 */

- (NSInteger) a3142:(NSString *)authCode;


@end
