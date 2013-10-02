//
//  TITrackListViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TITrackListViewController.h"

#import "TIDefaults.h"
#import "TIFileManager.h"

@interface TITrackListViewController ()

@property NSMutableArray* trackList;

- (void) removeRow:(NSUInteger)row;

- (void) saveTrackListToDefaults;

@end

@implementation TITrackListViewController

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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.trackList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kTIDefaultsTrackList]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trackList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrackListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.textLabel.text = [self.trackList objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Audio Files";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self removeRow:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"move from %d to %d", fromIndexPath.row, toIndexPath.row);
    
    // move object
    id item = [self.trackList objectAtIndex:fromIndexPath.row];
    [self.trackList removeObject:item];
    [self.trackList insertObject:item
                         atIndex:toIndexPath.row];
    
    // save to defaults
    [self saveTrackListToDefaults];
}

#pragma mark - Table view delegate


#pragma mark - IBAction Selectors

- (IBAction)editPushed:(UIBarButtonItem*)sender
{
    self.tableView.editing = !self.tableView.isEditing;
    
    if (self.tableView.isEditing) {
        
        [self.editButton setTitle:@"Done"
                         forState:UIControlStateNormal];
    }
    else {
        
        [self.editButton setTitle:@"Edit"
                         forState:UIControlStateNormal];
    }
}

//- (IBAction) savePushed:(UIBarButtonItem*)sender
//{
//    // save selected
//    [self saveSelectedToDefaults];
//    
//    // dismiss view
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

//- (IBAction)selectAllPushed:(UIBarButtonItem*)sender
//{
//    for (int i = 0; i < self.wavList.count; i++)
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i
//                                                                inSection:0]
//                                    animated:NO
//                              scrollPosition:UITableViewScrollPositionNone];
//
//}

//- (IBAction)deselectAllPushed:(UIBarButtonItem*)sender
//{
//    for (int i = 0; i < self.wavList.count; i++)
//        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i
//                                                                  inSection:0]
//                                      animated:NO];
//    
//}

#pragma mark - Private Selectors

- (void) removeRow:(NSUInteger)row
{
    [self.trackList removeObjectAtIndex:row];
    
    // save results
    [self saveTrackListToDefaults];
}

- (void) saveTrackListToDefaults
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.trackList
                 forKey:kTIDefaultsTrackList];
    
    [defaults synchronize];
}

//- (void) loadSelectedFromDefaults
//{
//    NSArray* trackList = [[NSUserDefaults standardUserDefaults] arrayForKey:kTIDefaultsTrackList];
//    
//    for (NSString* filename in trackList) {
//        
//        NSUInteger idx = [self.wavList indexOfObject:filename];
//
//        if (idx != NSNotFound) {
//            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx
//                                                                    inSection:0]
//                                        animated:NO
//                                  scrollPosition:UITableViewScrollPositionNone];
//        }
//    }
//}

//- (void) saveSelectedToDefaults
//{
//    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
//    NSMutableArray* trackList = [NSMutableArray arrayWithCapacity:selectedRows.count];
//    
//    for (NSIndexPath* path in selectedRows)
//        [trackList addObject:[self.wavList objectAtIndex:path.row]];
//    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:trackList
//                 forKey:kTIDefaultsTrackList];
//    
//    [defaults synchronize];
//}

@end
