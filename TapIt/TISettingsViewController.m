//
//  TISettingsViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TISettingsViewController.h"

#import "TIDefaults.h"

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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // load settings
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSUInteger trackListCount = [defaults arrayForKey:kTIDefaultsTrackList].count;
    self.audioFilesLabel.text = [NSString stringWithFormat:((trackListCount == 1) ? @"%d File Selected" : @"%d Files Selected"), trackListCount];

    NSString* cueAudio = [defaults stringForKey:kTIDefaultsCueAudio];
    BOOL cueExists = cueAudio != nil;
    self.cueDetailAudioLabel.text = cueExists ? cueAudio : @"None";
    self.useCueSwitch.enabled = cueExists;
    self.useCueLabel.enabled = cueExists;    
    self.useCueSwitch.on = [defaults boolForKey:kTIDefaultsUseCue];
    
    self.randomizeSwitch.on = [defaults boolForKey:kTIDefaultsRandomize];
    self.allowPauseSwitch.on = [defaults boolForKey:kTIDefaultsAllowPause];
}

//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

#pragma mark - IBAction Selectors

- (IBAction)tappedDone:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

- (IBAction)useCueChanged:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn
               forKey:@"UseCue"];
    
    [defaults synchronize];
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
