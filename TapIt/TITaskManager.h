//
//  TITaskManager.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TITaskManager : NSObject

+ (NSString *) documentsDirectory;

- (void) loadTaskfile:(NSString*)taskFile;

// Returns the audio filename for the current task
- (NSString*) getAudioFilename;

// Increases the current task pointer and returns the filename for the next task
- (NSString*) nextTask;
// Decreases the current task pointer and returns the filename for the previous task
- (NSString*) prevTask;

@property NSInteger currentTask;
@property (readonly) NSInteger taskCount;

@end
