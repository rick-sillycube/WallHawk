//
//  MainPanelViewController.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月24日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MapViewController.h"

@interface MainPanelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (nonatomic, retain) IBOutlet UITableView* movieTable;
@property (nonatomic, retain) MapViewController* mapView;
@end
