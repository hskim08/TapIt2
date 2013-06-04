//
//  TITrackListViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TITrackListViewController : UITableViewController

- (IBAction)savePushed:(UIBarButtonItem*)sender;

- (IBAction)selectAllPushed:(UIBarButtonItem*)sender;
- (IBAction)deselectAllPushed:(UIBarButtonItem*)sender;

@end
