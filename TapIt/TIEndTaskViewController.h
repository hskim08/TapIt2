//
//  TIEndTaskViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIEndTaskViewController : UIViewController

@property IBOutlet UITextView* textView;

- (IBAction)tappedClose:(UIBarButtonItem*)sender;

@end
