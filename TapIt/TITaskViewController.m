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

#pragma mark - UIView override

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // light tap label
    self.tapLabel.textColor = [UIColor greenColor];

    // get tap on time
    NSTimeInterval tapOnTime = [[NSDate date] timeIntervalSince1970];// - self.startTime;
    NSLog(@"Tap On: %.3f", tapOnTime);

//    for (UITouch* touch in touches) { // for each touch
//        
//        // save tap on time
//        [self.tapOnData appendFormat:@"%f, ", tapOnTime];
//        
//        // save position
//        CGPoint point = [touch locationInView:self.view];
//        [self.tapXPosData appendFormat:@"%f, ", point.x];
//        [self.tapYPosData appendFormat:@"%f, ", self.view.frame.size.height - point.y];
//        
//        NSLog(@"On: %f (%.1f/%.1f)", tapOnTime, point.x, self.view.frame.size.height - point.y);
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    // unlight tap label
    self.tapLabel.textColor = [UIColor blackColor];

    // get tap off time
    NSTimeInterval tapOffTime = [[NSDate date] timeIntervalSince1970];// - self.startTime;;
    NSLog(@"Tap Off: %.3f", tapOffTime);

//    for (UITouch* touch in touches) {
//        
//        // save tap off time
//        [self.tapOffData appendFormat:@"%f, ", tapOffTime];
//        
//        // save position
//        CGPoint point = [touch locationInView:self.view];
//        [self.tapOffXPosData appendFormat:@"%f, ", point.x];
//        [self.tapOffYPosData appendFormat:@"%f, ", self.view.frame.size.height - point.y];
//        
//        NSLog(@"Off: %f (%.1f/%.1f)", tapOffTime, point.x, self.view.frame.size.height - point.y);
//    }
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
