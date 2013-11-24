//
//  NoteViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 28/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "NoteViewController.h"
#import "Note.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(id)sender {
    
    // Get id of current trip
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger idTrip = [fetchDefaults integerForKey:@"idTrip"];
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    Note *newNote = [Note MR_createInContext:localContext];
    
    NSString *text = self.txtNote.text;
    [newNote setSt_note:text];
    
    noteService = [[NoteService alloc] init];
    
    /* Insert and commit */
    //Dont neet to commit, just at finish of pin
//    [noteService insert:newNote :cur

    /*
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }]; */
    
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"DismissModalviewController");
    
    //raise notification about dismiss
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteViewDismiss" object:newNote];

    
}

@end
