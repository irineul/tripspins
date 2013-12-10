//
//  PinDetailViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 23/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "PinDetailViewController.h"
#import "AttachmentCell.h"
#import "NoteService.h"
#import "Attachment.h"
#import "AttachmentService.h"
#import "ImageHelper.h"

@interface PinDetailViewController ()
{
    NSArray *attachments;
    NoteService *noteService;
    Attachment* attachment;
}

@end

@implementation PinDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // Get all notes
    NSArray *notes = [Note MR_findAll];
    notes = [[NoteService sharedInstance] getNotesFromPin: [_pin objectID]];
    //Get all attachs
    NSArray *attachs = [[AttachmentService sharedInstance] getAttachmentsFromPin:[_pin objectID]];
    
    for (int i = 0; i<[notes count]; i++) {
        NSLog([[notes objectAtIndex:i] st_note]);
    }
    for (int i = 0; i<[attachs count]; i++) {
        UIImage* image = [[ImageHelper sharedInstance] loadImageFromDocumentsDirectory:[[attachs objectAtIndex:i] st_file_path]];
    }

    
    [self.tableAttachs reloadData];
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attachments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    AttachmentCell *cell = (AttachmentCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachmentCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //I need a custom object
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //Call controller?
//    [self presentModalViewController:tripDetailView animated:YES];
}


#pragma mark -
#pragma Generic Methods
-(NSArray*) convertToAttachmentArray: (NSMutableArray*) notes{
    NSArray* attachments = [[NSArray alloc] init];
    Note* note;
    for (int i =0; i<[notes count]; i++) {
        note = [[Note alloc] init];
        note = [notes objectAtIndex:i];
        attachment = [[Attachment alloc] init];

    }

}

@end
