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

#import "ALAssetsLibrary+Additions.h"

@implementation ALAssetsLibrary (Additions)
+(ALAssetsLibrary *)sharedLibrary
{
	static dispatch_once_t onceToken;
	static ALAssetsLibrary *shared = nil;
	dispatch_once(&onceToken, ^{
		shared = [[ALAssetsLibrary alloc] init];
	});
	return shared;
}

+ (void) requestAccessPrivacyWithCompletion:(AssetsLibraryPrivacyRequestAccessCompletionHandler) completion
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

+ (AssetsLibraryPrivacyStatus) privacyStatus
{
#if (__IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_1 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_0 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_3 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_2 ||    __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_1 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_0)
    if ([UIDevice iosVersion] <= 4.2) {
        return [CLLocationManager locationServicesEnabled] == YES ? AssetsLibraryPrivacyStatusAuthorized : AssetsLibraryPrivacyStatusDenied;
    }
    else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            return AssetsLibraryPrivacyStatusNotDetermined;
        }
        else {
            if ([CLLocationManager locationServicesEnabled]) {
                return (AssetsLibraryPrivacyStatus)[CLLocationManager authorizationStatus];
            }
            else {
                return AssetsLibraryLocationServiceOFF;
            }
        }
    }
#else
    if ([UIDevice iosVersion] <= 4.2) {
        return [CLLocationManager locationServicesEnabled] == YES ? AssetsLibraryPrivacyStatusAuthorized : AssetsLibraryPrivacyStatusDenied;
    }
    else if ([UIDevice iosVersion] < 6.0) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            return AssetsLibraryPrivacyStatusNotDetermined;
        }
        else {
            if ([CLLocationManager locationServicesEnabled]) {
                return (AssetsLibraryPrivacyStatus)[CLLocationManager authorizationStatus];
            }
            else {
                return AssetsLibraryLocationServiceOFF;
            }
        }
    }
    else {
        return (AssetsLibraryPrivacyStatus)[ALAssetsLibrary authorizationStatus];
    }
#endif
}

+ (void) privacyStatusAndRequestAccessWithBlock:(AssetsLibraryPrivacyStatusHandler)privacyStatusHandler
{
    if ([ALAssetsLibrary privacyStatus] == AssetsLibraryPrivacyStatusNotDetermined) {
        [ALAssetsLibrary requestAccessPrivacyWithCompletion:^(bool allow, NSError *error) {
            if (allow) {
                privacyStatusHandler(AssetsLibraryPrivacyStatusAuthorized);
            }
            else {
                privacyStatusHandler(AssetsLibraryPrivacyStatusDenied);
            }
        }];
        return;
    }
    else {
        privacyStatusHandler([ALAssetsLibrary privacyStatus]);
    }
}

@end




static const NSUInteger BufferSize = 1024*1024;

@implementation ALAsset (additions)

- (BOOL) exportDataToURL: (NSURL*) fileURL error: (NSError**) error
{
    [[NSFileManager defaultManager] createFileAtPath:[fileURL path] contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:fileURL error:error];
    if (!handle) {
        return NO;
    }
    
    ALAssetRepresentation *rep = [self defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:error];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            return NO;
        }
    } while (bytesRead > 0);
    
    free(buffer);
    return YES;
}
- (BOOL)exportFullResolutionToPath:(NSString*)toPath
{
    [[NSFileManager defaultManager] createFileAtPath:toPath contents:nil attributes:nil];
    NSOutputStream *outPutStream = [NSOutputStream outputStreamToFileAtPath:toPath append:YES];
    [outPutStream open];
    
    long long offset = 0;
    long long bytesRead = 0;
    
    NSError *error;
    uint8_t * buffer = malloc(131072);
    while (offset<[[self defaultRepresentation] size] && [outPutStream hasSpaceAvailable]) {
        bytesRead = [[self defaultRepresentation] getBytes:buffer fromOffset:offset length:131072 error:&error];
        [outPutStream write:buffer maxLength:bytesRead];
        offset = offset+bytesRead;
    }
    [outPutStream close];
    free(buffer);
    
    if (offset > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (CGImageRef) assetThumbnail
{
#if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_3 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_2 ||    __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_1 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_0)
    return [self thumbnail];
#else
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 5.0) {
        return [self thumbnail];
    }
    else {
        return [self aspectRatioThumbnail];
    }
#endif
}

@end


@implementation ALAssetRepresentation (additions)

- (NSString*)assetFilename
{
#if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_3 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_2 ||    __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_1 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_0)
    return [[self url] toExternalFilename];
#else
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 5.0) {
        return [[self url] toExternalFilename];
    }
    else {
        return [self filename];
    }
#endif
}

