//
//  TIInfoViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 6/17/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIInfoViewController.h"

@interface TIInfoViewController ()

@end

@implementation TIInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL* legalUrl = [[NSBundle mainBundle] URLForResource:@"legal"
                                              withExtension:@"txt"];
    
    NSError* error = nil;
    NSString* legalString = [NSString stringWithContentsOfURL:legalUrl
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    
    if (error)
        NSLog(@"Failed to read legal text: %@", error.description);
    
    self.textView.text = legalString;
}

#pragma mark - IBAction Selectors

- (IBAction)closePushed:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{ 
                             }];
}


@end
