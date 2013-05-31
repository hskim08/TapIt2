//
//  TIPreInstructionViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/31/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIPreInstructionViewController : UIViewController

@property IBOutlet UITextView* textView;

- (IBAction) savePushed:(UIBarButtonItem*)sender;

@end
