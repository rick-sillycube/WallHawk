//
//  MainPanelCell.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月24日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNotificationAddressPressed @"kNotificationAddressPressed"
#define kAddressKey @"kAddressKey"
#define kLatitudeKey @"kLatitudeKey"
#define kLongitudeKey @"kLongitudeKey"

@interface MainPanelCell : UITableViewCell <UIWebViewDelegate>
@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIButton* addressButton;
- (IBAction)addressPressed:(id)sender;
@end
