//
//  TITaskManager.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITaskManager.h"

#import "TIFileManager.h"

#import "CSVParser.h"

@interface TITaskManager()

+ (NSString*) createSessionId;

@property CSVParser* csvParser;

- (CSVParser*) parserWithUrl:(NSURL*)url;
- (CSVParser*) parserWithPath:(NSString*)path;
- (CSVParser*) parseCsvString:(NSString*)csvString;

@property NSString* sessionPath;

// loads the task data from task file
- (void) loadTaskfile:(NSString*)taskFile;

// returns the filename for task
- (NSString*) filenameOf:(NSInteger)taskNo;

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

- (void) loadTaskfile:(NSString*)taskFile
{
    NSLog(@"Task file: %@", taskFile);
    
    self.csvParser = [self parserWithPath:taskFile];
    self.currentTask = 0;
    
    NSArray* ar = [self.csvParser arrayOfParsedRows];
    NSLog(@"Task Count: %d", ar.count);
}

- (void) prepareSession
{
    // create session id
    self.sessionId = [TITaskManager createSessionId];
    
    // TODO: load task data from current task.csv file
    [self loadTaskfile:[NSString stringWithFormat:@"%@/%@", [TIFileManager documentsDirectory], @"example.csv"]];
    
    // create session folder
    self.sessionPath = [NSString stringWithFormat:@"%@/%@", [TIFileManager documentsDirectory], self.sessionId];
    [TIFileManager checkDirectoryPath:self.sessionPath];
    
    // TODO: if randomized save track list order
}

- (NSString*) getAudioFilename
{
    // create full path name
    NSString* str = [self filenameOf:self.currentTask];
    
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
    return [self.csvParser arrayOfParsedRows].count;
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

- (CSVParser*) parserWithUrl:(NSURL*)url
{
    NSError* error;
    NSString* csvString = [NSString stringWithContentsOfURL:url
                                                   encoding:NSASCIIStringEncoding
                                                      error:&error];
    
    if (error) {
        
        NSLog(@"%@", [error description]);
        return nil;
    }
    
    return [self parseCsvString:csvString];
}

- (CSVParser*) parserWithPath:(NSString*)path
{
    NSError* error;
    NSString* csvString = [NSString stringWithContentsOfFile:path
                                                   encoding:NSASCIIStringEncoding
                                                      error:&error];
    
    if (error) {
        
        NSLog(@"%@", [error description]);
        return nil;
    }
    
    return [self parseCsvString:csvString];

}

- (CSVParser*) parseCsvString:(NSString*)csvString
{
    NSArray* keyArray = @[@"Filename"];
    
    return [[CSVParser alloc] initWithString:csvString
                                   separator:@","
                                   hasHeader:NO
                                  fieldNames:keyArray
            ];
}

- (NSString*) filenameOf:(NSInteger)taskNo
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:taskNo];
    return [taskData objectForKey:@"Filename"];
}

@end
