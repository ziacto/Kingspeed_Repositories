/***********************************************************************
 *	File name:	DetectMuteSwitch.m
 *	Project:	detecting silent switch status on all IOS
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 20/6/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "SilentSwitchDetect.h"

#define     ONE_SECOND                  (1ull * NSEC_PER_SEC)
#define     CONST_FREQUENCY_DETECT      0.010
#define     STEP_DURATION_ADD           0.001

@interface SilentSwitchDetect ()

dispatch_source_t CreateDispatchTimerForCheck(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block);
- (void) methodToRepeat;
- (void) detectByRoute;
- (void) detectByPlaySystemSound;
- (void) detectSwitch;

@end

static SilentSwitchDetect *_sharedInstance;
static dispatch_source_t timerInBackground;


@implementation SilentSwitchDetect

static int filterTimes = 0;

@synthesize delegate;

+ (SilentSwitchDetect *)sharedInstance
{
	if (!_sharedInstance) {
        _sharedInstance = [[[self class] alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
	self = [super init];
	
    if (self) {
        filterTimes = 0;
        checkSum = 0.0;
    }
	
	return self;
}


- (void)playbackComplete {
    @try {
        filterTimes += 1;
        if (filterTimes >= FILTER_TIMES) {
            if ([(id)self.delegate respondsToSelector:@selector(silentStatusIs:)]) {
                // If playback is far less than 100ms then we know the device is muted
                if (checkSum < (CONST_FREQUENCY_DETECT + ADD_FREQUENCY_DETECT)) {
                    [delegate silentStatusIs:YES];
                }
                else {
                    [delegate silentStatusIs:NO];
                }
            }
            
            filterTimes = 0;
        }
        else {
            [self performSelector:@selector(detectSwitch) withObject:nil afterDelay:0.005];
        }
        
        if (timerInBackground)
        {
            dispatch_source_cancel(timerInBackground);
            dispatch_release(timerInBackground);
            timerInBackground = nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"------------------: %@", exception);
    }
    @finally {
        
    }
}

static void soundCompletionCallback (SystemSoundID mySSID, void* myself) {
    @try {
        AudioServicesRemoveSystemSoundCompletion (mySSID);
        [[SilentSwitchDetect sharedInstance] playbackComplete];
    }
    @catch (NSException *exception) {
        NSLog(@"------------------: %@", exception);
    }
    @finally {
        
    }
}

- (void) beginDetect
{
    @try {
        filterTimes = 0;
        [self detectSwitch]; 
    }
    @catch (NSException *exception) {
        NSLog(@"------------------: %@", exception);
    }
    @finally {
        
    }
}

- (void) detectSwitch
{
    @try {
        checkSum = 0.0;
        
#if TARGET_IPHONE_SIMULATOR
        // The simulator doesn't support detection and can cause a crash so always return muted
        if ([(id)self.delegate respondsToSelector:@selector(silentStatusIs:)]) {
            [self.delegate silentStatusIs:NO];
        }
        return;
#endif
        
#if __IPHONE_5_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
        // iOS 5+ doesn't allow mute switch detection using state length detection
        // So we need to play a blank 100ms file and detect the playback length
        [self detectByPlaySystemSound];
        return;
#else
        // This method doesn't work under iOS 5+
        if (ROUTE_IOS_UNDER_5) {
            [self detectByRoute];
            return;
        }
        else
        {
            [self detectByPlaySystemSound];
            return;
        }
#endif
    }
    @catch (NSException *exception) {
        NSLog(@"------------------: %@", exception);
    }
    @finally {
        
    }
}

- (void) detectByRoute
{
    filterTimes += 1;
    
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    
    if (filterTimes >= FILTER_TIMES) {
        if(CFStringGetLength(state) > 0) {
            if ([(id)self.delegate respondsToSelector:@selector(silentStatusIs:)]) {
                [self.delegate silentStatusIs:NO];
            }
        }
        if ([(id)self.delegate respondsToSelector:@selector(silentStatusIs:)]) {
            [self.delegate silentStatusIs:YES];
        }
        
        filterTimes = 0;
    }
    else {
        [self performSelector:@selector(detectSwitch) withObject:nil afterDelay:0.005];
    }
}

- (void) detectByPlaySystemSound
{
    checkSum = 0.0;
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
    
    // Get the main bundle for the app
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle();
    
    // Get the URL to the sound file to play
    soundFileURLRef  =	CFBundleCopyResourceURL(
                                                mainBundle,
                                                CFSTR ("detection"),
                                                CFSTR ("aiff"),
                                                NULL
                                                );
    
    // Create a system sound object representing the sound file
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundFileObject
                                      );
    
    AudioServicesAddSystemSoundCompletion (soundFileObject,NULL,NULL,
                                           soundCompletionCallback,
                                           (__bridge void*) self);
    
    // Start the playback timer
    //    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(incrementTimer) userInfo:nil repeats:YES];
    timerInBackground = CreateDispatchTimerForCheck(ONE_SECOND/1000.0, ONE_SECOND / 10000.0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Repeating task
        [self methodToRepeat];
    });
	// Play the sound
    AudioServicesPlaySystemSound(soundFileObject);
}

dispatch_source_t CreateDispatchTimerForCheck(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

- (void) methodToRepeat
{
    checkSum = checkSum + STEP_DURATION_ADD;
}

@end
