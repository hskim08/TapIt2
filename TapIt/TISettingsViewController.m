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
    self.showPrevSwitch.on = [defaults boolForKey:kTIDefaultsShowPrev];
}

//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark - IBAction Selectors

- (IBAction)donePushed:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

- (IBAction)infoPushed:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"SettingsToInfo"
                              sender:self];
}

- (IBAction)useCueChanged:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn
               forKey:kTIDefaultsUseCue];
    
    [defaults synchronize];
}

- (IBAction)randomizeChanged:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn
               forKey:kTIDefaultsRandomize];

    [defaults synchronize];
}

- (IBAction)allowPauseChanged:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn
               forKey:kTIDefaultsAllowPause];

    [defaults synchronize];
}

- (IBAction)showPrevChanged:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn
               forKey:kTIDefaultsShowPrev];
    
    [defaults synchronize];
}

@end
