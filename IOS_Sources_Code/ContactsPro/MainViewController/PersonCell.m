//
//  PersonCell.m
//  ContactsPro
//
//  Created by Nguyen Mau Dat on 11/20/13.
//
//

#import "PersonCell.h"

@interface PersonCell ()

@property (nonatomic, retain) UIImageView *backgroundImageView;

@end

@implementation PersonCell
@synthesize backgroundImageView = _backgroundImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.backgroundImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bgr.png"]] autorelease];
//        self.backgroundView = self.backgroundImageView;
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBackgroundImageWith:(UITableView*)tblView forIndexPath:(NSIndexPath*)indexPath
{
    int numRows = [tblView numberOfRowsInSection:indexPath.section];
    if (numRows == 1 || indexPath.row == (numRows - 1)) {
//        self.backgroundImageView.image = [UIImage imageNamed:@"cell_bgr.png"];
    }
    else {
//        self.backgroundImageView.image = [UIImage imageNamed:@"cell_bgr_mid.png"];
    }
}

@end
