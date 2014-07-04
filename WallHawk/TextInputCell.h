//
//  TextInputCell.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月23日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, retain) IBOutlet UITextField* inputField;
@property (nonatomic, retain) IBOutlet UILabel* mainLabel;
@end
