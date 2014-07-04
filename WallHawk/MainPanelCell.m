//
//  MainPanelCell.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月24日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "MainPanelCell.h"

@implementation MainPanelCell

@synthesize webView;
@synthesize addressButton;

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentMode = UIViewContentModeScaleToFill;
}

- (void)setFrame:(CGRect)frame {
    if (self.superview){
        float cellWidth = self.superview.frame.size.width;
        //frame.origin.x = (self.superview.frame.size.width - cellWidth) / 2;
        NSLog(@"Set Width: %f", cellWidth);
        frame.size.width = cellWidth;
    }
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error In WebView: %@", [error localizedDescription]);
}

- (IBAction)addressPressed:(id)sender
{
    UIButton* addressBtn = (UIButton*) sender;
    NSLog(@"%@ pressed", addressBtn.titleLabel.text);
    NSMutableDictionary* addressInfo = [[NSMutableDictionary alloc] init];
    [addressInfo setObject:addressBtn.titleLabel.text forKey:kAddressKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddressPressed object:self userInfo:addressInfo];
}

@end
