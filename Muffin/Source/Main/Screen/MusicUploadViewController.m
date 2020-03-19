//
//  FileUploadViewController.m
//  Muffin
//
//  Created by JoonHo Kang on 27/05/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MusicUploadViewController.h"
#import "CommonFileUtil.h"
#import "CommonUtil.h"

#import "FTPFileUploder.h"
#import "UIView+Toast.h"

///Users/escdream/Desktop/0.머핀/Muffin/Muffin/Library/Lib/Util/FTPFileUploder.m
#define ROW_HEIGHT  [CommonUtil calcResize:55 direction:0 mode:0]
#define OFFSET      [CommonUtil calcResize:10 direction:0 mode:0]
#define OFFSET2     [CommonUtil calcResize:4 direction:0 mode:0]


@interface MusicUploadViewController ()
{
    NSMutableArray * arrFiles;
    FTPFileUploder * uploader;
    NSString * curEditFileName;
    BOOL isChangeText;
}

@end

@implementation MusicUploadViewController


- (void)viewDidLoad {
    [self.view addSubview: _viewTextEdit];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    arrFiles = [[NSMutableArray alloc] init];

    uploader = [[FTPFileUploder alloc] init];
    uploader.ftpUrl = @"ftp://ourworld3.cafe24.com/tomcat/webapps/dataM/attach/image";
    uploader.ftpUserName = @"ourworld3";
    uploader.ftpUserPassword = @"ourworld6249!";
    uploader.delegate = self;
    
    
//    [self createDefaultFolder:@"/Music"];
//    [self createDefaultFolder:@"/Lyric"];
//    [self createDefaultFolder:@"/Images"];

    if ([_sBrowserType isEqualToString:@"image"])
        _btnAlbum.hidden = NO;
    
    CGSize sz = CGSizeMake(30, 30);
    
    UIImage * onImage = [CommonUtil getLocalImageWithSize:sz  filename:@"btn_on.png"] ;
    UIImage * offImage = [CommonUtil getLocalImageWithSize:sz filename:@"btn_off.png" ] ;
    
    [_btnMp3 setImage:offImage forState:UIControlStateNormal];
    [_btnMp3 setImage:onImage  forState:UIControlStateSelected];
    
    [_btnText setImage:offImage forState:UIControlStateNormal];
    [_btnText setImage:onImage  forState:UIControlStateSelected];
    
    _btnMp3.selected = YES;
    
    
    _viewTextEdit.frame = _tblFileList.frame;
    _viewTextEdit.hidden = YES;
    

    
    
    [self openFileExplorer: @"mp3"];

}


- (void)createDefaultFolder:(NSString *)folderName{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folderName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
}


-(NSString *)saveImageToDocumentDirectoryWithImage: (UIImage *)capturedImage {
    
    return [CommonUtil saveJpegImage:capturedImage sFileName:@"img" nMaxSize:1280];

/*
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = documentsDirectory;
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];

    //Create a folder inside Document Directory
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    NSString *imageName = [NSString stringWithFormat:@"%@/img_%@.png", dataPath, [self getRandomNumber]] ;
    // save the file
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageName]) {
        // delete if exist
        [[NSFileManager defaultManager] removeItemAtPath:imageName error:nil];
    }
    
    NSData *imageDate = [NSData dataWithData:UIImagePNGRepresentation(capturedImage)];
    [imageDate writeToFile: imageName atomically: YES];
    
    
    
    return imageName;
*/
}

