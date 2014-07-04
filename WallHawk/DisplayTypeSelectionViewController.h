//
//  DisplayTypeSelectionViewController.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月24日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface DisplayTypeSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int selectedIndex;
}
@end
