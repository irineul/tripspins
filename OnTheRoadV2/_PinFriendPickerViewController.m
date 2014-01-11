//
//  _PinFriendPickerViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 21/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "_PinFriendPickerViewController.h"

@interface _PinFriendPickerViewController ()

@end

@implementation _PinFriendPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize the friend picker
    FBFriendPickerViewController *friendPickerController =
    [[FBFriendPickerViewController alloc] init];
    // Set the friend picker title
    friendPickerController.title = @"Pick Friends";
    
    friendPickerController.delegate = self;
    
    // Load the friend data
    [friendPickerController loadData];
    // Show the picker modally
    [friendPickerController presentModallyFromViewController:self
                                                    animated:YES
                                                     handler:
     ^(FBViewController *sender, BOOL donePressed) {
         if(donePressed) {
             NSLog(@"Selected friends: %@", friendPickerController.selection);
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Event: Error during data fetch
 */
- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error
{
    NSLog(@"Error during data fetch.");
}

/*
 * Event: Data loaded
 */
- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Friend data loaded.");
}

/*
 * Event: Decide if a given user should be displayed
 */
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id <FBGraphUser>)user
{
}


/*
 * Event: Selection changed
 */
- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Current friend selections: %@", friendPicker.selection);
}

/*
 * Event: Done button clicked
 */
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    FBFriendPickerViewController *friendPickerController =
    (FBFriendPickerViewController*)sender;
    NSLog(@"Selected friends: %@", friendPickerController.selection);
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:friendPickerController.selection forKey:@"friends"];

    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"_PinFriendPicker" object:self userInfo:userInfo];
    
    
    [self.navigationController popViewControllerAnimated:FALSE];
}

/*
 * Event: Cancel button clicked
 */
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    NSLog(@"Canceled");
    [self.navigationController popViewControllerAnimated:FALSE];
}

@end
