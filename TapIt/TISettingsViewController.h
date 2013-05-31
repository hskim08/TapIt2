//
//  TISettingsViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TISettingsViewController : UITableViewController

@property IBOutlet UISwitch* randomizeSwitch;
@property IBOutlet UISwitch* allowPauseSwitch;

- (IBAction)tappedDone:(UIBarButtonItem*)sender;

- (IBAction)randomizeChanged:(UISwitch*)sender;
- (IBAction)allowPauseChanged:(UISwitch*)sender;

@end
