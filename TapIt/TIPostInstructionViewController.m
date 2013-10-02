//
//  TIPostInstructionViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/31/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIPostInstructionViewController.h"

#import "TIDefaults.h"

@interface TIPostInstructionViewController ()

- (void) registerKeyboardListeners;
- (void) unregisterKeyboardListeners;

- (void) keyboardWillShow:(NSNotification *)notification;
- (void) keyboardWillHide:(NSNotification *)notification;

@end

@implementation TIPostInstructionViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
        
    // load saved data
    NSString* text = [[NSUserDefaults standardUserDefaults] stringForKey:kTIDefaultsPostSession];
    self.textView.text = text;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // initialize keyboard toolbar
    self.toolBar.hidden = YES;
    CGRect frame = self.toolBar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.toolBar.frame = frame;
    
    [self registerKeyboardListeners];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self unregisterKeyboardListeners];
}

#pragma mark - IBActions Selectors

- (IBAction) savePushed:(UIBarButtonItem*)sender
{
    // save text to defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.textView.text
                 forKey:kTIDefaultsPostSession];
    
    // save defaults
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) donePushed:(UIBarButtonItem*)sender
{
    // hide keyboard
    [self.textView resignFirstResponder];
}

#pragma mark - Private Implementation

- (void) registerKeyboardListeners
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void) unregisterKeyboardListeners
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    // get keyboard information
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber* keyboardDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // increase textfield context size to scroll
    UIEdgeInsets contentInset = self.textView.contentInset;
    contentInset.bottom += keyboardSize.height+self.toolBar.frame.size.height;
    self.textView.contentInset = contentInset;
    
    // show toolbar
    self.toolBar.hidden = NO;
    [UIView animateWithDuration:keyboardDuration.floatValue
                     animations:^{
                         CGRect frame = self.toolBar.frame;
                         frame.origin.y -= keyboardSize.height+self.toolBar.frame.size.height;
                         self.toolBar.frame = frame;
                     }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    // get keyboard information
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber* keyboardDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    
    [UIView animateWithDuration:keyboardDuration.floatValue
                     animations:^{
                         
                         // hide toolbar
                         CGRect frame = self.toolBar.frame;
                         frame.origin.y += keyboardSize.height+self.toolBar.frame.size.height;
                         self.toolBar.frame = frame;
                         
                         // restore textfield context size
                         UIEdgeInsets contentInset = self.textView.contentInset;
                         contentInset.bottom -= keyboardSize.height+self.toolBar.frame.size.height;
                         self.textView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         self.toolBar.hidden = YES;
                     }];
}

@end
