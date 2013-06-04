//
//  TITaskManager.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITaskManager.h"

#import "TIFileManager.h"

@interface TITaskManager()

+ (NSString*) createSessionId;

@property NSString* sessionPath;
@property NSArray* trackList;

- (void) loadTaskFromDefaults;
- (void) saveTrackList;

@end

@implementation TITaskManager

#pragma mark - Class Selectors

+ (NSString*) createSessionId
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMdd-HHmmss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

#pragma mark - Public Selectors

- (void) prepareSession
{
    // create session id
    self.sessionId = [TITaskManager createSessionId];

    // create session folder
    self.sessionPath = [NSString stringWithFormat:@"%@/%@", [TIFileManager documentsDirectory], self.sessionId];
    [TIFileManager checkDirectoryPath:self.sessionPath];
    
    // load from saved defaults
    [self loadTaskFromDefaults];
    
    // TODO: create trackList.csv and save to session folder
    [self saveTrackList];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Randomize"]) {
        // TODO: create random order and save track list order
    }
}

- (NSString*) getAudioFilename
{
    // create full path name
    NSString* str = [self.trackList objectAtIndex:self.currentTask];
    return [NSString stringWithFormat:@"%@/%@", [TIFileManager documentsDirectory], str];
}

- (NSString *)getOutputFilename
{
    return [NSString stringWithFormat:@"%@/%03d.wav", self.sessionPath, self.currentTask];
}

- (NSString*) nextTask
{
    if (self.currentTask < (self.taskCount-1))
        self.currentTask++;
    
    return [self getAudioFilename];
}

- (NSString*) prevTask
{
    if (self.currentTask > 0)
        self.currentTask--;
    
    return [self getAudioFilename];
}

@synthesize taskCount;
- (NSInteger) taskCount
{
    return self.trackList.count;
}

- (void) saveTapData:(NSString*)tapData
{
    NSString* filename = [NSString stringWithFormat:@"%@/%03d.csv", self.sessionPath, self.currentTask];
    
    NSError* error;
    [tapData writeToFile:filename
              atomically:YES
                encoding:NSUTF8StringEncoding
                   error:&error];
    
    if (error)
        NSLog(@"%@", [error description]);
}

#pragma mark - Private Implementation

- (void) loadTaskFromDefaults
{
    self.currentTask = 0;
    self.trackList = [[NSUserDefaults standardUserDefaults] arrayForKey:@"TrackList"];
    NSLog(@"Task Count: %d", self.trackList.count);
}

- (void) saveTrackList
{
    NSString* string = [self.trackList componentsJoinedByString:@", "];

    NSError* error;
    [string writeToFile:[NSString stringWithFormat:@"%@/trackList.csv", self.sessionPath]
             atomically:YES
               encoding:NSUTF8StringEncoding
                  error:&error];
    
    if (error)
        NSLog(@"Failed to write tracklist: %@", error.description);
}

@end
