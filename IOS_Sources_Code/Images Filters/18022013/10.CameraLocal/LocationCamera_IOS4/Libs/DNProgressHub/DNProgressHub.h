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

#import <UIKit/UIKit.h>

@interface DNProgressHub : UIView

+(DNProgressHub*)showHubToWindow;
+(DNProgressHub*)showHubToView:(UIView*)view;
+ (void)hideAllHubDNForWindow;
+ (void)hideAllHubDNForView:(UIView*)view;

@end
