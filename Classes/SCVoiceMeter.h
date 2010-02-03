//
//  SCVoiceMeter.h
//  iAudition
//
//  Created by Aleks Nesterow on 11/15/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o.
//  All rights reserved.
//  
//  Purpose
//	Provides functionality to measure the input level in dB.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kSCVoiceMeterBufferNumber	3
#define kSCVoiceMeterBufferForTime	.5

@interface SCVoiceMeter : NSObject {
	
@protected
	AudioQueueLevelMeterState *channelLevels;
	UInt32 channelLevelsDataSize;
	AudioStreamBasicDescription format;
	AudioQueueRef queue;
	AudioQueueBufferRef buffers[kSCVoiceMeterBufferNumber];
	UInt32 bufferByteSize;
	
@private
	BOOL _meteringEnabled;
}

/** A Boolean value that indicates whether audio-level metering is enabled (YES), or not (NO). */
@property (getter=isMeteringEnabled) BOOL meteringEnabled;
/** Returns the average power for a given channel, in decibels, for the sound. */
- (float)averagePowerForChannel:(NSUInteger)channelNumber;
/** Returns the peak power for a given channel, in decibels, for the sound being recorded. */
- (float)peakPowerForChannel:(NSUInteger)channelNumber;
/** Refreshes the average and peak power values for all channels of the voice meter. */
- (void)updateMeters;

@end
