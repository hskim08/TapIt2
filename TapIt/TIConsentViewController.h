//
//  TIConsentViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIConsentViewController : UIViewController

@property IBOutlet UITextView* textView;

- (IBAction)tappedSettings:(UIBarButtonItem*)sender;
- (IBAction)tappedNext:(UIBarButtonItem*)sender;

@end
