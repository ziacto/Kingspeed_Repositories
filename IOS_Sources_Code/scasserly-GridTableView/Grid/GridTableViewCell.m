//
//  GridTableViewCell.m
//  Grid
//
//  Created by Sean Casserly on 4/6/11.
//  Copyright 2011 Sean Casserly. All rights reserved.
//

#import "GridTableViewCell.h"

#define cell1Width 80
#define cell2Width 80
#define cellHeight 44

@implementation GridTableViewCell

@synthesize lineColor, topCell;//, cell1, cell2, cell3;
@synthesize cellsArray = _cellsArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier column:(int) col
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

		topCell = NO;
        _cellsArray = [[NSMutableArray alloc] init];
		
		// Add labels for the three cells
        CGFloat x = 0;
        _cellWidth = 320/col;
        for (int i = 0; i < col; i++) {
            UICell *cell = [[UICell alloc] initWithFrame:CGRectMake(x, 0, _cellWidth, cellHeight)];
            cell.textAlignment = UITextAlignmentCenter;
            cell.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
            cell.font = [UIFont systemFontOfSize:13];
            [self addSubview:cell];
            [_cellsArray addObject:cell];
            [cell release];
            x += _cellWidth;
        }
    }
    return self;
}

- (UICell*) cellAtColumn:(int)col
{
    if (col >= _cellsArray.count) {
        return nil;
    }
    return [_cellsArray objectAtIndex:col];
}
- (int) columnCount
{
    return _cellsArray.count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);       
	 
	// CGContextSetLineWidth: The default line width is 1 unit. When stroked, the line straddles the path, with half of the total width on either side.
	// Therefore, a 1 pixel vertical line will not draw crisply unless it is offest by 0.5. This problem does not seem to affect horizontal lines.
	CGContextSetLineWidth(context, 1.0);

	// Add the vertical lines
    for (int i = 0; i < _cellsArray.count; i++) {
        CGContextMoveToPoint(context, _cellWidth*i+0.5, 0);
        CGContextAddLineToPoint(context, _cellWidth*i+0.5, rect.size.height);
    }

	// Add bottom line
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5);
	
	// If this is the topmost cell in the table, draw the line on top
	if (topCell)
	{
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, rect.size.width, 0);
	}
	
	// Draw the lines
	CGContextStrokePath(context); 
}

- (void)setTopCell:(BOOL)newTopCell
{
	topCell = newTopCell;
	[self setNeedsDisplay];
}

@end







@implementation UICell

@synthesize isEditContent = _isEnter;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect fr = CGRectMake(0, (frame.size.height-25)/2., frame.size.width, 25);
        _enterText = [[UITextField alloc] initWithFrame:fr];
        [self addSubview:_enterText];
        _enterText.font = [UIFont systemFontOfSize:13];
        [_enterText release];
        _enterText.hidden = YES;
        _isEnter = NO;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) setIsEditContent:(BOOL)isEditContent_
{
    _isEnter = isEditContent_;
    if (_isEnter)   { [_enterText setHidden:NO]; [_enterText becomeFirstResponder]; _enterText.text = self.text; self.text = @""; }
    else            {[_enterText setHidden:YES]; [_enterText resignFirstResponder]; self.text = _enterText.text; _enterText.text = @""; }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    if (touch.tapCount == 2 && CGRectContainsPoint(self.frame, touchPoint)) {
        [self setIsEditContent:YES];
    }
    else [self setIsEditContent:NO];
}

@end






