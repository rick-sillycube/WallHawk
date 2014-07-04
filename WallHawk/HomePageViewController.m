//
//  HomePageViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年7月2日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                        scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    
    //int numberOfImage = [self requestImage];
    
    //testing
    numberOfThumbnail = 1;
    int i = 0;
    while (i < numberOfThumbnail) {
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((scrollView.frame.size.width)*i, 0,
                                                                              scrollView.frame.size.width, scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"demo_thumbnail.png"];
        [imageView setTag:i];
        [scrollView addSubview:imageView];
        i++;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"View will appear");
    
    //start auto scroll
    self.navigationController.navigationBar.hidden = YES;
    if(numberOfThumbnail > 1)
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"View will Disappear");
    self.navigationController.navigationBar.hidden = NO;
    
    //stop auto scroll
    if(scrollTimer != nil)
        [scrollTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*) requestImage
{
    //return number of image loaded
    NSMutableArray* imageArray = [[NSMutableArray alloc] init];
    
    return imageArray;
}

static int currentPage = 0;
- (void) scrollToNextPage
{
    int nextPage = currentPage + 1;
    if(nextPage > numberOfThumbnail)
        nextPage = 0;
    
    NSLog(@"Scroll to page: %d",nextPage);
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * nextPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    currentPage = nextPage;
    return;
}

- (IBAction)LoginPressed:(id)sender
{
    //let user input name and password
    [self performSegueWithIdentifier:@"GoToLoginPage" sender:self];
    return;
}

- (IBAction)SignUpPressed:(id)sender
{
    [self performSegueWithIdentifier:@"GoToSignUpSetting" sender:self];
    return;
}

@end
