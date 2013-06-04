//
//  TITaskManager.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TITaskManager : NSObject

- (void) prepareSession;

// Returns the audio filename for the current task
- (NSString*) getCueFilename;
- (NSString*) getAudioFilename;
- (NSString*) getOutputFilename;

// Increases the current task pointer and returns the filename for the next task
- (NSString*) nextTask;
// Decreases the current task pointer and returns the filename for the previous task
- (NSString*) prevTask;

- (void) saveTapData:(NSString*)tapData;

@property NSString* sessionId;

@property NSInteger currentTask;
@property (readonly) NSInteger taskCount;

@end
