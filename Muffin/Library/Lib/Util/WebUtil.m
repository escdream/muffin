//
//  WebUtil.m
//  SmartVIGS
//
//  Created by Kim juyoung on 11. 11. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebUtil.h"
#import "CommonFileUtil.h"

@implementation WebUtil

+(NSString*) getStringURL:(NSString*)strType
{
    NSString *strFileContents = [CommonFileUtil getSystemFilePath:@"weburl.dat"];
    // NSLog(@"웹데이터 내용 %@" , strFileContents);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:strFileContents])
    {
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:strFileContents];
        NSString *strfileData = [[NSString alloc] initWithData:fileData encoding:0x80000000 + kCFStringEncodingDOSKorean];
        NSArray *ArrayString =  [strfileData componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for (NSString *string in ArrayString) {
            NSRange range = [string rangeOfString:strType];
            if (range.location != NSNotFound)
            {
                NSRange rangeURL = [string rangeOfString:@"="];
                NSString *strURL = [string substringFromIndex:rangeURL.location+1];
                
                if (strURL != nil || [strURL isEqualToString:@""] == NO) return strURL;
                
//                NSArray *Arrinfo = [string componentsSeparatedByString:@"="];
//                if ([Arrinfo count] == 2) {
//                    return [Arrinfo objectAtIndex:1];
//                }                 
            }
        }
    }
    else
    {
        // NSLog(@"weburl.dat 파일을 찾을 수 없습니다.");
    }
    
    
    return @"";
}

+(NSURL*)getHttpUtrlFromWeburlInfile:(NSString*)strType
{
    NSURL *URL = [NSURL URLWithString:[@"http://" stringByAppendingString:[self getStringURL:strType]]];
    return URL;
}



@end
