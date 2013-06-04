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
    
    // Configure the cell.
    cell.textLabel.text = [self.wavList objectAtIndex:indexPath.row];
//    if (indexPath.row == self.selectedIndex)
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
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
    else {
        self.selectedIndex = indexPath.row;
    }
    
//    for (UITableViewCell* cell in [self.tableView visibleCells]) {
//    
//        if (cell == selectedCell) {
//        
//            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) { // deselected
//                self.selectedIndex = -1;
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//            else { // selected
//                self.selectedIndex = indexPath.row;
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            }
//        }
//        else // uncheck others
//            cell.accessoryType = UITableViewCellAccessoryNone;
//    }
}

#pragma mark - IBAction Selectors

- (IBAction) savePushed:(UIBarButtonItem*)sender
{
    if (self.selectedIndex > -1)
        [[NSUserDefaults standardUserDefaults] setObject:[self.wavList objectAtIndex:self.selectedIndex]
                                                  forKey:kTIDefaultsCueAudio];
    else
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:kTIDefaultsCueAudio];
    
    // save selected
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // dismiss view
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
