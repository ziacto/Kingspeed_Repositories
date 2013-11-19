/***********************************************************************
 *	File name:	_______________.h
 *	Project:	Location Camera
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 18/02/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "UIDevice+additions.h"

typedef enum {
    AssetsLibraryPrivacyStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
    AssetsLibraryPrivacyStatusRestricted,        // This application is not authorized to access photo data.
    // The user cannot change this application’s status, possibly due to active restrictions
    //  such as parental controls being in place.
    AssetsLibraryPrivacyStatusDenied,            // User has explicitly denied this application access to photos data.
    AssetsLibraryPrivacyStatusAuthorized,         // User has authorized this application to access photos data.
    AssetsLibraryLocationServiceOFF,
}AssetsLibraryPrivacyStatus;

typedef void(^AssetsLibraryPrivacyRequestAccessCompletionHandler)(bool allow, NSError *error);
typedef void(^AssetsLibraryPrivacyStatusHandler)(AssetsLibraryPrivacyStatus privacyStatus);

@interface ALAssetsLibrary (Additions)
+(ALAssetsLibrary *)sharedLibrary;

+ (void) requestAccessPrivacyWithCompletion:(AssetsLibraryPrivacyRequestAccessCompletionHandler) completion;
+ (AssetsLibraryPrivacyStatus) privacyStatus;
// get privacy status, if NotDetermined then request access and return block.
+ (void) privacyStatusAndRequestAccessWithBlock:(AssetsLibraryPrivacyStatusHandler)privacyStatusHandler;

@end


@interface ALAsset (additions)

- (BOOL) exportDataToURL: (NSURL*) fileURL error: (NSError**) error;
- (BOOL)exportFullResolutionToPath:(NSString*)toPath;

- (CGImageRef) assetThumbnail;

@end


@interface ALAssetRepresentation (additions)

- (NSString*)assetFilename;

@end





@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end


@interface NSURL (NSURL_Asset)
- (NSURL*) fromExternalForm;
- (NSURL*) toExternalForm;
- (NSString*) toExternalFilename;
@end




