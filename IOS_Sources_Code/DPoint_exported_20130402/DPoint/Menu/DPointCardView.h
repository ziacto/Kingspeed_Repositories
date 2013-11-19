//
//  DPointCardView.h
//
//  Copyright (c) 2013 Whogot Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPointCardView : UIImageView

- (id) initWithImageNamed:(NSString*)imageName;

- (void) setLabelString:(NSString*)labelString;

/**
 *	選択カードとしての処理.
 */
- (void) setupForCurrent;

/**
 *	選択カードとしての処理をクリア.
 */
- (void) clearCurrent;
 
@end
