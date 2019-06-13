//  Created by blueherald@naver.com on 13. 9. 26..
//  Copyright (c) 2013년 MyCAP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebView;
@class WebFrame;

@interface UIWebView (JavaScript)

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
- (NSString *)webView:(WebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WebFrame *)frame;
- (BOOL)webView:(WebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;

@end
