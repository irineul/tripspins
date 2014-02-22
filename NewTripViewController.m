//
//  NewTripViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 31/08/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "NewTripViewController.h"
#import "Trip.h"
#import <CoreLocation/CoreLocation.h>

@interface NewTripViewController ()

@end

@implementation NewTripViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *currentLocation;
    bool isMapUpdated;
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
    
    isMapUpdated = false;
    
    [self addNavigationItems];
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self setUserPosition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save
{

    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Trip *trip = [Trip MR_createInContext:localContext];
    NSString *name = self.name.text;
    trip.st_name = name;
    trip.int_total_pin = 0;
    trip.int_total_attach = 0;
    trip.bool_in_active = [[NSNumber alloc] initWithBool:true];
    
    NSDate *currentDate = [NSDate date];
    trip.dt_start = currentDate;
    
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[trip objectID] forKey:@"idCurrentTrip"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"NewTrip" object:self userInfo:userInfo];
    
    [self.navigationController popViewControllerAnimated:FALSE];
    
}

#pragma mark - Map Methods
- (void)initMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:15];
    
    
    
    
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = true;
}

#pragma mark - Location Methods
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
    
    //Verify if the map is already on the screen, if isn't then initialize the map
    if(!isMapUpdated){
        [self initMap];
        isMapUpdated = true;
    }
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
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

#pragma mark - Navigation Bar manipulation
- (void)addNavigationItems{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:
                                 @"Save" style:UIBarButtonItemStyleBordered target:
                                 self action:@selector(save)];
    
    [self.navigationItem setRightBarButtonItem:saveItem];
}

#pragma mark - Others Methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
}
@end
