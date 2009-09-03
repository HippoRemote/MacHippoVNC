//
//  ANSystemSoundWrapper.m
//
//  Created by Antonio Nunes on 20080411.
//  Copyright (c) 2008 Antonio Nunes, SintraWorks.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ANSystemSoundWrapper.h"

@implementation ANSystemSoundWrapper

+ (float)systemVolume {
	float			b_vol;
	OSStatus		err;
	AudioDeviceID	device;
	UInt32			size;
	UInt32			channels[2];
	float			volume[2];
	
	// Get the default audio device.
	size = sizeof device;
	err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice, &size, &device);
	if(err!=noErr) {
		NSLog(@"ANSystemSoundWrapper: error getting audio device.");
		return 0.0;
	}
	
	// Try to get the master volume (channel 0),
	size = sizeof b_vol;
	err = AudioDeviceGetProperty(device, 0, 0, kAudioDevicePropertyVolumeScalar, &size, &b_vol);
	if(noErr==err) return b_vol;
	
	// otherwise, try seperate channels.
	// Get the channel numbers.
	size = sizeof(channels);
	err = AudioDeviceGetProperty(device, 0, 0,kAudioDevicePropertyPreferredChannelsForStereo, &size,&channels);
	if(err!=noErr) NSLog(@"ANSystemSoundWrapper: error getting audio channel-numbers.");
	
	size = sizeof(float);
	err = AudioDeviceGetProperty(device, channels[0], 0, kAudioDevicePropertyVolumeScalar, &size, &volume[0]);
	if(noErr!=err) NSLog(@"ANSystemSoundWrapper: error getting volume of audio channel %d.",channels[0]);
	err = AudioDeviceGetProperty(device, channels[1], 0, kAudioDevicePropertyVolumeScalar, &size, &volume[1]);
	if(noErr!=err) NSLog(@"ANSystemSoundWrapper: error getting volume of audio channel %d.",channels[1]);
	
	b_vol = (volume[0]+volume[1])/2.00;
	
	return  b_vol;
}

+ (void)setSystemVolume:(float)involume {
	OSStatus		err;
	AudioDeviceID	device;
	UInt32			size;
	Boolean			canset	= false;
	UInt32			channels[2];
	
	// Get the default audio device.
	size = sizeof device;
	err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice, &size, &device);
	if(err!=noErr) {
		NSLog(@"audio-volume error getting device");
		return;
	}
	
	UInt32 mute = (involume == 0);
	
	// Try to set the master-channel (0) volume.
	size = sizeof canset;
	err = AudioDeviceGetPropertyInfo(device, 0, false, kAudioDevicePropertyVolumeScalar, &size, &canset);
	if(err==noErr && canset==true) {
		size = sizeof involume;
		err = AudioDeviceSetProperty(device, NULL, 0, false, kAudioDevicePropertyMute, size, &mute);
		err = AudioDeviceSetProperty(device, NULL, 0, false, kAudioDevicePropertyVolumeScalar, size, &involume);
		return;
	}
	
	// else, try seperate channels:
	// get channels
	size = sizeof(channels);
	err = AudioDeviceGetProperty(device, 0, false, kAudioDevicePropertyPreferredChannelsForStereo, &size,&channels);
	if(err!=noErr) {
		NSLog(@"ANSystemSoundWrapper: error getting audio device.");
		return;
	}

	// Mute/unmute channels, as appropriate.
	size = sizeof(mute);
	err = AudioDeviceSetProperty(device, NULL, channels[0], false, kAudioDevicePropertyMute, size, &mute);
	if(noErr!=err) NSLog(@"ANSystemSoundWrapper: error setting muted state of audio channel %d.",channels[0]);
	err = AudioDeviceSetProperty(device, NULL, channels[1], false, kAudioDevicePropertyMute, size, &mute);
	if(noErr!=err) NSLog(@"ANSystemSoundWrapper: error setting muted state of audio channel %d.",channels[0]);

	// Set volume.
	size = sizeof(involume);
	err = AudioDeviceSetProperty(device, NULL, channels[0], false, kAudioDevicePropertyVolumeScalar, size, &involume);
	if(noErr!=err) NSLog(@"ANSystemSoundWrapper: error setting volume of audio channel %d.",channels[0]);
	err = AudioDeviceSetProperty(device, NULL, channels[1], false, kAudioDevicePropertyVolumeScalar, size, &involume);
	if(noErr!=err) NSLog(@"ANSystemSoundWrapper: error setting volume of audio channel %d.",channels[1]);
}

+ (void)increaseSystemVolumeBy:(float)amount {	
	[ANSystemSoundWrapper setSystemVolume:[ANSystemSoundWrapper systemVolume] + amount];
}

+ (void)decreaseSystemVolumeBy:(float)amount {
	[ANSystemSoundWrapper setSystemVolume:[ANSystemSoundWrapper systemVolume] - amount];
}


@end
