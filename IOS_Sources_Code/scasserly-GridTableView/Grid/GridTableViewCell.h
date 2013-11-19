//
//  GridTableViewCell.h
//  Grid
//
//  Created by Sean Casserly on 4/6/11.
//  Copyright 2011 Sean Casserly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICell;

@interface GridTableViewCell : UITableViewCell {
	
	UIColor *lineColor;
	BOOL topCell;
    
    NSMutableArray *_cellsArray;
    CGFloat _cellWidth;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier column:(int) col;

@property (nonatomic, retain) UIColor* lineColor;
@property (nonatomic) BOOL topCell;
@property (nonatomic, retain, readonly) NSMutableArray *cellsArray;

- (UICell*) cellAtColumn:(int)col;
- (int) columnCount;

@end






@interface UICell : UILabel
{
    UITextField *_enterText;
    BOOL _isEnter;
}

@property (nonatomic, assign) BOOL isEditContent;

@end









