//
//  AudioUtil.h
//  Muffin
//
//  Created by escdream on 2018. 9. 4..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKAudioPlayer.h"

@interface AudioUtil : NSObject
{
    STKAudioPlayer * audioPlayer;
}

+ (AudioUtil *) instance;
+ (STKAudioPlayer *) player;
+ (void) setPlayerDelegate:(id) delegate;

@end
