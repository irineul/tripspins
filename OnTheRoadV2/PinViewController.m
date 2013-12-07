//
//  PinViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 21/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "PinViewController.h"
#import "NoteViewController.h"
#import "AudioPlayerViewController.h"
#import "Pin.h"
#import <CoreLocation/CoreLocation.h>
#import "AttachmentService.h"
#import "ImageHelper.h"

@interface PinViewController ()

@end

@implementation PinViewController
{
    NSMutableArray *notes;
    NSMutableArray *pictures;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
}

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

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self setUserPosition];
    
    //Initialize notes array
    notes = [[NSMutableArray alloc] init];
    //Initialize pics array
    pictures = [[NSMutableArray alloc] init];
    
    //Get the attachs
    //Note
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noteNotificationhandler:)
                                                 name:@"NoteViewDismiss" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma button actions
#pragma picture
- (IBAction)takePicture:(id)sender {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}
- (void)takeNewPhotoFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:NULL];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    
    //Save image, get the path and add to the array of paths
    [pictures addObject:[[ImageHelper sharedInstance] saveImageAndReturnPath:image]];
    
    //Save to the user's album
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)actMovie:(id)sender {
    //TOOD
}

- (IBAction)actNote:(id)sender {
    NoteViewController *newNote = [[NoteViewController alloc] init];
    [self presentModalViewController:newNote animated:YES];
}

- (IBAction)actVoice:(id)sender {
    AudioPlayerViewController *audioViewcontorller = [[AudioPlayerViewController alloc] init];
    [self presentModalViewController:audioViewcontorller animated:YES];
}

- (IBAction)actFinish:(id)sender {
    [self savePin];
}



#pragma notificationsHandlers
-(void)noteNotificationhandler:(NSNotification *)notice{
    Note *noteAdded = [notice object];
    if(noteAdded != [NSNull null]){
        [notes addObject:noteAdded];
    }
    
}


#pragma save
-(void) savePin{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        // Get current trip
        Trip *tripDb = (Trip*) [localContext objectWithID:self.idCurrentTrip];
        
        //Create a pin
        Pin *newPin = [Pin MR_createInContext:localContext];
        [newPin setSt_description:self.txtName.text];
        [newPin setTrip:tripDb];
        /* Set latitude & longitude */
        newPin.dec_latitude = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:currentLocation.coordinate.latitude];
        newPin.dec_longitude = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:currentLocation.coordinate.longitude];
        
        //Get current pins for this trip and add the new
        NSMutableArray *currentPins = [tripDb pins];
        [currentPins addObject:newPin];
        
        /* Update trip, incrementing total pins*/
        int pins = [tripDb.int_total_pin intValue];
        NSNumber *pinsN = [NSNumber numberWithInt:pins+1];
        [tripDb setInt_total_pin:pinsN];
        
        [[newPin MR_inContext:localContext ] addNotes:[NSSet setWithArray:notes]];
        [[newPin MR_inContext:localContext ] addAttachments:[NSSet setWithArray:pictures]];
        
        [self saveAttachs:newPin];

        
    } completion:^(BOOL success, NSError *error) {
        if(!success)
            NSLog(@"%@", error);
    }];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) saveAttachs: (Pin*) pin{
    [self saveNotes:pin];
    [[AttachmentService sharedInstance] saveArrayImagePath:pictures :pin];
}

-(void) saveNotes: (Pin*) pin{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    
    for (int i=0; i<[notes count]; i++) {
        Note *note = [Note MR_createInContext:localContext];
        [note setSt_note:[[notes objectAtIndex:i] st_note]];
        [note setPin:pin];
    }
    
    //Save the context
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _txtLongitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _txtLatitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _txtAddress.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                        placemark.subThoroughfare, placemark.thoroughfare,
                                        placemark.postalCode, placemark.locality,
                                        placemark.administrativeArea,
                                        placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void) setUserPosition{
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

@end

