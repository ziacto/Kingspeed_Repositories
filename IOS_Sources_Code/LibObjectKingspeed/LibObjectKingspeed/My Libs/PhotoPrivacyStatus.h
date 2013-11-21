//
//  PhotoPrivacyStatus.h
//  PhotoAlbum
//
//  Created by iMac02 on 24/10/2012.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, AssetsLibraryStatus) {
    AssetsLibraryStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
    AssetsLibraryStatusRestricted,        // This application is not authorized to access photo data.
    // The user cannot change this application’s status, possibly due to active restrictions
    //  such as parental controls being in place.
    AssetsLibraryStatusDenied,            // User has explicitly denied this application access to photos data.
    AssetsLibraryStatusAuthorized         // User has authorized this application to access photos data.
};

typedef void(^PhotoPrivacyRequestAccessCompletionHandler)(bool allow, NSError *error);

@interface PhotoPrivacyStatus : NSObject

+ (void) requestAccessPrivacyWithCompletion:(PhotoPrivacyRequestAccessCompletionHandler) completion;
+ (AssetsLibraryStatus) privacyStatus;

@end



