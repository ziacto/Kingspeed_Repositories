//
//  PhotoPrivacyStatus.m
//  PhotoAlbum
//
//  Created by iMac02 on 24/10/2012.
//
//

#import "PhotoPrivacyStatus.h"

@implementation PhotoPrivacyStatus

+ (void) requestAccessPrivacyWithCompletion:(PhotoPrivacyRequestAccessCompletionHandler) completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Group enumerator Block
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            completion(YES,nil);
        };
        
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            completion (NO,error);
        };
        
        // Enumerate Albums
        [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                      usingBlock:assetGroupEnumerator
                                                    failureBlock:assetGroupEnumberatorFailure];
    });
}

+ (AssetsLibraryStatus) privacyStatus
{
#if (__IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_1)
    return -1;
#else
    return [ALAssetsLibrary authorizationStatus];
#endif
}

@end
