//
//  MainPanelViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月24日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "MainPanelViewController.h"

#import "MainPanelCell.h"
#import "PopUpViewController.h"

@interface MainPanelViewController ()

@end

@implementation MainPanelViewController

@synthesize movieTable;
@synthesize mapView;

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
    //self.navigationController.navigationBar.translucent = NO;
    
    // Do any additional setup after loading the view.
    /*
    //this is tab sub view, the parent own the navigation bar
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];
    
    //CGRect screenBound = [[UIScreen mainScreen] bounds];
    //CGSize screenSize = screenBound.size;
    //CGFloat screenWidth = screenSize.width;
    //CGFloat screenHeight = screenSize.height;
    
    float NavigationBarHeight = self.parentViewController.navigationController.navigationBar.frame.size.height;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, NavigationBarHeight)];
    [imageView setBackgroundColor:[UIColor redColor]];
    self.parentViewController.navigationItem.titleView = imageView;

    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentCenter;
    lbNavTitle.text = NSLocalizedString(@"Hello World!",@"Hello World!");
    self.navigationItem.titleView = lbNavTitle;
    */
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAddressPressNotification:)
                                                 name:kNotificationAddressPressed
                                               object:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //depends on server
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Width: %f", tableView.frame.size.width);
    return 579;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    NSLog(@"row: %d", row);
    
    NSString *MyIdentifier = @"MainPanelCell";
    MainPanelCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:MyIdentifier bundle:nil]  forCellReuseIdentifier:MyIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        //cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    // URL Request Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    
    // Load the request in the UIWebView
    [cell.webView loadRequest:requestObj];
    
    switch(row)
    {
        case 0:
        {
            [cell.addressButton setTitle:@"Yuen Long, Hong Kong" forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            [cell.addressButton setTitle:@"Tokyo, Japan" forState:UIControlStateNormal];
            break;
        }
        default:
        {
            [cell.addressButton setTitle:@"NewYork, USA" forState:UIControlStateNormal];
            break;
        }
    }
    
    /*
    switch (row) {
        case 0: //TextInputCell
        {
            switch (row) {
                case 0:
                {
                    cell.mainLabel.text = @"Username";
                    userNameField = cell.inputField;
                    userNameField.text = userName;
                    break;
                }
                case 1:
                {
                    cell.mainLabel.text = @"Password";
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
                    cell.mainLabel.text = @"Email";
                    emailField = cell.inputField;
                    emailField.text = email;
                    break;
                }
                case 1:
                {
                    cell.mainLabel.text = @"Website";
                    webSiteField = cell.inputField;
                    webSiteField.text = website;
                    break;
                }
                case 2:
                {
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = [indexPath section];
    int row = [indexPath row];
    
    NSLog(@"Clicked: %d %d", section, row);
}

NSString* address;
NSNumber* latitude;
NSNumber* longitude;
- (void) receiveAddressPressNotification:(NSNotification *)notification
{
    //NSLog(@"notification.object: %@", notification.object);
    NSDictionary* userInfo = [notification userInfo];
    address = [userInfo objectForKey:kAddressKey];
    
    mapView = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapView.address = address;
    
    //mapView.view.backgroundColor = [UIColor clearColor]; // can be with 'alpha'
    //mapView.modalPresentationStyle = UIModalPresentationCurrentContext;
    [mapView.view setFrame:[[UIScreen mainScreen] bounds]];
     //setFrame:[[UIScreen mainScreen] bounds]];
     [self.parentViewController.navigationController.view addSubview:mapView.view];
    //[self presentViewController:mapView animated:YES completion:NULL];
    //[self presentViewController:mapView animated:YES completion:nil];
    //[self.navigationController.view addSubview:mapView.view];
    
    //no transparent effect
    //[self presentViewController:mapView animated:YES completion:nil];
    return;
    
    //use add, to make a transparent view
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        PopUpViewController *vc = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController_iPad" bundle:nil];
        [vc setTitle:@"This is a popup view"];
        
        [vc showInView:self.navigationController.view withImage:[UIImage imageNamed:@"typpzdemo"] withMessage:@"You just triggered a great popup window" animated:YES];
    } else {
        PopUpViewController *vc = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
        [vc setTitle:@"This is a popup view"];
        
        [vc showInView:self.navigationController.view withImage:[UIImage imageNamed:@"typpzdemo"] withMessage:@"You just triggered a great popup window" animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ShowMap"])
    {
        // Get reference to the destination view controller
    }
}

@end
