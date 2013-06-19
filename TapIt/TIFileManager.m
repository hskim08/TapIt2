//
//  TIFileManager.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/30/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIFileManager.h"

#import "ZipArchive.h"

@implementation TIFileManager

+ (NSString *) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *) cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSArray*) filesInDirectory:(NSString*)directory
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSArray* fileList = [fileManager contentsOfDirectoryAtPath:directory
                                                         error:&error];
    
    if (error)
        NSLog(@"Failed to get list of files: %@", error.description);
    
    return fileList;
}

+ (NSArray*) wavFilesInDirectory:(NSString*)directory
{
    return [[TIFileManager filesInDirectory:directory] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self endswith '.wav'"]];
}

+ (NSArray*) documentsDirectoryFiles
{
    return [TIFileManager filesInDirectory:[TIFileManager documentsDirectory]];
}

+ (NSArray*) documentsWavFiles
{
    return [[TIFileManager documentsDirectoryFiles] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self endswith '.wav'"]];
}

+ (NSArray*) sessionDirectories
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"self like %@", @"????????-??????"];
    NSArray* array = [[TIFileManager documentsDirectoryFiles] filteredArrayUsingPredicate:p];
    return array;
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

#pragma mark - Zip Selectors

+ (NSArray*) expandFilePath:(NSArray*)files inDirectory:(NSString*)directory
{
    NSMutableArray* expandedFiles = [NSMutableArray arrayWithCapacity:0];

    for (NSString* file in files) {
        
        [expandedFiles addObjectsFromArray:[TIFileManager expandFile:file
                                                         inDirectory:directory]];
    }

    return expandedFiles;
}

+ (NSArray*) expandFile:(NSString*)file inDirectory:(NSString*)directory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray* expandedFiles = [NSMutableArray arrayWithCapacity:0];
    
    NSString* filePath = [directory stringByAppendingPathComponent:file];//[NSString stringWithFormat:@"%@/%@", directory, file];
    BOOL isDir = NO;
    
    if ( [fileManager fileExistsAtPath:filePath
                           isDirectory:&isDir] ) {
        
        if (isDir) { // expand recursively
            
            // get sub file list
            NSArray* subFiles = [TIFileManager filesInDirectory:filePath];
            
            for (NSString* subFile in subFiles) {
                
                [expandedFiles addObjectsFromArray:[TIFileManager expandFile:[file stringByAppendingPathComponent:subFile]//[NSString stringWithFormat:@"%@/%@", file, subFile]
                                                                 inDirectory:directory]];
            }
        
        }
        else // add file
            [expandedFiles addObject:file];
    }
    
    return expandedFiles;
}

+ (NSString*) createZipArchiveWithFiles:(NSArray*)files inDirectory:(NSString*)directory
{
    return [TIFileManager createZipArchiveWithFiles:files
                                        inDirectory:directory
                                        toDirectory:directory];
}

+ (NSString*) createZipArchiveWithFiles:(NSArray*)files inDirectory:(NSString*)inDir toDirectory:(NSString*)outDir
{
    NSString *zipFilePath = [outDir stringByAppendingPathComponent:@"export.zip"];
    
    // expand all sub paths
    NSArray* expandedFiles = [TIFileManager expandFilePath:files
                                               inDirectory:inDir];
    
    // initialize zip archiver
    ZipArchive* zipArchive = [[ZipArchive alloc] init];
    
    // create zip file
    if (![zipArchive CreateZipFile2:zipFilePath])
        NSLog(@"Failed to create zip file: %@", zipFilePath);
    
    // add files to zip archive
    for(NSString* file in expandedFiles){
        
        // TODO: ZipArchive has problems compressing wav files. fix this
        if (![[[file lastPathComponent] pathExtension] isEqualToString:@"wav"]) {
            
            if (![zipArchive addFileToZip:[inDir stringByAppendingPathComponent:file]//[NSString stringWithFormat:@"%@/%@", inDir, file]
                                  newname:file])
                NSLog(@"Failed to add to zip: %@", file);
        }
    }
    
    // close file
    if (![zipArchive CloseZipFile2])
        NSLog(@"Failed to close zip file");
    
    return zipFilePath;
}

@end
