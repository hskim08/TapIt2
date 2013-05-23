//
//  TITaskManager.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/23/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITaskManager.h"

@implementation TITaskManager

- (id) initWithTaskfile:(NSString*)taskFile
{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (NSString*) nextTrack
{
    // TODO: implement
    return nil;
}

- (NSString*) prevTrack
{
    // TODO: implement
    return nil;
}

@synthesize taskCount;
- (NSInteger) taskCount
{
    // TODO: read from 
    return 0;
}

@end
