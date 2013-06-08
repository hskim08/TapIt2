//
//  TIPostInstructionViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/31/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIPostInstructionViewController : UIViewController

@property IBOutlet UITextView* textView;
@property IBOutlet UIToolbar* toolBar;

- (IBAction) savePushed:(UIBarButtonItem*)sender;
- (IBAction) donePushed:(UIBarButtonItem*)sender;

@end
