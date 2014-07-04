//
//  NumberInputCellTableViewCell.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月23日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextLabelCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, retain) IBOutlet UILabel* contentLabel;
@property (nonatomic, retain) IBOutlet UILabel* mainLabel;
@end
