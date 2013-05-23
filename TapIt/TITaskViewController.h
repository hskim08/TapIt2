//
//  TITaskViewController.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TITaskViewController : UIViewController

@property IBOutlet UILabel* tapLabel;

- (IBAction)tappedPrev:(UIBarButtonItem*)sender;
- (IBAction)tappedPlay:(UIBarButtonItem*)sender;
- (IBAction)tappedNext:(UIBarButtonItem*)sender;

@end
