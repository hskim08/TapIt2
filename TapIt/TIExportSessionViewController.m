//
//  TIExportSessionViewController.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 6/11/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIExportSessionViewController.h"

#import <MessageUI/MessageUI.h>

#import "TIFileManager.h"

@interface TIExportSessionViewController ()<MFMailComposeViewControllerDelegate>

@property NSArray* sessionList;

- (void) sendSelectedToMail;
-(void) displayMailComposerSheetWithAttachement:(NSString*)file;

@end

@implementation TIExportSessionViewController

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
    
    self.sessionList = [TIFileManager sessionDirectories];
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
    return self.sessionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.textLabel.text = [self.sessionList objectAtIndex:indexPath.row];
    
    return cell;
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
}

#pragma mark - IBAction Selectors

- (IBAction)sendPushed:(UIBarButtonItem*)sender
{
    [self sendSelectedToMail];
}

#pragma mark - Private Implementation

- (void) sendSelectedToMail
{
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    if (selectedRows.count < 1)
        return;

    NSMutableArray* selectedList = [NSMutableArray arrayWithCapacity:selectedRows.count];
    for (NSIndexPath* path in selectedRows)
        [selectedList addObject:[self.sessionList objectAtIndex:path.row]];

    // compress folders
    NSString* exportFile = [TIFileManager createZipArchiveWithFiles:selectedList
                                                        inDirectory:[TIFileManager documentsDirectory]
                                                        toDirectory:[TIFileManager cacheDirectory]];
    
    // send to mail
    [self displayMailComposerSheetWithAttachement:exportFile];
}

-(void) displayMailComposerSheetWithAttachement:(NSString*)file
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Exporting Tap-It Data"];
	
	// Attach an image to the email
	NSData *myData = [NSData dataWithContentsOfFile:file];
	[picker addAttachmentData:myData
                     mimeType:@"application/zip"
                     fileName:@"TapItData.zip"]; // TODO: use more informative file name. Use date-time.
	
	// Fill out the email body text
	NSString *emailBody = @"Exporting Tap-It data for download.";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker
                       animated:YES
                     completion:^{
                     }];
}

#pragma mark - MFMailComposeViewControllerDelegate Selector

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}



@end
