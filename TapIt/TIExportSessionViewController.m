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

@interface TIExportSessionViewController ()<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property NSMutableArray* sessionList;

-(void) sendSelectedToMail;
-(void) displayMailComposerSheetWithAttachment:(NSString*)file withSession:(NSUInteger)count;

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
    
    self.sessionList = [NSMutableArray arrayWithArray:[TIFileManager sessionDirectories]];
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
    
    // get data for cell
    NSString* sessionDir = [self.sessionList objectAtIndex:indexPath.row];
    NSUInteger count = [TIFileManager wavFilesInDirectory:[[TIFileManager documentsDirectory] stringByAppendingPathComponent:sessionDir]].count;
    
    // Configure the cell
    cell.textLabel.text = sessionDir;
    cell.detailTextLabel.text = [NSString stringWithFormat:((count == 1) ? @"%d Task" : @"%d Tasks"), count];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Sessions";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        // TODO: show warning
        
        // Delete the row from the data source
        NSString* deletedSession = [self.sessionList objectAtIndex:indexPath.row];
        
        // delete the session directory
        [TIFileManager deleteItemInDocuments:deletedSession];
        
        // remove from array
        [self.sessionList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - IBAction Selectors

- (IBAction)sendPushed:(UIBarButtonItem*)sender
{
    [self sendSelectedToMail];
}

- (IBAction)selectAllPushed:(UIBarButtonItem*)sender
{
    for (int i = 0; i < self.sessionList.count; i++)
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i
                                                                inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)deselectAllPushed:(UIBarButtonItem*)sender
{
    for (int i = 0; i < self.sessionList.count; i++)
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i
                                                                  inSection:0]
                                      animated:NO];
}

#pragma mark - Private Implementation

- (void) sendSelectedToMail
{
    // check if the app can send mail
    if(![MFMailComposeViewController canSendMail]) {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Can not send email"
                                                            message:@"Please set up an email account for your device to enable session exporting."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
        if (selectedRows.count < 1)
            return;
    
        // get selected session list
        NSMutableArray* selectedList = [NSMutableArray arrayWithCapacity:selectedRows.count];
        for (NSIndexPath* path in selectedRows)
            [selectedList addObject:[self.sessionList objectAtIndex:path.row]];

        // compress folders
        NSString* exportFile = [TIFileManager createZipArchiveWithFiles:selectedList
                                                            inDirectory:[TIFileManager documentsDirectory]
                                                            toDirectory:[TIFileManager cacheDirectory]];
        
        // send to mail
        [self displayMailComposerSheetWithAttachment:exportFile
                                         withSession:selectedRows.count];
    }
}

-(void) displayMailComposerSheetWithAttachment:(NSString*)file withSession:(NSUInteger)count
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
	NSString *emailBody = [NSString stringWithFormat:((count == 1) ? @"The attached zip file contains %d session." : @"The attached zip file contains %d sessions."), count];
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
