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

@property NSArray* wavList;

- (void) loadSelectedFromDefaults;
- (void) saveSelectedToDefaults;

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

    self.clearsSelectionOnViewWillAppear = NO;
    self.wavList = [TIFileManager documentsWavFiles];
 
    [self loadSelectedFromDefaults];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

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
    static NSString *CellIdentifier = @"TrackListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.textLabel.text = [self.wavList objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Audio Files";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - IBAction Selectors

- (IBAction) savePushed:(UIBarButtonItem*)sender
{
    // get selected row names
    [self saveSelectedToDefaults];
    
    // save selected
    
    // dismiss view
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)selectAllPushed:(UIBarButtonItem*)sender
{
    for (int i = 0; i < self.wavList.count; i++) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i
                                                                inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    }

}

- (IBAction)deselectAllPushed:(UIBarButtonItem*)sender
{
    for (int i = 0; i < self.wavList.count; i++) {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i
                                                                  inSection:0]
                                      animated:NO];
    }
    
}

#pragma mark - Private Selectors

- (void) loadSelectedFromDefaults
{
    NSArray* trackList = [[NSUserDefaults standardUserDefaults] arrayForKey:kTIDefaultsTrackList];
    for (NSString* filename in trackList) {
        
        NSUInteger idx = [self.wavList indexOfObject:filename];

        if (idx != NSNotFound) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx
                                                                    inSection:0]
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void) saveSelectedToDefaults
{
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray* trackList = [NSMutableArray arrayWithCapacity:selectedRows.count];
    
    for (NSIndexPath* path in selectedRows) {
        
        [trackList addObject:[self.wavList objectAtIndex:path.row]];
    }
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:trackList
                 forKey:kTIDefaultsTrackList];
    
    [defaults synchronize];
}

@end
