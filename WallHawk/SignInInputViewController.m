//
//  SignInInputViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月23日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "SignInInputViewController.h"

#import "TextInputCell.h"
#import "TextLabelCell.h"

#import "DisplayTypeSelectionViewController.h"

@interface SignInInputViewController ()

@end

@implementation SignInInputViewController

@synthesize userNameField;
@synthesize passwordField;
@synthesize emailField;
@synthesize webSiteField;
@synthesize phoneNumberField;
@synthesize displayTypeField;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableView reloadData];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)tap:(UITapGestureRecognizer*) gr
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"";
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
    
    if(section < 2)
    {
        NSString *MyIdentifier = @"TextInputCell";
        TextInputCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            [_tableView registerNib:[UINib nibWithNibName:MyIdentifier bundle:nil]  forCellReuseIdentifier:MyIdentifier];
            cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        }
        
        switch (section) {
            case 0:
            {
                switch (row) {
                    case 0:
                    {
                        cell.mainLabel.text = @"Username";
                        userNameField = cell.inputField;
                        //userNameField.text = userName;
                        break;
                    }
                    case 1:
                    {
                        cell.mainLabel.text = @"Password";
                        [cell.inputField setSecureTextEntry:true];
                        passwordField = cell.inputField;
                        //passwordField.text = password;
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case 1:
            {
                switch (row) {
                    case 0:
                    {
                        cell.mainLabel.text = @"Email";
                        cell.inputField.keyboardType = UIKeyboardTypeEmailAddress;
                        emailField = cell.inputField;
                        //emailField.text = email;
                        break;
                    }
                    case 1:
                    {
                        cell.mainLabel.text = @"Website";
                        cell.inputField.keyboardType = UIKeyboardTypeWebSearch;
                        webSiteField = cell.inputField;
                        //webSiteField.text = website;
                        break;
                    }
                    case 2:
                    {
                        cell.mainLabel.text = @"Phone";
                        cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                        phoneNumberField = cell.inputField;
                        //phoneNumberField.text = phoneNumber;
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSString *MyIdentifier = @"TextLabelCell";
        TextLabelCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            [_tableView registerNib:[UINib nibWithNibName:MyIdentifier bundle:nil]  forCellReuseIdentifier:MyIdentifier];
            cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        }
        
        displayTypeField = cell.contentLabel;
        cell.mainLabel.text = @"Display to others";
        NSString* displayType = [[NSUserDefaults standardUserDefaults] objectForKey:kDisplayTypeDefaultKey];
        
        if(displayType == nil || [displayType compare:kDisplayTypeEmail] == NSOrderedSame)
            cell.contentLabel.text = @"Email";
        else if ([displayType compare:kDisplayTypeWebsite] == NSOrderedSame)
            cell.contentLabel.text = @"Website";
        else
            cell.contentLabel.text = @"Phone";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = [indexPath section];
    int row = [indexPath row];
    
    NSLog(@"Clicked: %d %d", section, row);
    if(section == 2 && row == 0)
    {
        [self performSegueWithIdentifier:@"SelectDisplayType" sender:self];
    }
}

- (IBAction)SignUpPressed:(id)sender
{
    signInResult = kSignInRunning;
    signInError = nil;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.navigationController.view.center;
    activityIndicatorView.hidden = NO;
    self.navigationController.view.userInteractionEnabled = NO;
    [self.navigationController.view addSubview: activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    //load all user default from server
    [self performSelectorInBackground:@selector(registerToServer:)
                           withObject:nil];

    /*
    //send a register request to server
    NSString* errorInfo = [self registerToServer];
    if(errorInfo == nil)
        NSLog(@"Sign up success");
    else
        NSLog(@"Sign up fail: %@", errorInfo);
    */
    
    return;
}

- (void) whenRegisterEnd:(NSDictionary*) prm
{
    self.navigationController.view.userInteractionEnabled = YES;
    [activityIndicatorView stopAnimating];
    
    switch (signInResult) {
        case kSignInFailDueToConnection:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Sign Up Fail"
                                                           message: @"Please try again"
                                                          delegate: nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        case kSignInFailDueToInput:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Sign Up Fail"
                                                           message: signInError
                                                          delegate: nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        case kSignInSuccess:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Sign Up Success"
                                                           message: @"Thank you!"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Pop");
    [self.navigationController popViewControllerAnimated:true];
}

- (void) registerToServer:(NSDictionary*) prm
{
    //load the keys
    NSString* _userName = userNameField.text;
    NSString* _password = passwordField.text;
    NSString* _email = emailField.text;
    NSString* _webSite = webSiteField.text;
    NSString* _phoneNumber = phoneNumberField.text;
    NSString* _displayType = displayTypeField.text;
    
    NSString* displayType_short;
    if([_displayType compare:@"Email"] == NSOrderedSame)
        displayType_short = @"e";
    else if ([_displayType compare:@"Website"] == NSOrderedSame)
        displayType_short = @"w";
    else
        displayType_short = @"p";
    
    NSLog(@"Register with:");
    NSLog(@"User: %@", _userName);
    NSLog(@"Password: %@", _password);
    NSLog(@"Email: %@", _email);
    NSLog(@"Website: %@", _webSite);
    NSLog(@"Phone: %@", _phoneNumber);
    NSLog(@"DisplayType: %@", _displayType);
    
    //create a web service request
    NSString *post =[[NSString alloc] initWithFormat:@"un=%@&dn=%@&pw=%@&email=%@&phone=%@&website=%@&displayType=%@",_userName,_userName,_password,_email,_phoneNumber,_webSite,displayType_short];
    NSLog(@"PostData: %@",post);
    NSURL *url=[NSURL URLWithString:@"http://hksp.sillycube.com/wallhawk/mobile.php?action=user_create"];
    //[NSURL URLWithString:@"http://192.168.0.187/wallhawk/mobile.php?action=user_create"];
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
            signInResult = kSignInFailDueToConnection;
        else
            NSLog(@"JSON: %@", jsonData);
        
        //analyse the result
        bool result = [jsonData[@"result"] boolValue];
        if(result)
            signInResult = kSignInSuccess;
        else
        {
            signInError = jsonData[@"reason"];
            signInResult = kSignInFailDueToInput;
        }
    }
    else
        signInResult = kSignInFailDueToConnection;
    
    [self performSelectorOnMainThread:@selector(whenRegisterEnd:) withObject:nil waitUntilDone:NO];
}

@end
