//
//  TITaskViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITaskViewController.h"

@interface TITaskViewController ()

@end

@implementation TITaskViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction Selectors

- (IBAction)tappedPrev:(UIBarButtonItem*)sender
{
    
}

- (IBAction)tappedPlay:(UIBarButtonItem*)sender
{
    
}

- (IBAction)tappedNext:(UIBarButtonItem*)sender
{
    // If finished with all tasks
    [self performSegueWithIdentifier:@"TaskToEnd"
                              sender:self];
}

@end
