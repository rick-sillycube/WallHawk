//
//  ProfileViewController.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年7月2日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "MainPanelNavigationControllerHeaderView.h"

#define kDefaultPassword @"aaaaaa"

#define kUpdateFailDueToConnection 1
#define kUpdateFailDueToInfo 3
#define kUpdateSuccess 100
#define kUpdateRunning 999

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    BOOL isEditing;
    MainPanelNavigationControllerHeaderView* headerView;
    int updateResult;
    NSString *updateError;
    UIActivityIndicatorView* activityIndicatorView;
}
@property (nonatomic, retain) NSString* previousDisplayType;

@property (nonatomic, retain) UITextField* userNameField;
@property (nonatomic, retain) UITextField* passwordField;
@property (nonatomic, retain) UITextField* emailField;
@property (nonatomic, retain) UITextField* webSiteField;
@property (nonatomic, retain) UITextField* phoneNumberField;
@property (nonatomic, retain) UILabel* displayTypeLabel;

//oringinal data used to compare
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* website;
@property (nonatomic, retain) NSString* phoneNumber;
@property (nonatomic, retain) NSString* displayType;

@property (nonatomic, retain) IBOutlet UITableView* tableView;
- (IBAction)creditPressed:(id)sender;
- (IBAction)logoutPressed:(id)sender;
@end
