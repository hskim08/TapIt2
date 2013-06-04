//
//  TIEndTaskViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIEndTaskViewController.h"

@interface TIEndTaskViewController ()

@end

@implementation TIEndTaskViewController

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
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    // load text from defaults
    NSString* text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PostSession"];
    self.textView.text = text;
}

#pragma mark - IBAction Selectors

- (IBAction)tappedClose:(UIBarButtonItem*)sender
{
    [self performSegueWithIdentifier:@"EndToConsent"
                              sender:self];
}

@end
