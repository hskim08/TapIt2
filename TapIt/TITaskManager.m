//
//  TITaskManager.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITaskManager.h"

#import "CSVParser.h"

@interface TITaskManager()

@property CSVParser* csvParser;

- (CSVParser*) parserWithUrl:(NSURL*)url;
- (CSVParser*) parserWithPath:(NSString*)path;
- (CSVParser*) parseCsvString:(NSString*)csvString;

- (NSString*) filenameAt:(NSInteger)taskNo;

@end

@implementation TITaskManager

- (void) loadTaskfile:(NSString*)taskFile
{
    NSLog(@"Task file: %@", taskFile);
    
    self.csvParser = [self parserWithPath:taskFile];
    self.currentTask = 0;
    
    NSArray* ar = [self.csvParser arrayOfParsedRows];
    NSLog(@"Task Count: %d", ar.count);
}

- (NSString*) getAudioFilename
{
    // create full path name
    NSString* str = [self filenameAt:self.currentTask];
    
    return [NSString stringWithFormat:@"%@/%@", [TITaskManager documentsDirectory], str];
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

- (NSString*) filenameAt:(NSInteger)taskNo
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:taskNo];
    return [taskData objectForKey:@"Filename"];
}

+ (NSString *) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
@end
