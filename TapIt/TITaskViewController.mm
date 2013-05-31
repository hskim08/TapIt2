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

@property NSTimeInterval startTime;
@property NSMutableString* tapData;

- (void) playAudio:(BOOL)play;

- (void) prepareTask;

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
    
    self.navigationItem.hidesBackButton = YES;
        
    [self.taskManager prepareSession];
    
    [self prepareTask];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}

#pragma mark - UIView override

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // light tap label
    self.tapLabel.textColor = [UIColor greenColor];

    // get tap on time
    NSTimeInterval tapOnTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    NSLog(@"Tap On: %.3f", tapOnTime);
    
    // append
    [self.tapData appendFormat:@"%f, ", tapOnTime];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    // unlight tap label
    self.tapLabel.textColor = [UIColor blackColor];

    // get tap off time
    NSTimeInterval tapOffTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    NSLog(@"Tap Off: %.3f", tapOffTime);
}

#pragma mark - IBAction Selectors

- (IBAction)tappedPrev:(UIBarButtonItem*)sender
{
    if (self.taskManager.currentTask > 0) { // load prev task
        
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
    // save data to file
    if (self.tapData.length > 2) // remove last comma
        [self.tapData deleteCharactersInRange:NSMakeRange(self.tapData.length-2, 2)];

    [self.taskManager saveTapData:self.tapData];
    
    if (self.taskManager.currentTask < (self.taskManager.taskCount-1)) { // load next task
        
        [self.taskManager nextTask];
        [self prepareTask];
    }
    else { // finished all tasks

        [self playAudio:NO];
        
        // close audio files
        TIAudio::getInstance().closeFiles();
        
        // segue
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

- (void) playAudio:(BOOL)play
{
    if (play) {
        self.startTime = [[NSDate date] timeIntervalSince1970];
        TIAudio::getInstance().play();
        self.playButton.title = @"Pause";
    }
    else {
        TIAudio::getInstance().pause();
        self.playButton.title = @"Play";
    }
}

- (void) prepareTask
{
    // stop audio
    [self playAudio:NO];
    
    // load new audio
    NSString* filename = [self.taskManager getAudioFilename];
    std::string audioFile([filename UTF8String]);
    TIAudio::getInstance().loadAudioFile(audioFile);
    
    // open file to write
    NSString* outputFilename = [self.taskManager getOutputFilename];
    std::string outputFile([outputFilename UTF8String]);
    TIAudio::getInstance().openRecordFile(outputFile);
    
    // reset data string
    self.tapData = [NSMutableString stringWithCapacity:1];
    
    // update title
    self.title = [NSString stringWithFormat:@"Task #%d", self.taskManager.currentTask+1];
}

@end
