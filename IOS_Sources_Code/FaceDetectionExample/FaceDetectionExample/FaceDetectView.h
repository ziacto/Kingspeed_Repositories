//
//  FaceDetect.h
//  FaceDetectionExample
//
//  Created by iMac02 on 2012/7/19.
//  Copyright (c) 2012 JID Marketing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@interface FaceDetectView : UIImageView

- (void) faceDetector:(UIImage*) image;

@end
