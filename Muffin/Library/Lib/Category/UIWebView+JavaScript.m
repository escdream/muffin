//  Created by blueherald@naver.com on 13. 9. 26..
//  Copyright (c) 2013년 MyCAP. All rights reserved.
//

#import "UIWebView+JavaScript.h"
//#import <QuartzCore/QuartzCore.h>

@implementation UIWebView (JavaScript)

typedef enum _WEBVIEW_JS_CMD_STATE {
	WEBVIEW_JS_CMD_STATE_NONE = 0x00,
	WEBVIEW_JS_CMD_STATE_CANCEL   = 0x01,
    WEBVIEW_JS_CMD_STATE_OK  = 0x02
} WEBVIEW_JS_CMD_STATE;

static volatile WEBVIEW_JS_CMD_STATE _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    
#ifdef USE_MOCK_INVESTMENT
    
//    
//    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
//    const char * cstr = [message cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData * sdata = [[NSData alloc] initWithBytes:cstr length:strlen(cstr)];
//    
//    message = [[NSString alloc] initWithData:sdata encoding:encoding];
#endif
    
    
    
    UIAlertView *webViewAlert = [[UIAlertView alloc] initWithTitle:nil message:message  delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [webViewAlert show];
    
    _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;
    while (_pageWaitUserSelection == WEBVIEW_JS_CMD_STATE_NONE)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;
    webViewAlert.delegate  = nil;
}

- (NSString *)webView:(WebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WebFrame *)frame
{
    NSString *reuslt = @"";
    
    NSArray   *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSInteger  majorSystemVer       = [[versionCompatibility objectAtIndex:0] integerValue];
    
    if(majorSystemVer >= 0x05) // isOverIOS5
    {
        UIAlertView* webViewPrompt = [[UIAlertView alloc] init];
        webViewPrompt.delegate     = self;
        webViewPrompt.title        = prompt;

        [webViewPrompt addButtonWithTitle:@"확인"];
        
        NSInteger cancelButtonIndex     = [webViewPrompt addButtonWithTitle:@"취소"];
        webViewPrompt.cancelButtonIndex = cancelButtonIndex;
        
        // iOS 5
        //////////////////
        webViewPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField       = [webViewPrompt textFieldAtIndex:0];
        textField.text               = defaultText;
        //////////////////
        [webViewPrompt show];
        
        _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;
        while (_pageWaitUserSelection == WEBVIEW_JS_CMD_STATE_NONE)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        WEBVIEW_JS_CMD_STATE prompt_value = _pageWaitUserSelection;
        _pageWaitUserSelection            = WEBVIEW_JS_CMD_STATE_NONE;
        
        if(prompt_value == WEBVIEW_JS_CMD_STATE_OK)
        {
            reuslt =  [textField text] ;
            if(!reuslt)
                reuslt = @"";
        }
        
        webViewPrompt.delegate = nil;
        return reuslt;
    }
    else
    {
        // TODO
        UIAlertView *webViewPrompt = [[UIAlertView alloc] initWithTitle:prompt message:@"\n\n" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        
        UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        myTextField.text = defaultText;
        [myTextField setBackgroundColor:[UIColor whiteColor]];
        [myTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [myTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [webViewPrompt addSubview:myTextField];
        [myTextField becomeFirstResponder];
        
        [webViewPrompt show];
        
        _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;
        while (_pageWaitUserSelection == WEBVIEW_JS_CMD_STATE_NONE)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        WEBVIEW_JS_CMD_STATE prompt_value = _pageWaitUserSelection;
        _pageWaitUserSelection            = WEBVIEW_JS_CMD_STATE_NONE;
        
        if(prompt_value == WEBVIEW_JS_CMD_STATE_OK)
        {
            reuslt = [myTextField text];
            if(!reuslt)
                reuslt = @"";
        }

        return reuslt;
    }
}

- (BOOL)webView:(WebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    UIAlertView *webViewConfirm = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [webViewConfirm show];
    

    _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;
    while (_pageWaitUserSelection == WEBVIEW_JS_CMD_STATE_NONE)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    WEBVIEW_JS_CMD_STATE confirm_value = _pageWaitUserSelection;
    _pageWaitUserSelection             = WEBVIEW_JS_CMD_STATE_NONE;
    
    webViewConfirm.delegate = nil;
    
    if(confirm_value == WEBVIEW_JS_CMD_STATE_OK)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView)
    {
        if (alertView.cancelButtonIndex == buttonIndex)
            _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_CANCEL;
        else
            _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_OK;
    }
    else
    {
       _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_CANCEL;
    }
}

- (void) alertViewCancel:(UIAlertView *)alertView
{
    _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_CANCEL;
}

@end
