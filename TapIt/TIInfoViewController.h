//
//  TIInfoViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 6/17/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIInfoViewController : UIViewController

@property IBOutlet UINavigationBar* navigationBar;
@property IBOutlet UITextView* textView;

- (IBAction)closePushed:(UIBarButtonItem*)sender;

@end
