//
//  TITaskManager.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TITaskManager : NSObject

- (id) initWithTaskfile:(NSString*)taskFile;

- (NSString*) nextTrack;
- (NSString*) prevTrack;

@property NSInteger currentTask;
@property (readonly) NSInteger taskCount;

@end
