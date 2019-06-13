//
//  AudioPlayerViewController.m
//  Muffin
//
//  Created by escdream on 2018. 9. 4..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import "SampleQueueId.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonUtil.h"
#import "AudioUtil.h"


@interface AudioPlayerViewController ()
{

}

@end

@implementation AudioPlayerViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.frame = [CommonUtil getWindowArea];

    
    
    // Do any additional setup after loading the view from its nib.
    

    CGRect r = self.view.bounds;
    r.origin.y = 80;
    
    AudioPlayerView* audioPlayerView = [[AudioPlayerView alloc] initWithFrame:r andAudioPlayer:[AudioUtil player]];
    
    audioPlayerView.delegate = self;
    
    [self.view addSubview:audioPlayerView];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) audioPlayerViewPlayFromHTTPSelected:(AudioPlayerView*)audioPlayerView
{
    NSURL* url = [NSURL URLWithString:@"http://www.abstractpath.com/files/audiosamples/sample.mp3"];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void) audioPlayerViewPlayFromIcecastSelected:(AudioPlayerView *)audioPlayerView
{
    NSURL* url = [NSURL URLWithString:@"http://nashe.streamr.ru/jazz-128.mp3"];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void) audioPlayerViewQueueShortFileSelected:(AudioPlayerView*)audioPlayerView
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"airplane" ofType:@"aac"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [[AudioUtil player] queueDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void) audioPlayerViewPlayFromLocalFileSelected:(AudioPlayerView*)audioPlayerView
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ManInTheMirror" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void) audioPlayerViewQueuePcmWaveFileSelected:(AudioPlayerView*)audioPlayerView
{
    NSURL* url = [NSURL URLWithString:@"http://www.abstractpath.com/files/audiosamples/perfectly.wav"];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [[AudioUtil player] queueDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}
- (IBAction)onClose:(id)sender {
    
    [[AudioUtil player] stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
