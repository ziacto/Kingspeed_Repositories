//
//  ViewController.h
//  TestUIImageFilter
//
//  Created by iMac02 on 21/2/2013.
//  Copyright (c) 2013 iMac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+additions.h"

@interface ViewController : UIViewController
{
    IBOutlet UIImageView *_imageView;
    IBOutlet UISlider *_slider;
}

- (IBAction)sliderDidChangeValue:(UISlider*)sender;

@end
