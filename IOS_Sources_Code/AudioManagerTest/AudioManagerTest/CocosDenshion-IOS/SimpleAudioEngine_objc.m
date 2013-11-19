/*
 Copyright (c) 2010 Steve Oldmeadow
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 $Id$
 */

#import "SimpleAudioEngine_objc.h"

@implementation SimpleAudioEngine

static SimpleAudioEngine *sharedEngine = nil;
static CDSoundEngine* soundEffect = nil;
static CDAudioManager *avplayerManager = nil;
static CDBufferManager *bufferManager = nil;

// Init
+ (SimpleAudioEngine *) sharedEngine
{
    @synchronized(self)     {
        if (!sharedEngine)
            sharedEngine = [[SimpleAudioEngine alloc] init];
    }
    return sharedEngine;
}

+ (id) alloc
{
    @synchronized(self)     {
        NSAssert(sharedEngine == nil, @"Attempted to allocate a second instance of a singleton.");
        return [super alloc];
    }
    return nil;
}

-(id) init
{
    if((self=[super init])) {
        avplayerManager = [CDAudioManager sharedManager];
        // set audio play in background mode.
        [avplayerManager setResignBehavior:kAMRBDoNothing autoHandle:YES];
        
        soundEffect = avplayerManager.soundEngine;
        bufferManager = [[CDBufferManager alloc] initWithEngine:soundEffect];
        mute_ = NO;
        enabled_ = YES;
    }
    return self;
}

// Memory
- (void) dealloc
{
    avplayerManager = nil;
    soundEffect = nil;
    bufferManager = nil;
    [super dealloc];
}

+(void) end 
{
    avplayerManager = nil;
    [CDAudioManager end];
    [bufferManager release];
    [sharedEngine release];
    sharedEngine = nil;
}

#pragma mark SimpleAudioEngine - background music

-(void) preloadBackgroundMusic:(NSString*) filePath {
    [avplayerManager preloadBackgroundMusic:filePath];
}

-(void) playBackgroundMusic:(NSString*) filePath
{
    [avplayerManager playBackgroundMusic:filePath loop:TRUE];
}

-(void) playBackgroundMusic:(NSString*) filePath loop:(BOOL) loop
{
    [avplayerManager playBackgroundMusic:filePath loop:loop];
}

-(void) stopBackgroundMusic
{
    [avplayerManager stopBackgroundMusic];
}

-(void) pauseBackgroundMusic {
    [avplayerManager pauseBackgroundMusic];
}    

-(void) resumeBackgroundMusic {
    [avplayerManager resumeBackgroundMusic];
}    

-(void) rewindBackgroundMusic {
    [avplayerManager rewindBackgroundMusic];
}

-(BOOL) isBackgroundMusicPlaying {
    return [avplayerManager isBackgroundMusicPlaying];
}    

-(BOOL) willPlayBackgroundMusic {
    return [avplayerManager willPlayBackgroundMusic];
}

#pragma mark SimpleAudioEngine - sound effects

-(ALuint) playEffect:(NSString*) filePath loop:(BOOL) loop
{
    return [self playEffect:filePath loop:loop pitch:1.0f pan:0.0f gain:1.0f];
}

-(ALuint) playEffect:(NSString*) filePath loop:(BOOL) loop pitch:(Float32) pitch pan:(Float32) pan gain:(Float32) gain
{
    int soundId = [bufferManager bufferForFile:filePath create:YES];
    if (soundId != kCDNoBuffer) {
        return [soundEffect playSound:soundId sourceGroupId:0 pitch:pitch pan:pan gain:gain loop:loop];
    } else {
        return CD_MUTE;
    }    
}

-(void) stopEffect:(ALuint) soundId {
    [soundEffect stopSound:soundId];
}    

-(void) pauseEffect:(ALuint) soundId {
  [soundEffect pauseSound: soundId];
}

-(void) pauseAllEffects {
  [soundEffect pauseAllSounds];
}

-(void) resumeEffect:(ALuint) soundId {
  [soundEffect resumeSound: soundId];
}

-(void) resumeAllEffects {
  [soundEffect resumeAllSounds];
}

-(void) stopAllEffects {
  [soundEffect stopAllSounds];
}

-(void) preloadEffect:(NSString*) filePath
{
    int soundId = [bufferManager bufferForFile:filePath create:YES];
    if (soundId == kCDNoBuffer) {
        CDLOG(@"Denshion::SimpleAudioEngine sound failed to preload %@",filePath);
    }
}

-(void) unloadEffect:(NSString*) filePath
{
    CDLOGINFO(@"Denshion::SimpleAudioEngine unloadedEffect %@",filePath);
    [bufferManager releaseBufferForFile:filePath];
}

#pragma mark Audio Interrupt Protocol
-(BOOL) mute
{
    return mute_;
}

-(void) setMute:(BOOL) muteValue
{
    if (mute_ != muteValue) {
        mute_ = muteValue;
        avplayerManager.mute = mute_;
    }    
}

-(BOOL) enabled
{
    return enabled_;
}

-(void) setEnabled:(BOOL) enabledValue
{
    if (enabled_ != enabledValue) {
        enabled_ = enabledValue;
        avplayerManager.enabled = enabled_;
    }    
}


#pragma mark SimpleAudioEngine - BackgroundMusicVolume
-(float) backgroundMusicVolume
{
    return avplayerManager.backgroundMusic.volume;
}    

-(void) setBackgroundMusicVolume:(float) volume
{
    avplayerManager.backgroundMusic.volume = volume;
}    

#pragma mark SimpleAudioEngine - EffectsVolume
-(float) effectsVolume
{
    return avplayerManager.soundEngine.masterGain;
}    

-(void) setEffectsVolume:(float) volume
{
    avplayerManager.soundEngine.masterGain = volume;
}    

-(CDSoundSource *) soundSourceForFile:(NSString*) filePath {
    int soundId = [bufferManager bufferForFile:filePath create:YES];
    if (soundId != kCDNoBuffer) {
        CDSoundSource *result = [soundEffect soundSourceForSound:soundId sourceGroupId:0];
        CDLOGINFO(@"Denshion::SimpleAudioEngine sound source created for %@",filePath);
        return result;
    } else {
        return nil;
    }    
}

- (BOOL)setAudioSessionCategory:(NSString *)category
{
    // The AmbientSound category allows application audio to mix with Media Player
    // audio. The category also indicates that application audio should stop playing
    // if the Ring/Siilent switch is set to "silent" or the screen locks.
	
    // Use this code instead to allow the app sound to continue to play when the screen is locked.
    [[AVAudioSession sharedInstance] setCategory: category error: nil];
    
    // allow app play music together ipod music player.
    UInt32 doSetProperty = YES;
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideCategoryMixWithOthers,
                             sizeof (doSetProperty),
                             &doSetProperty
                             );
    
    // Activates the audio session.
	
	NSError *activationError = nil;
	
    if ([[AVAudioSession sharedInstance] setActive: YES error: &activationError]) {
		NSLog(@"Audio session set active YES succeeded");
		return YES;
    }
    else {
        //Failed
		NSLog(@"Audio session set active failed with error %@", activationError);
		return NO;
    }
}

@end
