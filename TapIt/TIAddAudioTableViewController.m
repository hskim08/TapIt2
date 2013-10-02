//
//  TIAddAudioTableViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 10/2/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIAddAudioTableViewController.h"

#import "TIDefaults.h"
#import "TIFileManager.h"

@interface TIAddAudioTableViewController ()

@property NSMutableArray* wavList;
@property NSMutableArray* trackList;

- (void) getInitialList;

- (void) saveTrackListToDefaults;

@end

@implementation TIAddAudioTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getInitialList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wavList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddAudioCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.wavList objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate Selectors

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.trackList addObject:[self.wavList objectAtIndex:indexPath.row]];
    
    [self saveTrackListToDefaults];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.trackList removeObject:[self.wavList objectAtIndex:indexPath.row]];

    [self saveTrackListToDefaults];
}


#pragma mark - Private Implementation

- (void) getInitialList
{
    // get audio file list
    self.wavList = [NSMutableArray arrayWithArray:[TIFileManager documentsWavFiles]];
    
    // get track list
    self.trackList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kTIDefaultsTrackList]];
    
    // remove selected files from list
    for (NSString* filename in self.trackList) {
        
        NSUInteger idx = [self.wavList indexOfObject:filename];
        
        if (idx != NSNotFound) {
            
            [self.wavList removeObjectAtIndex:idx];
        }
    }
}

- (void) saveTrackListToDefaults
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.trackList
                 forKey:kTIDefaultsTrackList];
    
    [defaults synchronize];
}

@end
