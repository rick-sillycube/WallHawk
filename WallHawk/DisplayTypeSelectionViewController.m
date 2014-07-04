//
//  DisplayTypeSelectionViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月24日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "DisplayTypeSelectionViewController.h"

@interface DisplayTypeSelectionViewController ()

@end

@implementation DisplayTypeSelectionViewController

//@synthesize selectedIndex;

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

- (void)viewWillAppear:(BOOL)animated
{
    NSString* displayType = [[NSUserDefaults standardUserDefaults] objectForKey:kDisplayTypeDefaultKey];
    if([displayType compare:kDisplayTypeEmail] == NSOrderedSame)
        selectedIndex = 0;
    else if ([displayType compare:kDisplayTypePhone] == NSOrderedSame)
        selectedIndex = 1;
    else
        selectedIndex = 2;
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

#pragma mark - 
#pragma mark - Table Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Choose the contact which display to public";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"TextInputCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    int row = [indexPath row];
    if(row == selectedIndex)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    //NSLog(@"row: %d", row);
    switch (row) {
        case 0:
        {
            cell.textLabel.text = @"Email";
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Phone";
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"Website";
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int selectedRow = [indexPath row];
    selectedIndex = selectedRow;
    
    NSLog(@"Clicked: %d", selectedIndex);
    
    NSArray* cells = [tableView visibleCells];
    for(UITableViewCell* cell in cells)
    {
        NSIndexPath *_indexPath = [tableView indexPathForCell:cell];
        if(_indexPath.row == selectedRow)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString* displayType;
    switch (selectedIndex) {
        case 0:
            displayType = kDisplayTypeEmail;
            break;
        case 1:
            displayType = kDisplayTypePhone;
            break;
        case 2:
            displayType = kDisplayTypeWebsite;
            break;
        default:
            break;
    }
    
    //also set the user default
    [[NSUserDefaults standardUserDefaults] setObject:displayType forKey:kDisplayTypeDefaultKey];
}

@end
