//
//  SCVoiceMeter.m
//  iAudition
//
//  Created by Aleks Nesterow on 11/15/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o.
//  All rights reserved.
//

#import "SCVoiceMeter.h"
#import "SCLog.h"

#define CAT	@"VoiceMeter"
#define CheckIfAudioQueueError(status, message) { if (status != noErr) SC_LOG_ERROR(CAT, message); }

@interface SCVoiceMeter (/* Private Methods */)

- (void)__initializeComponent;
- (BOOL)__start;
- (void)__stop;

@end

@implementation SCVoiceMeter

#pragma mark AudioQueue input buffer

static void HandleInputBuffer(void *userData, AudioQueueRef audioQueue, AudioQueueBufferRef buffer,
							  const AudioTimeStamp *packetStartTime, UInt32 packetsCount,
							  const AudioStreamPacketDescription *packetDescription) {
	
	SCVoiceMeter *voiceMeter = (SCVoiceMeter *)userData;
	if (voiceMeter.isMeteringEnabled) {
		CheckIfAudioQueueError(AudioQueueEnqueueBuffer(voiceMeter->queue, buffer, 0, NULL), @"Cannot enqueue buffer.");
	}
}

static UInt32 DeriveBufferSize(AudioQueueRef audioQueue, const AudioStreamBasicDescription *format, Float64 seconds) {
	
	static const int maxBufferSize = 0x50000;
	UInt32 maxPacketSize = format->mBytesPerPacket;
	if (0 == maxPacketSize) {
		UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
		CheckIfAudioQueueError(AudioQueueGetProperty(audioQueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize, &maxVBRPacketSize),
							   @"Cannot get the value of the kAudioQueueProperty_MaximumOutputPacketSize property.");
	}
	
	Float64 numBytesForTime = format->mSampleRate * maxPacketSize * seconds;
	return (UInt32)(numBytesForTime < maxBufferSize ? numBytesForTime : maxBufferSize);
}

#pragma mark init / dealloc

- (id)init {
	
	if (self = [super init]) {
		[self __initializeComponent];
	}
	
	return self;
}

- (void)__initializeComponent {
	
	format.mSampleRate = [[AVAudioSession sharedInstance] currentHardwareSampleRate];
	SC_LOG_INFO(CAT, @"Sample rate: %f", format.mSampleRate);
	
	format.mChannelsPerFrame = [[AVAudioSession sharedInstance] currentHardwareInputNumberOfChannels];
	SC_LOG_INFO(CAT, @"Channels: %d", format.mChannelsPerFrame);
	
	format.mFormatID = kAudioFormatLinearPCM;
	format.mFormatFlags = kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
	format.mBitsPerChannel = 16;
	format.mBytesPerPacket = format.mBytesPerFrame = format.mChannelsPerFrame * sizeof(SInt16);
	format.mFramesPerPacket = 1;
	
	channelLevels = (AudioQueueLevelMeterState *)malloc(sizeof(AudioQueueLevelMeterState) * format.mChannelsPerFrame);
	channelLevelsDataSize = sizeof(AudioQueueLevelMeterState) * format.mChannelsPerFrame;
	
	OSErr status = AudioQueueNewInput(&format, HandleInputBuffer, self, NULL, kCFRunLoopCommonModes, 0, &queue);
	CheckIfAudioQueueError(status, @"Cannot create new AudioQueue.");
	if (noErr == status) {
		SC_LOG_DEBUG(CAT, @"AudioQueue created successfully.");
	}
	
	UInt32 formatSize = sizeof(format);
	CheckIfAudioQueueError(AudioQueueGetProperty(queue, kAudioQueueProperty_StreamDescription, &format, &formatSize),
						   @"Cannot get the value of the kAudioQueueProperty_StreamDescription property.");
	
	UInt32 val = 1;
	CheckIfAudioQueueError(AudioQueueSetProperty(queue, kAudioQueueProperty_EnableLevelMetering, &val, sizeof(UInt32)),
						   @"Cannot enable metering.");
	
	bufferByteSize = DeriveBufferSize(queue, &format, kSCVoiceMeterBufferForTime);
	SC_LOG_TRACE(@"bufferByteSize = %d", bufferByteSize);
	
	for (NSUInteger i = 0; i < kSCVoiceMeterBufferNumber; ++i) {
		
		CheckIfAudioQueueError(AudioQueueAllocateBuffer(queue, bufferByteSize, &buffers[i]), @"Cannot allocate buffer.");
		CheckIfAudioQueueError(AudioQueueEnqueueBuffer(queue, buffers[i], 0, NULL), @"Cannot enqueue buffer.");
	}
}

- (void)dealloc {

	[self setMeteringEnabled:NO];
	CheckIfAudioQueueError(AudioQueueDispose(queue, TRUE), @"Cannot dispose AudioQueue.");
	free(channelLevels);
	
	[super dealloc];
}

#pragma mark Metering

@synthesize meteringEnabled = _meteringEnabled;
- (void)setMeteringEnabled:(BOOL)yesOrNo {
	
	if (_meteringEnabled != yesOrNo) {
		
		if (yesOrNo) {
			_meteringEnabled = [self __start];
		} else {
			_meteringEnabled = NO;
			[self __stop];
		}
	}
}

- (BOOL)__start {
	
	BOOL result = NO;
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *error = nil;
	[audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
	
	if (error) {
		SC_LOG_ERROR(CAT, @"Cannot apply Record category to AVAudioSession: %@ (%@)", error, error.userInfo);
	} else {
		
		error = NULL;
		[[AVAudioSession sharedInstance] setActive:YES error:&error];
		
		if (error) {
			SC_LOG_ERROR(CAT, @"Cannot set AVAudioSession active.");
		} else {
			
			OSStatus status = AudioQueueStart(queue, NULL);
			CheckIfAudioQueueError(status, @"Cannot start AudioQueue.");
			
			if (noErr == status) {
				
				SC_LOG_DEBUG(CAT, @"AudioQueue started successfully.");
				result = YES;
			}
		}
	}
	
	return result;
}

- (void)__stop {
	
	SC_LOG_DEBUG(CAT, @"Stopping...");
	OSErr status = AudioQueueStop(queue, TRUE);
	CheckIfAudioQueueError(status, @"Cannot stop AudioQueue immediately.");
	if (noErr == status) {
		SC_LOG_DEBUG(CAT, @"AudioQueue stopped successfully.");
	}
}

- (void)updateMeters {
	
	OSStatus status = AudioQueueGetProperty(queue, kAudioQueueProperty_CurrentLevelMeterDB, channelLevels, &channelLevelsDataSize);
	CheckIfAudioQueueError(status, @"Cannot get the value of the kAudioQueueProperty_CurrentLevelMeterDB property.");
}

- (float)averagePowerForChannel:(NSUInteger)channelNumber {

	return channelLevels[channelNumber].mAveragePower;
}

- (float)peakPowerForChannel:(NSUInteger)channelNumber {

	return channelLevels[channelNumber].mPeakPower;
}

@end