#pragma mark
#pragma mark == Generate Random Number
-(NSString *)getRandomNumber{
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); // returned as a double
    long digits = (long)time; // this is the first 10 digits
    int decimalDigits = (int)(fmod(time, 1) * 1000); // this will get the 3 missing digits
    //long timestamp = (digits * 1000) + decimalDigits;
    NSString *timestampString = [NSString stringWithFormat:@"%ld%d",digits ,decimalDigits];
    return timestampString;
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSString * fileName = [path lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = paths[0];
    
    NSString * fullPath = [self saveImageToDocumentDirectoryWithImage:image];
    
    uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/image_g";

    [uploader upload:fullPath];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) openFileExplorer:(NSString *)sBrowserType
{
    //음원경로
    
    //가사경로
//    NSString *sLocalPath =  [NSString stringWithFormat:@"%@/Main/image", [[NSBundle mainBundle] resourcePath] ];// [CommonFileUtil getDocumentPath] ;//[NSString stringWithFormat:@"%@/
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = documentsDirectory;
//    if ([sBrowserType isEqualToString:@"image"])
//        dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
//    if ([sBrowserType isEqualToString:@"txt"])
//        dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Lyric"];
//    else if ([sBrowserType isEqualToString:@"mp3"])
//        dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Music"];

    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:nil];
    NSMutableArray *arrMutable = [[NSMutableArray alloc]initWithArray:arr];
    NSMutableArray *arrContents = [[NSMutableArray alloc]init];
    int x = 0;
    for (int i=0; i<arrMutable.count; i++)
    {
        NSString* ext = [[arrMutable[i] pathExtension] lowercaseString];
        
        if ([sBrowserType isEqualToString:@"mp3"]){
            if ( [ext isEqualToString:@"mp3"] ){
                NSString * tmp = [arrMutable objectAtIndex:i];
                [arrContents insertObject:tmp atIndex:x];
                x++;
            }
        }
        else if ([sBrowserType isEqualToString:@"image"]){
            if ( [ext isEqualToString:@"png"] || [ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"] ){
                NSString * tmp = [arrMutable objectAtIndex:i];
                [arrContents insertObject:tmp atIndex:x];
                x++;
            }
        }
        else if ([sBrowserType isEqualToString:@"txt"]) {
            if ( ![ext isEqualToString:@"mp3"] && ![ext isEqualToString:@"png"] && ![ext isEqualToString:@"jpg"] && ![ext isEqualToString:@"jpeg"]) {
                NSString * tmp = [arrMutable objectAtIndex:i];
                [arrContents insertObject:tmp atIndex:x];
                x++;
            }
        }
        else if ([sBrowserType isEqualToString:@"music"]) {
            if ( [ext isEqualToString:@"mp3"] && [ext isEqualToString:@"txt"]) {
                NSString * tmp = [arrMutable objectAtIndex:i];
                [arrContents insertObject:tmp atIndex:x];
                x++;
            }
        }

    }
    [arrFiles removeAllObjects];
    arrFiles = nil;
    arrFiles = [[NSMutableArray alloc] initWithArray:arrContents];
    _sBrowserType = sBrowserType;
    
    [_tblFileList reloadData];
    
    if ([sBrowserType isEqualToString:@"txt"]) {
        
        if (arrFiles.count > 0 && arrFiles.count == 1)
        {
            _tblFileList.hidden = YES;
            _viewTextEdit.hidden = NO;
            
            NSString* path = [NSString stringWithFormat:@"%@/%@", dataPath, arrFiles[0] ];
            
            NSString* content = [NSString stringWithContentsOfFile:path
                                                          encoding:NSUTF8StringEncoding
                                                             error:NULL];
            
            _textViewEdit.text = content;
            isChangeText = NO;
            _btnSave.enabled = isChangeText;
            curEditFileName = [path copy];
        }
        else
        {
            _tblFileList.hidden = NO;
            _viewTextEdit.hidden = YES;
        }
    }
    else
    {
        _tblFileList.hidden = NO;
        _viewTextEdit.hidden = YES;
    }

    
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFiles.count;
}

- (NSInteger) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UILabel *labelItem = nil;
    UIButton * btnUpload = nil;
    
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        labelItem = [[UILabel alloc] initWithFrame:CGRectMake(OFFSET, 0, tableView.frame.size.width-OFFSET*2, ROW_HEIGHT)];
        labelItem.backgroundColor = [UIColor clearColor];
//        labelItem.textColor       = [[ResourceManager sharedManager] getColorfromIndex:CID_BASIC_INPUT_SUBTEXT];
        labelItem.textAlignment   = NSTextAlignmentLeft;
        labelItem.tag = 10001;
        [cell.contentView addSubview:labelItem];
        
        //          UIImageView *selectedBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0, m_nTableWidth,100)] autorelease];
        //          selectedBackground.backgroundColor = [[ResourceManager sharedManager] getColorfromIndex:137];
        //          [cell setSelectedBackgroundView:selectedBackground];
        
        btnUpload = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btnUpload.frame = CGRectMake(tableView.frame.size.width-OFFSET*2 - 80, 0, 80, ROW_HEIGHT);
        btnUpload.backgroundColor = [UIColor blackColor];
        [btnUpload setTitle:@"Upload" forState:UIControlStateNormal];
        btnUpload.hidden = true;
        btnUpload.tag = 10002;

        [btnUpload addTarget:self action:@selector(uploadFile:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:btnUpload];
    }
    
    if (arrFiles != nil)
    {
        labelItem = [cell.contentView viewWithTag:10001];
        btnUpload = [cell.contentView viewWithTag:10002];
        
        labelItem.text = [arrFiles objectAtIndex:indexPath.row];
        btnUpload.tag = indexPath.row;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIButton * btnUpload
    if (arrFiles != nil)
    {
        
        if ([_sBrowserType isEqualToString:@"txt"])
        {
                
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(getLocalData:sFileType:)])
            {
                [self.delegate getLocalData: [arrFiles objectAtIndex:indexPath.row] sFileType:_sBrowserType ];
            }
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
//
//- (void) RequestHttpFile:(BOOL)bUp :(NSString*)sReqURL :(int)nType :(NSString*)sAddValue :(BOOL)bAddForce :(BOOL)bViewer
//{
//    [[HttpFileUpDnMngr getInstance] requestHttpFile:bUp sReqURL:sReqURL nType:nType sAddPostValue:sAddValue bAddForce:bAddForce oReqFormMngr:(FormManager*)[self getFormManager] bViewer:bViewer];
//
//}


- (void) uploadFile:(UIButton *) btn
{
    NSString * fileName = @"";
    if (arrFiles != nil)
    {
        fileName = arrFiles[btn.tag];
    
        //[self FileUpload:fileName];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    
    
    fileName = [NSString stringWithFormat:@"%@/%@", dataPath, fileName];

    [uploader upload:fileName];
    
//
//    process.hidden = NO;
//    [process startAnimating];
//    NSLog(@"Uploading Files");
//
//    if (!self.isSending) {
//        NSString *filePath;
//
//        //filePath = [[NSBundle mainBundle]pathForResource:@"App" ofType:@"ipa"];
//        filePath = [NSString stringWithFormat:@"%@/Main/image/%@", [[NSBundle mainBundle] resourcePath], fileName];
//        [self startSend:filePath];
//    }
//    else
//        NSLog(@"Skipped");
    
    
    
    
}

- (void) UploadProcess:(FTPFileUploder *) FileUploader nState:(int)nState sMessage:(NSString *) sMessage;
{
    NSLog(@"ftp log : %@[%d]", sMessage, nState);
    
    if (nState < 0)
    {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:sMessage];
    }
    else if ( nState == 99999)
    {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:@"업로드 완료!"];
    }
    
}


