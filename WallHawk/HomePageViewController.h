//
//  HomePageViewController.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年7月2日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController
{
    int numberOfThumbnail;
    NSTimer* scrollTimer;
}
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
- (IBAction)SignUpPressed:(id)sender;
- (IBAction)LoginPressed:(id)sender;
@end
