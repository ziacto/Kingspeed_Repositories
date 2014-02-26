/***********************************************************************
 *	File name:	DetectMuteSwitch.h
 *	Project:	detecting silent switch status on all IOS
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 20/6/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>

#define     ADD_FREQUENCY_DETECT    0.0
#define     ROUTE_IOS_UNDER_5       1
#define     FILTER_TIMES            2

@class SilentSwitchDetect;

@protocol SilentSwitchDetectDelegate
    @required
    - (void) silentStatusIs:(BOOL)muted;
@end

@interface SilentSwitchDetect : NSObject {
    @private
    NSObject<SilentSwitchDetectDelegate> *delegate;
    float checkSum;
}

@property (readwrite, retain) NSObject<SilentSwitchDetectDelegate> *delegate;

// Initial with shared instance
+ (SilentSwitchDetect *)sharedInstance;
// Begin detecting...
- (void) beginDetect;

@end
