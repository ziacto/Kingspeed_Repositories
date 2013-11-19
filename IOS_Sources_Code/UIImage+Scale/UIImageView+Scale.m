//
//  UIImageView+Scale.h
//  Created by HungVH - Vinicorp on 08/09/2011.
//
//  

#import "UIImageView+Scale.h"

@implementation UIImageView (scale)

-(CGRect)scaleWithRatio:(double)dRatio
{
    double dDiffWidth = self.frame.size.width/2  - self.image.size.width * dRatio/2;
    double dDiffHeight = self.frame.size.height/2  - self.image.size.height * dRatio/2;
    
    CGRect rect = CGRectMake(self.frame.origin.x + dDiffWidth, 
                             self.frame.origin.y + dDiffHeight,
                             self.image.size.width*dRatio, self.image.size.height*dRatio);
    
    return rect;
}

@end