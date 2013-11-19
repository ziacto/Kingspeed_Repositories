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

#import "XIBBasedUIView.h"

@implementation XIBBasedUIView

+ (XIBBasedUIView *)viewFromNibNamed:(NSString *)nibName
{    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    return [nibContents objectAtIndex:0];
}

@end
