//
//  TIFileManager.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/30/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TIFileManager : NSObject

// returns the documents directory for the app
+ (NSString *) documentsDirectory;
+ (NSString *) cacheDirectory;

// get list of files in directory
+ (NSArray*) filesInDirectory:(NSString*)directory;
+ (NSArray*) wavFilesInDirectory:(NSString*)directory;

// expand an array of files into full file structure
+ (NSArray*) expandFilePath:(NSArray*)files inDirectory:(NSString*)directory;
+ (NSArray*) expandFile:(NSString*)file inDirectory:(NSString*)directory;

// easy access selectors
+ (NSArray*) documentsDirectoryFiles;
+ (NSArray*) documentsWavFiles;

+ (NSArray*) sessionDirectories;

// copies a resource from the app bundle into the documents directory. this selector will overwrite files
// already existing in the documents directory with the given filename
+ (void) copyResourceToDocument:(NSString*)resource ofType:(NSString*)ext as:(NSString*)docFile overwrite:(BOOL)overwrite;
+ (void) copyResourceToDocument:(NSString*)resource ofType:(NSString*)ext;

// checks if the path exists and creates a directory if the directory does not exist
+ (void) checkDirectoryPath:(NSString*)pathString;

// create zip files
+ (NSString*) createZipArchiveWithFiles:(NSArray*)files inDirectory:(NSString*)directory;
+ (NSString*) createZipArchiveWithFiles:(NSArray*)files inDirectory:(NSString*)inDir toDirectory:(NSString*)outDir;

// deletes directory
+ (void) deleteItemInDocuments:(NSString*)directory;

@end
