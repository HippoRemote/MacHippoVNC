//
//  ANSystemSoundWrapper.h
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

/*
 PURPOSE:	A wrapper around CoreAudio functions to easily adjust the system sound volume level.
			When setting the system volume, channels will be muted/unmuted as appropriate.
 
 CREDITS:	This software was developed with help from unattributed code examples found on 
			the internet. Gratitude goes out to whoever supplied the original examples.
 
 USAGE:		The parameters to the volume setting functions range from 0 to 1, where 1 is max volume
			and 0 is min volume. Setting volume to 0 automatically mutes the channel(s).
 
			Example (this will beep unless volume was already at max):
 
			 float oldVol = [ANSystemSoundWrapper systemVolume];
			 [ANSystemSoundWrapper increaseSystemVolumeBy:.05];	
			 if (oldVol != [ANSystemSoundWrapper systemVolume]) {
				[(NSSound *)[NSSound soundNamed:@"Tink"] play];
			 }
 

 NOTE:		To use this wrapper in your projects you need to link against the CoreAudio framework.
 
 VERSION:   1.1
 RELEASE NOTES:	
			1.1: Changed getSystemVolume to systemVolume (20080411) to adhere to Cocoa naming conventions.
			1.0: First release.
 */

#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>


@interface ANSystemSoundWrapper : NSObject {
	
}

+ (float)systemVolume;
+ (void)setSystemVolume:(float)inVolume;
+ (void)increaseSystemVolumeBy:(float)amount;
+ (void)decreaseSystemVolumeBy:(float)amount;

@end