- (void) FileUpload:(NSString *)fileName
{
    
    UIImage * imageToPost = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/Main/image/%@", [[NSBundle mainBundle] resourcePath], fileName]];
    
    
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithString:@"1.0"] forKey:[NSString stringWithString:@"ver"]];
    [_params setObject:[NSString stringWithString:@"en"] forKey:[NSString stringWithString:@"lan"]];
    [_params setObject:[NSString stringWithFormat:@"%d", @"1111111"] forKey:[NSString stringWithString:@"userId"]];
    [_params setObject:[NSString stringWithFormat:@"%@", @"title"] forKey:[NSString stringWithString:@"title"]];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = [NSString stringWithString:@"----------V2ymHFg03ehbqgZCaKO6jy"];
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = [NSString stringWithString:@"file"];
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString: @"http://ourworld3.cafe24.com/dataM/attach/muffin"];// @"http://ourworld3.cafe24.com/data/servlet/ServiceManager"];
                                        //`http://ourworld3.cafe24.com/dataM/attach/muffin"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
//    NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    
    
    NSData *imageData = UIImagePNGRepresentation(imageToPost);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:fileName forHTTPHeaderField:@"File"];
    [request setValue:@"true" forHTTPHeaderField:@"CheckSave"];
    [request setValue:@"fileput" forHTTPHeaderField:@"Method"];

    // set URL
    [request setURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", str);
            //success
        }
    }];
    
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onUpload:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void) setShowProjecInfo:(BOOL)showProjecInfo
{
    _showProjecInfo = showProjecInfo;
    
    if (showProjecInfo)
    {
        _lbProjectName.hidden = NO;
        _lbProgress.hidden = NO;
        _txtProjectName.hidden = NO;
        _txtProgress.hidden = NO;
//        _lbProjectName.hidden = NO;
//        _lbProgress.hidden = NO;
//        _txtProjectName.hidden = NO;
//        _txtProgress.hidden = NO;
    }
    else
    {
        self.lbProjectName.hidden = YES;
        self.lbProgress.hidden = YES;
        self.txtProjectName.hidden = YES;
        self.txtProgress.hidden = YES;
//        _lbProjectName.hidden = YES;
//        _lbProgress.hidden = YES;
//        _txtProjectName.hidden = YES;
//        _txtProgress.hidden = YES;
    }
}

- (IBAction)onTextClick:(id)sender {
    _btnText.selected = YES;
    _btnMp3.selected = NO;
    [self openFileExplorer: @"txt"];
}

- (IBAction)onMusicClick:(id)sender {
    _btnText.selected = NO;
    _btnMp3.selected = YES;
    [self openFileExplorer: @"mp3"];

}

- (IBAction)onSaveClick:(id)sender {
    NSString * sText = _textViewEdit.text;

    [sText writeToFile:curEditFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];

    isChangeText = NO;
    _btnSave.enabled = isChangeText;

}


- (void)textViewDidChange:(UITextView *)textView;
{
    NSLog(@"textViewDidChange");
    isChangeText = YES;
    
    _btnSave.enabled = isChangeText;

    
    
}

@end
