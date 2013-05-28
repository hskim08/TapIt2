//
//  TITaskViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITaskViewController.h"

#import "TITaskManager.h"

#import "TIAudio.h"

@interface TITaskViewController ()

@property (nonatomic) TITaskManager* taskManager;

- (void) prepareTask;
- (void) playAudio:(BOOL)play;

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
    
    // TODO: load task data from current task.csv file
    [self.taskManager loadTaskfile:[NSString stringWithFormat:@"%@/%@", [TITaskManager documentsDirectory], @"trial.csv"]];
    
    [self prepareTask];
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
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    // unlight tap label
    self.tapLabel.textColor = [UIColor blackColor];

    // get tap off time
    NSTimeInterval tapOffTime = [[NSDate date] timeIntervalSince1970];// - self.startTime;;
    NSLog(@"Tap Off: %.3f", tapOffTime);
}

#pragma mark - IBAction Selectors

- (IBAction)tappedPrev:(UIBarButtonItem*)sender
{
    if (self.taskManager.currentTask > 0) {
        
        [self.taskManager prevTask];
        [self prepareTask];
    }
}

- (IBAction)tappedPlay:(UIBarButtonItem*)sender
{
    [self playAudio:!TIAudio::getInstance().isPlaying()];
}

- (IBAction)tappedNext:(UIBarButtonItem*)sender
{
    if (self.taskManager.currentTask < (self.taskManager.taskCount-1)) {
        
        [self.taskManager nextTask];
        [self prepareTask];
    }
    else { // finished all tasks

        [self performSegueWithIdentifier:@"TaskToEnd"
                                  sender:self];
    }
}

#pragma mark - Private Implementation

@synthesize taskManager = _taskManager;
- (TITaskManager*)taskManager
{
    if (!_taskManager) {
        _taskManager = [[TITaskManager alloc] init];
    }
    return _taskManager;
}

- (void) prepareTask
{
    // stop audio
    [self playAudio:NO];
    
    // load new audio
    NSString* filename = [self.taskManager getAudioFilename];
    std::string audioFile([filename UTF8String]);
    NSLog(@"%s", audioFile.c_str());
    TIAudio::getInstance().loadAudioFile(audioFile);
    
    // update title
    self.title = [NSString stringWithFormat:@"Task #%d", self.taskManager.currentTask+1];
}

- (void) playAudio:(BOOL)play
{
    if (play) {
        TIAudio::getInstance().play();
        self.playButton.title = @"Pause";
    }
    else {
        TIAudio::getInstance().pause();
        self.playButton.title = @"Play";
    }
}

@end
