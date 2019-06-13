//
//  FileUploadViewController.h
//  Muffin
//
//  Created by JoonHo Kang on 27/05/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FileUploadViewDelegate <NSObject>;

@required

-(void) getData:(NSString *)data;

@end


@interface FileUploadViewController : EDBaseViewController
{
    id < FileUploadViewDelegate > delegate;
}

@property (nonatomic,assign) id< FileUploadViewDelegate > delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblFileList;

@property (nonatomic, assign) NSString *sBrowserType;
@property (strong, nonatomic) IBOutlet UIButton *btnAlbum;

- (IBAction)onUpload:(id)sender;
- (void)uploadFiles:(id)sender;
@end

NS_ASSUME_NONNULL_END
