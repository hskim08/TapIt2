//
//  TIFileManager.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/30/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIFileManager.h"

@implementation TIFileManager

+ (NSString *) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (void) copyResourceToDocument:(NSString*)resource ofType:(NSString*)ext as:(NSString*)docFile overwrite:(BOOL)overwrite;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *docPath = [[TIFileManager documentsDirectory] stringByAppendingPathComponent:docFile];
    
    if (overwrite) {
        
        if ([fileManager fileExistsAtPath:docPath] == YES) {
            
            [fileManager removeItemAtPath:docPath
                                    error:&error];
            
            if (error)
                NSLog(@"Failed to remove existing file: %@", error.description);
        }
        
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resource
                                                                 ofType:ext];
        [fileManager copyItemAtPath:resourcePath
                             toPath:docPath
                              error:&error];
        if (error)
            NSLog(@"Failed to copy resource: %@", error.description);

    }
    else {
        
        if ([fileManager fileExistsAtPath:docPath] == NO) {
            
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resource
                                                                     ofType:ext];
            [fileManager copyItemAtPath:resourcePath
                                 toPath:docPath
                                  error:&error];
            if (error)
                NSLog(@"Failed to copy resource: %@", error.description);
        }
    }
    
}

+ (void) copyResourceToDocument:(NSString*)resource ofType:(NSString*)ext
{
    NSString* docFile = [NSString stringWithFormat:@"%@.%@", resource, ext];
    
    [TIFileManager copyResourceToDocument:resource
                                   ofType:ext
                                       as:docFile
                                overwrite:NO];
}

+ (void) checkDirectoryPath:(NSString*)pathString
{
    // check if saved dir exists
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:pathString] ) {
        NSError* error;
        [fileManager createDirectoryAtPath:pathString
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (error)
            NSLog(@"Failed to create saved directory:: %@", error.description);
    }
}



@end
