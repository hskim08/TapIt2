//
//  TICueAudioViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/31/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TICueAudioViewController.h"

#import "TIDefaults.h"
#import "TIFileManager.h"

@interface TICueAudioViewController ()

@property NSArray* wavList;
@property NSInteger selectedIndex;

- (void) loadSelectedFromDefaults;

@end

@implementation TICueAudioViewController

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

    self.clearsSelectionOnViewWillAppear = NO;
    self.wavList = [TIFileManager documentsWavFiles];
    
    [self loadSelectedFromDefaults];
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
    static NSString *CellIdentifier = @"CueTrackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.textLabel.text = [self.wavList objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectedIndex == indexPath.row) {
        
        selectedCell.selected = NO;
        self.selectedIndex = -1;
    }
    else
        self.selectedIndex = indexPath.row;
}

#pragma mark - IBAction Selectors

- (IBAction) savePushed:(UIBarButtonItem*)sender
{
    // save selected
    [[NSUserDefaults standardUserDefaults] setObject:(self.selectedIndex > -1) ? [self.wavList objectAtIndex:self.selectedIndex] : nil
                                              forKey:kTIDefaultsCueAudio];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // dismiss view
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Private Selectors

- (void) loadSelectedFromDefaults
{
    NSString* selectedFile = [[NSUserDefaults standardUserDefaults] stringForKey:kTIDefaultsCueAudio];
    
    if (selectedFile) {
        
        self.selectedIndex = [self.wavList indexOfObject:selectedFile];
        
        // select cell
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex
                                                                inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    }
    else
        self.selectedIndex = -1;
}

@end
