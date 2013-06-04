//
//  TITaskManager.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITaskManager.h"

#import "TIDefaults.h"
#import "TIFileManager.h"

@interface TITaskManager()

+ (NSString*) createSessionId;
+ (NSArray*) trackOrderWithLength:(NSUInteger)length randomize:(BOOL)randomize;
+ (void) saveList:(NSArray*)list asCsvWithTitle:(NSString*)title toPath:(NSString*)path;

@property NSString* sessionPath;
@property NSArray* trackList;
@property NSArray* trackOrder;

- (NSArray*) loadTaskFromDefaults;

- (void) saveTrackList;
- (void) saveTrackOrder;

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

+ (NSArray*) trackOrderWithLength:(NSUInteger)length randomize:(BOOL)randomize
{
    NSMutableArray* temp = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < length; i++)
        [temp addObject:[NSNumber numberWithInt:i]];
    
    if (!randomize) // return linear list
        return temp;
    
    // randomize using Knuth shuffle
    NSMutableArray* perm = [NSMutableArray arrayWithCapacity:0];
    while (temp.count > 0) {
        int idx = arc4random() % temp.count;
        
        [perm addObject:[temp objectAtIndex:idx]];
        [temp removeObjectAtIndex:idx];
    }
    return perm;
}

+ (void) saveList:(NSArray*)list asCsvWithTitle:(NSString*)title toPath:(NSString*)path
{
    NSString* string = [list componentsJoinedByString:@", "];
    
    NSError* error;
    [string writeToFile:[NSString stringWithFormat:@"%@/%@.csv", path, title]
             atomically:YES
               encoding:NSUTF8StringEncoding
                  error:&error];
    
    if (error)
        NSLog(@"Failed to write tracklist: %@", error.description);
    
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
    self.currentTask = 0;
    self.trackList = [self loadTaskFromDefaults];
    
    // create trackList.csv and save to session folder
    [self saveTrackList];
    
    // create track order
    BOOL randomize = [[NSUserDefaults standardUserDefaults] boolForKey:kTIDefaultsRandomize];
    self.trackOrder = [TITaskManager trackOrderWithLength:self.trackList.count
                                        randomize:randomize];
    
    // save track list order
    [self saveTrackOrder];
}

- (NSString*) getCueFilename
{
    NSString* filename = [[NSUserDefaults standardUserDefaults] stringForKey:kTIDefaultsCueAudio];
    return [NSString stringWithFormat:@"%@/%@", [TIFileManager documentsDirectory], filename];
}

- (NSString*) getAudioFilename
{
    // get audio file name
    NSNumber* n = [self.trackOrder objectAtIndex:self.currentTask]; // get actual track number
    NSUInteger idx = n.integerValue;
    NSString* filename = [self.trackList objectAtIndex:idx];
    
    // create full path name
    return [NSString stringWithFormat:@"%@/%@", [TIFileManager documentsDirectory], filename];
}

- (NSString *)getOutputFilename
{
    return [NSString stringWithFormat:@"%@/%03d.wav", self.sessionPath, (self.currentTask+1)];
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

- (NSArray*) loadTaskFromDefaults
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"TrackList"];
}

- (void) saveTrackList
{
    [TITaskManager saveList:self.trackList
         asCsvWithTitle:@"TrackList"
            toPath:self.sessionPath];
}

- (void) saveTrackOrder
{
    [TITaskManager saveList:self.trackOrder
         asCsvWithTitle:@"TrackOrder"
            toPath:self.sessionPath];
}

@end
