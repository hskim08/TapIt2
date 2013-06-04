//
//  TIConsentViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIConsentViewController.h"

#import "TIDefaults.h"

@interface TIConsentViewController ()

@end

@implementation TIConsentViewController

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
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    // load text from defaults
    NSString* text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PreSession"];
    self.textView.text = text;
}

# pragma mark - IBAction Selectors

- (IBAction)tappedSettings:(UIBarButtonItem*)sender
{
    [self performSegueWithIdentifier:@"ConsentToSettings"
                              sender:self];
}

- (IBAction)tappedNext:(UIBarButtonItem*)sender
{
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:kTIDefaultsTrackList].count > 0) {
        
        [self performSegueWithIdentifier:@"ConsentToTask"
                                  sender:self];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Empty Track List"
                                    message:@"There are no tracks in the track list. Add audio files in the Settings Menu."
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:nil, nil]
         show];
    }
    

}

@end
