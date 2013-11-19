//
//  UIButton+Scale.m
//  WomanCalendar
//
//  Created by iMac Vinicorp on 11/08/10.
//  Copyright 2011 VietNhat. All rights reserved.
//

#import "UIButton+Scale.h"


@implementation UIButton (scale)

-(CGRect)scaleWithRatio:(double)dRatio
{
    double dDiffWidth = self.frame.size.width/2  - self.imageView.image.size.width * dRatio/2;
    double dDiffHeight = self.frame.size.height/2  - self.imageView.image.size.height * dRatio/2;
    
    CGRect rect = CGRectMake(self.frame.origin.x + dDiffWidth, 
                             self.frame.origin.y + dDiffHeight,
                             self.imageView.image.size.width*dRatio, self.imageView.image.size.height*dRatio);
    
    return rect;
}

@end