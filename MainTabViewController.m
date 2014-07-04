//
//  MainTabViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月30日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOutPressed:(id)sender
{
    NSLog(@"SignOut pressed");
    
    //try to logout...
    
    NSLog(@"Logout...");
    
    //create a web service request
    //NSString *post =[[NSString alloc] initWithFormat:@"un=%@&pw=%@",userName,password];
    //NSLog(@"PostData: %@",post);
    NSURL *url=[NSURL URLWithString:@"http://hksp.sillycube.com/wallhawk/mobile.php?action=user_logout"];
    //[NSURL URLWithString:@"http://192.168.0.187/wallhawk/mobile.php?action=user_logout"];
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
            NSLog(@"Result OK");
            [self.navigationController popToRootViewControllerAnimated:true];
            return;
        }
        else
        {
            NSLog(@"Result fail");
            return;
        }
    } else {
        //if (error) NSLog(@"Error: %@", error);
        NSLog(@"Sign out failed. %@", [error localizedDescription]);
        return;
    }
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

@end
