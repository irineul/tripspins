 //
//  MainViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 15/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "MainViewController.h"
#import "NewTripViewController.h"
#import "Trip.h"
#import <CoreLocation/CoreLocation.h>
#import "NoteViewController.h"
#import "MapViewController.h"
#import "Pin.h"
#import "TripService.h"
#import "TripsViewController.h"
#import "PinViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "_PinViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@end

@implementation MainViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSArray *tripsDb;
    NSManagedObjectID *idCurrentTrip;
    CLLocation *currentLocation;
    
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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //hide navigation controller
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    tripsDb = [Trip MR_findAll];
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self setUserPosition];
    
    bool found=false;
    /* Get the current trip, if it exists */
    Trip *bdTrip;
    for(int i =0; i<[tripsDb count]; i++){
        bdTrip = [tripsDb objectAtIndex:i];
        if(bdTrip.bool_in_active){
            found=true;
            idCurrentTrip = [bdTrip objectID];
            break;
        }
    }
    
    [self refreshView:found :bdTrip];
    
    
    [super viewDidAppear:animated];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    locationManager.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePicture:(id)sender {
    
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



- (IBAction)listTrips:(id)sender {
    TripsViewController *tripsView = [[TripsViewController alloc] init];
    [self presentModalViewController:tripsView animated:YES];
}

- (IBAction)initTrip:(id)sender {
    NewTripViewController *newTripView = [[NewTripViewController alloc] init];
    [self presentModalViewController:newTripView animated:YES];
}

- (void) setUserPosition{
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //TODO SAVE PIC
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)writeNote:(id)sender {
    NoteViewController *newNote = [[NoteViewController alloc] init];
    newNote.idCurrentTrip = idCurrentTrip;
    [self presentModalViewController:newNote animated:YES];
}
- (IBAction)finish:(id)sender {
    
    tripService = [[TripService alloc] init];
    [tripService finish:idCurrentTrip];
    
    [self refreshView:false :NULL];
    
}

-(void) refreshView: (bool) isActiveTrip:(Trip*) trip{
    //Hidde button if is inactive trip
    [self hiddenTripButtons:!isActiveTrip];
    if(!isActiveTrip){
        _labelCurrentTrip.hidden = true;
        _btnInitTrip.hidden = false;
    
    }
    else{
        NSNumber* pins = [trip int_total_pin];
        NSNumber* atts = [trip int_total_attach];
        
        _labelCurrentTrip.text = [NSString stringWithFormat: @"You're on the trip: %@. %d pins / %d attachs", [trip st_name], [pins intValue], [atts intValue]];
        
        _labelCurrentTrip.hidden = false;
        _btnInitTrip.hidden = true;
    }
}

- (IBAction)pin:(id)sender {
    _PinViewController *pinView = [[_PinViewController alloc] init];
    pinView.idCurrentTrip = idCurrentTrip;
    [self.navigationController pushViewController:pinView animated:NO];
}

- (void) attachPin{
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    /* Initialie magicalrecord objects  */
    Pin *newPin = [Pin MR_createInContext:localContext];

    /* Set latitude & longitude */
    newPin.dec_latitude = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:currentLocation.coordinate.latitude];
    newPin.dec_longitude = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:currentLocation.coordinate.longitude];
    
    
    /* Get current trip */
    Trip *currentTrip = (Trip*) [localContext objectWithID:idCurrentTrip];
    
    newPin.trip = currentTrip;
    
    
    /* Update trip, incrementing total attachs*/
    int pins = [currentTrip.int_total_pin intValue];
    NSNumber *pinsN = [NSNumber numberWithInt:pins+1];
    [currentTrip setInt_total_pin:pinsN];
    
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
    
    NSNumber* attsTxt = [currentTrip int_total_attach];
    
    _labelCurrentTrip.text = [NSString stringWithFormat: @"You're on the trip: %@. %d pins / %d attachs", [currentTrip st_name], [pinsN intValue], [attsTxt intValue]];

}
- (IBAction)callMap:(id)sender {
    MapViewController *mapView = [[MapViewController alloc] init];
    mapView.idCurrentTrip = idCurrentTrip;
    mapView.currentLocation = currentLocation;
    [self.navigationController pushViewController:mapView animated:NO];
}

#pragma Trip Buttons
- (void)enableTripButtons: (bool) isEnable{
    _btnFinish.enabled = isEnable;
    _btnMakeMovie.enabled = isEnable;
    _btnTakePic.enabled = isEnable;
    _btnWriteNote.enabled = isEnable;
    _btnMap.enabled = isEnable;
    _btnPin.enabled = isEnable;
}

- (void)hiddenTripButtons: (bool) isHidden{
    _btnFinish.hidden = isHidden;
    _btnMakeMovie.hidden = isHidden;
    _btnTakePic.hidden = isHidden;
    _btnWriteNote.hidden = isHidden;
    _btnMap.hidden = isHidden;
    _btnPin.hidden = isHidden;
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

#pragma Location
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
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
}

#pragma mark-
#pragma FB Methods
- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.lblUserName.text = [NSString stringWithFormat: @"Hello, %@", user.name];
                 self.userProfileImage.profileID = user.id;
             }
         }];
    }
}

@end
