//
//  MusicUploadViewController.h
//  Muffin
//
//  Created by JoonHo Kang on 27/05/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MusicUploadViewDelegate <NSObject>;

@required

-(void) getLocalData:(NSString *)data sFileType:(NSString *) fileType;

@end


@interface MusicUploadViewController : EDBaseViewController
{
    id < MusicUploadViewDelegate > delegate;
}

@property (nonatomic,assign) id< MusicUploadViewDelegate > delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblFileList;

@property (nonatomic, assign) NSString *sBrowserType;
@property (strong, nonatomic) IBOutlet UIButton *btnAlbum;
@property (strong, nonatomic) IBOutlet UILabel *lbProjectName;
@property (strong, nonatomic) IBOutlet UILabel *lbProgress;
@property (strong, nonatomic) IBOutlet UITextField *txtProjectName;
@property (strong, nonatomic) IBOutlet UITextField *txtProgress;
@property (nonatomic, assign) BOOL showProjecInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnMp3;
@property (weak, nonatomic) IBOutlet UIButton *btnText;

@property (strong, nonatomic) IBOutlet UIView *viewTextEdit;
@property (weak, nonatomic) IBOutlet UITextView *textViewEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)onUpload:(id)sender;
- (void)uploadFiles:(id)sender;
@end

NS_ASSUME_NONNULL_END
