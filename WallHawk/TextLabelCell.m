//
//  NumberInputCellTableViewCell.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月23日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "TextLabelCell.h"

@implementation TextLabelCell

@synthesize contentLabel;
@synthesize mainLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
