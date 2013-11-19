//
//  ViewController.h
//  FaceDetectionExample
//
//  Created by Johann Dowa on 11-11-01.
//  Copyright (c) 2011 ManiacDev.Com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FaceDetectView.h"

@interface ViewController : UIViewController
{
    IBOutlet FaceDetectView *faceDetectView;
}

- (void) faceDetector;

@end
