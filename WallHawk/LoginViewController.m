//
//  ViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月23日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "LoginViewController.h"

#import "TextInputCell.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"View will appear");
    self.navigationController.navigationBar.hidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"View will Disappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap:(UITapGestureRecognizer*) gr
{
    [self.view endEditing:YES];
    [self saveUserDefault];
}


- (void) saveUserDefault
{
    [[NSUserDefaults standardUserDefaults] setObject:userNameField.text forKey:kCacheUserLoginName];
    [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:kCacheUserPassword];
    return;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    
    NSString *MyIdentifier = @"TextInputCell";
    TextInputCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [_tableView registerNib:[UINib nibWithNibName:MyIdentifier bundle:nil]  forCellReuseIdentifier:MyIdentifier];
        cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        //cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }

    switch (row) {
        case 0:
        {
            cell.mainLabel.text = @"Username";
            userNameField = cell.inputField;
            userNameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kCacheUserLoginName];
            break;
        }
        case 1:
        {
            cell.mainLabel.text = @"Password";
            [cell.inputField setSecureTextEntry:true];
            passwordField = cell.inputField;
            passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kCacheUserPassword];
            break;
        }
        default:
        {
            NSLog(@"*****Error: Unknown cell index");
            break;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //do nothing
}

- (IBAction)LoginPressed:(id)sender
{
    NSLog(@"Login pressed: %@, %@", userNameField.text, passwordField.text);
    
    [self saveUserDefault];
    
    loginResult = kLoginRunning;
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(0.0, 0.0, 120.0, 120.0);
    activityIndicatorView.center = self.navigationController.view.center;
    activityIndicatorView.hidden = NO;
    self.navigationController.view.userInteractionEnabled = NO;
    [self.navigationController.view addSubview: activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    //load all user default from server
    [self performSelectorInBackground:@selector(Login:)
                           withObject:nil];
    return;
}

- (void) whenLoginEnd:(NSDictionary*) prm
{
    self.navigationController.view.userInteractionEnabled = YES;
    [activityIndicatorView stopAnimating];
    
    switch (loginResult) {
        case kLoginFailDueToConnection:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Fail"
                                                           message: @"Please try again"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        case kLoginFailDueToInfo:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Fail"
                                                           message: @"Username or password incorrect"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        case kLoginFailDueToJSON:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Fail"
                                                           message: @"Please try again"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            break;
        }
        case kLoginSuccess:
        {
            [self performSegueWithIdentifier:@"GoToMainPanel" sender:self];
            break;
        }
        default:
            break;
    }
}

- (void) Login:(NSDictionary*) prm
{
    //load the keys
    NSString* userName = userNameField.text;
    NSString* password = passwordField.text;
    
    NSLog(@"Login with:");
    NSLog(@"User: %@", userName);
    NSLog(@"Password: %@", password);
    
    //create a web service request
    NSString *post =[[NSString alloc] initWithFormat:@"un=%@&pw=%@",userName,password];
    NSLog(@"PostData: %@",post);
    NSURL *url=[NSURL URLWithString:@"http://hksp.sillycube.com/wallhawk/mobile.php?action=user_login"];
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
            NSLog(@"Error in parsing JSON: %@", [error localizedDescription]);
            loginResult = kLoginFailDueToJSON;
            [self performSelectorOnMainThread:@selector(whenLoginEnd:) withObject:nil waitUntilDone:NO];
            return;
        }
        
        NSLog(@"JSON: %@", jsonData);
        
        //analyse the result
        NSString* reason = jsonData[@"reason"];// stringValue];
        NSLog(@"Reason: %@", reason);
        
        bool result = [jsonData[@"result"] boolValue];
        if(result)
        {
            NSLog(@"Result OK");
            loginResult = kLoginSuccess;
            [self performSelectorOnMainThread:@selector(whenLoginEnd:) withObject:nil waitUntilDone:NO];
            return;
        }
        else
        {
            NSLog(@"Result fail");
            loginResult = kLoginFailDueToInfo;
            [self performSelectorOnMainThread:@selector(whenLoginEnd:) withObject:nil waitUntilDone:NO];
            return;
        }
    } else {
        loginResult = kLoginFailDueToConnection;
        [self performSelectorOnMainThread:@selector(whenLoginEnd:) withObject:nil waitUntilDone:NO];
        return;
    }
}

@end
