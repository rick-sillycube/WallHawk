//
//  SignInInputViewController.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月23日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

#define kSignInRunning 200
#define kSignInSuccess 100
#define kSignInFailDueToInput 1
#define kSignInFailDueToConnection 2

@interface SignInInputViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int signInResult;
    UIActivityIndicatorView *activityIndicatorView;
    NSString* signInError;
    UIView* blackView;
}
//keep the input value
@property (nonatomic, retain) UITextField* userNameField;
@property (nonatomic, retain) UITextField* passwordField;
@property (nonatomic, retain) UITextField* emailField;
@property (nonatomic, retain) UITextField* webSiteField;
@property (nonatomic, retain) UITextField* phoneNumberField;
@property (nonatomic, retain) UILabel* displayTypeField;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
- (IBAction)SignUpPressed:(id)sender;
@end
