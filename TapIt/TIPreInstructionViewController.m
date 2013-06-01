//
//  TIPreInstructionViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/31/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIPreInstructionViewController.h"

@interface TIPreInstructionViewController ()

@end

@implementation TIPreInstructionViewController

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
    
    // load text from defaults
    NSString* text = [[NSUserDefaults standardUserDefaults] stringForKey:@"PreSession"];
    self.textView.text = text;
}

#pragma mark - IBActions Selectors

- (IBAction) savePushed:(UIBarButtonItem*)sender
{
    // save text to defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.textView.text
                 forKey:@"PreSession"];
    
    // save defaults
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
