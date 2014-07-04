//
//  ProfileViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年7月2日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "ProfileViewController.h"

#import "TextInputCell.h"
#import "TextLabelCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize previousDisplayType;

@synthesize userName;
@synthesize password;
@synthesize email;
@synthesize website;
@synthesize phoneNumber;
@synthesize displayType;

@synthesize userNameField;
@synthesize passwordField;
@synthesize emailField;
@synthesize webSiteField;
@synthesize phoneNumberField;
@synthesize displayTypeLabel;

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    float NavigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    headerView = [[MainPanelNavigationControllerHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth*0.5, NavigationBarHeight)];
    UIImage *image = [UIImage imageNamed:@"logo_header.png"];
    [headerView.imageView setImage:image];
    [headerView.titleLabel setText:@"+ 24 Credit"];
    headerView.titleLabel.textAlignment = NSTextAlignmentCenter;
    headerView.titleLabel.textColor = [UIColor grayColor];
    [headerView.titleLabel setFont:[UIFont systemFontOfSize:12]];
    self.navigationItem.titleView = headerView;
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    
    isEditing = false;
    previousDisplayType = nil;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.navigationController.view.center;
    activityIndicatorView.hidden = NO;
    [self.navigationController.view addSubview: activityIndicatorView];
    [self setUserInteractionEnabled:NO];
    [activityIndicatorView startAnimating];
    
    //load all user default from server
    [self performSelectorInBackground:@selector(getProfileFromServer:)
                           withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    //update the naviagation bar
    self.navigationController.navigationBar.translucent = NO;
    
    //reload displayType
    displayType = [[NSUserDefaults standardUserDefaults] objectForKey:kDisplayTypeDefaultKey];
    
    //reset table
    [tableView reloadData];
    
    //check whether display type is the same
    if(previousDisplayType != nil && [displayType compare:previousDisplayType] != NSOrderedSame)
    {
        activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = self.navigationController.view.center;
        activityIndicatorView.hidden = NO;
        [self.navigationController.view addSubview: activityIndicatorView];
        [self setUserInteractionEnabled:NO];
        [activityIndicatorView startAnimating];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        NSNumber* updateType = [NSNumber numberWithInt:kUpdateDisplayType];
        NSString* value = [NSString stringWithString:displayType];
        [dict setObject:updateType forKey:@"updateType"];
        [dict setObject:value forKey:@"value"];
        [self performSelectorInBackground:@selector(updateProfile:)
                               withObject:dict];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUserInteractionEnabled:(bool) enable
{
    self.view.userInteractionEnabled = enable;
    self.navigationController.view.userInteractionEnabled = enable;
    self.tabBarController.view.userInteractionEnabled = enable;
}

- (void)tap:(UITapGestureRecognizer*) gr
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(isEditing)
    {
        NSLog(@"Not allow %d to edit", textField.tag);
        return NO;
    }
    else
    {
        NSLog(@"Allow %d to edit", textField.tag);
        return YES;
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textField %d start editing", textField.tag);
    isEditing = true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textField %d end editing", textField.tag);
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.navigationController.view.center;
    activityIndicatorView.hidden = NO;
    [self.navigationController.view addSubview: activityIndicatorView];
    [self setUserInteractionEnabled:NO];
    [activityIndicatorView startAnimating];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSNumber* updateType = [NSNumber numberWithInt:textField.tag];
    NSString* value = [NSString stringWithString:textField.text];
    [dict setObject:updateType forKey:@"updateType"];
    [dict setObject:value forKey:@"value"];
    [self performSelectorInBackground:@selector(updateProfile:)
                           withObject:dict];
}

- (void) getProfileFromServer:(NSDictionary*) prm
{
    //create a web service request
    NSURL *url=[NSURL URLWithString:@"http://hksp.sillycube.com/wallhawk/mobile.php?action=user_getInfo"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
        if(error == nil)
        {
            NSLog(@"JSON: %@", jsonData);
            
            userName = (NSString*) jsonData[@"name_display"];
            password = kDefaultPassword;
            email =  (NSString*) jsonData[@"email"];
            website = (NSString*) jsonData[@"website"];
            phoneNumber =  (NSString*) jsonData[@"phone"];
            displayType = (NSString*) jsonData[@"contact_display"];
            
            //cache the data for restore
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserNameDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPasswordDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:kEmailDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:website forKey:kWebSiteDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:kPhoneNumberDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:displayType forKey:kDisplayTypeDefaultKey];
        }
        else
            NSLog(@"Error: %@", [error localizedDescription]);
    }
    else
    {
        //use default - email
        displayType = @"e";
        [[NSUserDefaults standardUserDefaults] setObject:kDisplayTypeEmail forKey:kDisplayTypeDefaultKey];
    }
    
    //reset table
    [tableView reloadData];
    
    [self setUserInteractionEnabled:YES];
    [activityIndicatorView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    return;
}

- (void)updateProfile:(NSDictionary *)args {
    NSNumber* _updateType = [args objectForKey:@"updateType"];
    NSString* value = [args objectForKey:@"value"];
    int updateType = (_updateType == nil)? -1 : [_updateType integerValue];
    NSString* updateTypeAction;
    NSString* parameterString;
    
    NSLog(@"updateType: %d", updateType);
    
    switch (updateType) {
        case kUpdatePassword:
            updateTypeAction = @"user_updatePassword";
            parameterString = [NSString stringWithFormat:@"pw=%@", value];
            break;
        case kUpdateEmail:
            updateTypeAction = @"user_updateEmail";
            parameterString = [NSString stringWithFormat:@"email=%@", value];
            break;
        case kUpdateWebsite:
            updateTypeAction = @"user_updateWebsite";
            parameterString = [NSString stringWithFormat:@"website=%@", value];
            break;
        case kUpdatePhone:
            updateTypeAction = @"user_updatePhone";
            parameterString = [NSString stringWithFormat:@"phone=%@", value];
            break;
        case kUpdateDisplayType:
            updateTypeAction = @"user_updateContactDisplay";
            parameterString = [NSString stringWithFormat:@"display=%@", value];
            break;
        default:
            updateResult = -1;
            [self performSelectorOnMainThread:@selector(whenUpdateEnd:) withObject:nil waitUntilDone:NO];
            return;
    }
    
    //debug
    NSLog(@"updateTypeAction %@", updateTypeAction);
    NSLog(@"With value: %@", value);
    
    //create a web service request
    NSString *post = parameterString;
    NSString *urlString = [NSString stringWithFormat:@"http://hksp.sillycube.com/wallhawk/mobile.php?action=%@", updateTypeAction];
    NSURL *url=[NSURL URLWithString:urlString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
        if(error)
        {
            updateResult = kUpdateFailDueToConnection;
            [self performSelectorOnMainThread:@selector(whenUpdateEnd:) withObject:nil waitUntilDone:NO];
            return;
        }
        
        NSLog(@"JSON: %@", jsonData);
        
        //analyse the result
        bool result = [jsonData[@"result"] boolValue];
        if(result)
        {
            updateResult = kUpdateSuccess;
            [self performSelectorOnMainThread:@selector(whenUpdateEnd:) withObject:nil waitUntilDone:NO];
            return;
        }
        else
        {
            updateResult = kUpdateFailDueToInfo;
            updateError = (NSString*) jsonData[@"reason"];
            [self performSelectorOnMainThread:@selector(whenUpdateEnd:) withObject:nil waitUntilDone:NO];
            return;
        }
    } else {
        updateResult = kUpdateFailDueToConnection;
        [self performSelectorOnMainThread:@selector(whenUpdateEnd:) withObject:nil waitUntilDone:NO];
        return;
    }
}

- (void)whenUpdateEnd:(NSDictionary*) prms
{
    switch (updateResult) {
        case kUpdateFailDueToInfo:
        {
            NSLog(@"updateResult: kUpdateFailDueToInfo");
            //restore the fields
            [[NSUserDefaults standardUserDefaults] setObject:previousDisplayType forKey:kDisplayTypeDefaultKey];
            displayType = previousDisplayType;
            [tableView reloadData];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Update Fail"
                                                           message: updateError
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        case kUpdateFailDueToConnection:
        {
            NSLog(@"updateResult: kUpdateFailDueToConnection");
            
            //restore the fields
            [[NSUserDefaults standardUserDefaults] setObject:previousDisplayType forKey:kDisplayTypeDefaultKey];
            displayType = previousDisplayType;
            [tableView reloadData];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Update Fail"
                                                           message: @"Please try again"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        case kUpdateSuccess:
        {
            NSLog(@"updateResult: kUpdateSuccess");
            
            //update the cache
            password = passwordField.text;
            email = emailField.text;
            website = webSiteField.text;
            phoneNumber = phoneNumberField.text;
            previousDisplayType = displayType;  //Display type are no need to change the text as it already changed
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPasswordDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:kEmailDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:website forKey:kWebSiteDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:kPhoneNumberDefaultKey];
            [[NSUserDefaults standardUserDefaults] setObject:displayType forKey:kDisplayTypeDefaultKey];
            [tableView reloadData];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Update Success"
                                                           message: @""
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
        {
            NSLog(@"updateResult: %d", updateResult);
            break;
        }
    }
    
    isEditing = false;
    updateResult = -1;
    
    [self setUserInteractionEnabled:YES];
    [activityIndicatorView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    return;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 3;
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    if(section == 2)
        return @"Choose the contact which display to public";
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = [indexPath section];
    int row = [indexPath row];
    //NSLog(@"Section: %d", section);
    
    if(section == 0 && row == 0)
    {
        NSString *MyIdentifier = @"TextLabelCell";
        TextLabelCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            [_tableView registerNib:[UINib nibWithNibName:MyIdentifier bundle:nil]  forCellReuseIdentifier:MyIdentifier];
            cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        }
        
        cell.mainLabel.tag = kUpdateDisplayName;
        cell.mainLabel.text = @"Username";
        cell.contentLabel.text = userName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(section == 2)
    {
        NSString *MyIdentifier = @"TextLabelCell";
        TextLabelCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            [_tableView registerNib:[UINib nibWithNibName:MyIdentifier bundle:nil]  forCellReuseIdentifier:MyIdentifier];
            cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        }
        
        displayTypeLabel = cell.contentLabel;
        cell.mainLabel.tag = kUpdateDisplayType;
        cell.mainLabel.text = @"Display to others";
        
        if([displayType compare:kDisplayTypeEmail] == NSOrderedSame)
            cell.contentLabel.text = @"Email";
        else if ([displayType compare:kDisplayTypeWebsite] == NSOrderedSame)
            cell.contentLabel.text = @"Website";
        else
            cell.contentLabel.text = @"Phone";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (section == 3)
    {
        NSString *MyIdentifier = @"NormalCell";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"View my achived video";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSString *MyIdentifier = @"TextInputCell";
        TextInputCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            [_tableView registerNib:[UINib nibWithNibName:MyIdentifier bundle:nil]  forCellReuseIdentifier:MyIdentifier];
            cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        }
        
        switch (section) {
            case 0: //TextInputCell
            {
                switch (row) {
                    case 0:
                    {
                        cell.inputField.tag = kUpdateDisplayName;
                        cell.mainLabel.text = @"Username";
                        userNameField = cell.inputField;
                        userNameField.text = userName;
                        break;
                    }
                    case 1:
                    {
                        cell.inputField.tag = kUpdatePassword;
                        cell.mainLabel.text = @"Password";
                        cell.inputField.clearsOnBeginEditing = true;
                        [cell.inputField setSecureTextEntry:true];
                        passwordField = cell.inputField;
                        passwordField.text = password;
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case 1: //@"NumberInputCell"
            {
                switch (row) {
                    case 0:
                    {
                        cell.inputField.tag = kUpdateEmail;
                        cell.mainLabel.text = @"Email";
                        emailField = cell.inputField;
                        emailField.text = email;
                        break;
                    }
                    case 1:
                    {
                        cell.inputField.tag = kUpdateWebsite;
                        cell.mainLabel.text = @"Website";
                        webSiteField = cell.inputField;
                        webSiteField.text = website;
                        break;
                    }
                    case 2:
                    {
                        cell.inputField.tag = kUpdatePhone;
                        cell.mainLabel.text = @"Phone";
                        cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                        phoneNumberField = cell.inputField;
                        phoneNumberField.text = phoneNumber;
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
        }
        
        cell.inputField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = [indexPath section];
    int row = [indexPath row];
    
    NSLog(@"Clicked: %d %d", section, row);
    if(isEditing)
        return;
    else if(section == 2 && row == 0)
    {
        //for restore
        previousDisplayType = [[NSUserDefaults standardUserDefaults] objectForKey:kDisplayTypeDefaultKey];
        [self performSegueWithIdentifier:@"SelectDisplayType" sender:self];
    }
}

- (IBAction)creditPressed:(id)sender
{
    //...
}

- (IBAction)logoutPressed:(id)sender
{
    NSLog(@"Logout...");
    
    //create a web service request
    //NSString *post =[[NSString alloc] initWithFormat:@"un=%@&pw=%@",userName,password];
    //NSLog(@"PostData: %@",post);
    NSURL *url=[NSURL URLWithString:@"http://hksp.sillycube.com/wallhawk/mobile.php?action=user_logout"];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    //[request setHTTPMethod:@"POST"];
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setHTTPBody:postData];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
        if(error)
        {
            NSLog(@"Error in parsing JSON: %@", [error localizedDescription]);
            return;
        }
        
        NSLog(@"JSON: %@", jsonData);
        
        //analyse the result
        NSString* reason = jsonData[@"reason"];// stringValue];
        NSLog(@"Reason: %@", reason);
        
        bool result = [jsonData[@"result"] boolValue];
        if(result)
        {
            NSLog(@"Logout success");
            [self performSegueWithIdentifier:@"GoToLogin" sender:self];
            return;
        }
        else
        {
            NSLog(@"Logout fail");
            return;
        }
    } else {
        NSLog(@"Logout failed. %@", [error localizedDescription]);
        return;
    }
    
    return;
}

@end
