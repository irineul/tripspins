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

@interface PinViewController ()

@end

@implementation PinViewController
{
    NSMutableArray *notes;
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
- (IBAction)actTakePic:(id)sender {
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



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //TODO SAVE PIC
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
        Trip *tripDb = [Trip MR_createInContext:localContext];
        // Get current trip
        tripDb = (Trip*) [localContext objectWithID:self.idCurrentTrip];
        
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
        
        NSArray* notesSaved = [[NSArray alloc] init];
        for (int i=0; i<[notes count]; i++) {
            Note *note = [Note MR_createInContext:localContext];
            [note setSt_note:[[notes objectAtIndex:i] st_note]];
            [note setPin:newPin];
        }
        
    } completion:^(BOOL success, NSError *error) {
        if(!success)
            NSLog(@"%@", error);
    }];
    



    

    

    
    /*
    //Save the context
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }]; */
    
    //Save the attachs
//    [self saveAttachs:newPin: tripDb];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) saveAttachs: (Pin*) pin:(Trip*) trip{
    [self saveNotes:pin: trip];
}

-(void) saveNotes: (Pin*) pin:(Trip*) trip{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
    } completion:^(BOOL success, NSError *error) {
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

