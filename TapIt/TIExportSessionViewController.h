//
//  TIExportSessionViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 6/11/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIExportSessionViewController : UITableViewController

@property IBOutlet UIButton* selectAllButton;
@property IBOutlet UIButton* deselectAllButton;

- (IBAction)sendPushed:(UIBarButtonItem*)sender;

- (IBAction)selectAllPushed:(UIButton*)sender;
- (IBAction)deselectAllPushed:(UIButton*)sender;

@end
