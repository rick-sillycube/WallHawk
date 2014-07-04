//
//  ViewController.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月23日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

#define kLoginFailDueToConnection 1
#define kLoginFailDueToJSON 2
#define kLoginFailDueToInfo 3
#define kLoginSuccess 100
#define kLoginRunning 999

@interface LoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int loginResult;
    UIActivityIndicatorView *activityIndicatorView;
    
    UITextField* userNameField;
    UITextField* passwordField;
}
- (IBAction)LoginPressed:(id)sender;
@end
