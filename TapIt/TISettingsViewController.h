//
//  TISettingsViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TISettingsViewController : UITableViewController

@property IBOutlet UILabel* audioFilesLabel;
@property IBOutlet UISwitch* useCueSwitch;
@property IBOutlet UILabel* useCueLabel;
@property IBOutlet UILabel* cueDetailAudioLabel;

@property IBOutlet UISwitch* randomizeSwitch;
@property IBOutlet UISwitch* allowPauseSwitch;
@property IBOutlet UISwitch* showPrevSwitch;

- (IBAction)tappedDone:(UIBarButtonItem*)sender;

- (IBAction)useCueChanged:(UISwitch*)sender;
- (IBAction)randomizeChanged:(UISwitch*)sender;
- (IBAction)allowPauseChanged:(UISwitch*)sender;
- (IBAction)showPrevChanged:(UISwitch*)sender;

@end