@end


@implementation URLParser
@synthesize variables;

- (id) initWithURLString:(NSString *)url{
    self = [super init];
    if (self != nil) {
        NSString *string = url;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempString;
        NSMutableArray *vars = [NSMutableArray new];
        [scanner scanUpToString:@"?" intoString:nil];       //ignore the beginning of the string and skip to the vars
        while ([scanner scanUpToString:@"&" intoString:&tempString]) {
            [vars addObject:[tempString copy]];
        }
        self.variables = vars;
    }
    return self;
}

- (NSString *)valueForVariable:(NSString *)varName {
    for (NSString *var in self.variables) {
        if ([var length] > [varName length]+1 && [[var substringWithRange:NSMakeRange(0, [varName length]+1)] isEqualToString:[varName stringByAppendingString:@"="]]) {
            NSString *varValue = [var substringFromIndex:[varName length]+1];
            return varValue;
        }
    }
    return nil;
}

@end


static NSString *const EXTERNAL_TOKEN = @"/assetExternalForm/";
@implementation NSURL (NSURL_Asset)

// assets-library://asset/asset.JPG/assetExternalForm/1000000001.JPG -> assets-library://asset/asset.JPG?id=1000000001&ext=JPG
- (NSURL*) fromExternalForm {
    if([self.scheme isEqualToString:@"assets-library"]) {
        NSRange slash = [self.absoluteString rangeOfString:EXTERNAL_TOKEN options:NSBackwardsSearch];
        if(slash.location != NSNotFound) {
            
            NSRange dot = [self.absoluteString rangeOfString:@"." options:NSBackwardsSearch];
            
            if(dot.location != NSNotFound) {
                NSString* extention = [self.absoluteString substringFromIndex:(dot.location + dot.length)];
                NSString* identifier = [self.absoluteString substringWithRange:NSMakeRange(slash.location + slash.length, dot.location - (slash.location + slash.length))];
                return [NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&ext=%@", [self.absoluteString substringToIndex:slash.location], identifier, extention]];
            }
        }
    }
    return self;
}
// assets-library://asset/asset.JPG?id=1000000001&ext=JPG -> assets-library://asset/asset.JPG/assetExternalForm/1000000001.JPG
- (NSURL*) toExternalForm {
    if([self.scheme isEqualToString:@"assets-library"]) {
        NSRange range = [self.absoluteString rangeOfString:@"?"];
        if(range.location != NSNotFound) {
            URLParser *parser = [[URLParser alloc] initWithURLString:self.absoluteString];
            NSString* extention = [parser valueForVariable:@"ext"];
            NSString* identifier = [parser valueForVariable:@"id"];
            if(extention != NULL && identifier != NULL) {
                return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@.%@", [self.absoluteString substringToIndex:range.location], EXTERNAL_TOKEN, identifier, extention]];
            }
        }
    }
    return self;
}
// assets-library://asset/asset.JPG?id=1000000001&ext=JPG -> 1000000001.JPG
- (NSString*) toExternalFilename {
    if([self.scheme isEqualToString:@"assets-library"]) {
        NSRange range = [self.absoluteString rangeOfString:@"?"];
        if(range.location != NSNotFound) {
            URLParser *parser = [[URLParser alloc] initWithURLString:self.absoluteString];
            NSString* extention = [parser valueForVariable:@"ext"];
            NSString* identifier = [parser valueForVariable:@"id"];
            
            if(extention != NULL && identifier != NULL) {
                return [NSString stringWithFormat:@"%@.%@", identifier, extention];
            }
        }
    }
    return NULL;
}

@end






