//
//  AudioUtil.m
//  Muffin
//
//  Created by escdream on 2018. 9. 4..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "AudioUtil.h"
#import "STKAudioPlayer.h"

static AudioUtil * gAudioUtil;

@implementation AudioUtil

+ (AudioUtil *) instance
{
    if (gAudioUtil == nil)
    {
        gAudioUtil = [[AudioUtil alloc] init];
    }
    
    return gAudioUtil;
}

+ (STKAudioPlayer *) player
{
    if (gAudioUtil == nil)
    {
        gAudioUtil = [[AudioUtil alloc] init];
    }
    
    return gAudioUtil->audioPlayer;
}

+ (void) setPlayerDelegate:(id) delegate;
{
    if (gAudioUtil == nil)
    {
        gAudioUtil = [[AudioUtil alloc] init];
    }
    gAudioUtil->audioPlayer.delegate = delegate;
}


- (id) init
{
    self = [super init];
    if(self)
    {
        audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        audioPlayer.meteringEnabled = YES;
        audioPlayer.volume = 1;
    }
    return self;
}

@end
