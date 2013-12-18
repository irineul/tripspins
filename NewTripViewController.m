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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)start:(id)sender {

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
    
    _status.text = @"Trip started!";
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) setUserPosition{
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
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
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

@end
