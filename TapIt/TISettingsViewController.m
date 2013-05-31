//
//  TISettingsViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TISettingsViewController.h"

@interface TISettingsViewController ()

@end

@implementation TISettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.randomizeSwitch.on = [defaults boolForKey:@"Randomize"];
    self.allowPauseSwitch.on = [defaults boolForKey:@"AllowPause"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - IBAction Selectors

- (IBAction)tappedDone:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

- (IBAction)randomizeChanged:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn
               forKey:@"Randomize"];

    [defaults synchronize];
}

- (IBAction)allowPauseChanged:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn
               forKey:@"AllowPause"];

    [defaults synchronize];
}


@end
