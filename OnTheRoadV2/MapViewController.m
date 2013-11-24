//
//  PinViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 16/10/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Trip.h"
#import "Pin.h"
#import "PinDetailViewController.h"

@interface MapViewController()

- (void) mapView: (GMSMapView *) mapView didTapInfoWindowOfMarker:(GMSMarker *) marker;

@end

@implementation MapViewController{
    GMSMapView *mapView_;
    
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
    [self updateMap];    
    [self pinsOnMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView {

    [self pinsOnMap];
}

- (void)updateMap{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_currentLocation.coordinate.latitude
                                                            longitude:_currentLocation.coordinate.longitude
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;

}

- (void)pinsOnMap{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Get current trip
    Trip *currentTrip = (Trip*) [localContext objectWithID:_idCurrentTrip];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"trip == %@", currentTrip];
    NSArray *pinsFromTrip = [Pin MR_findAllWithPredicate:predicate1 inContext:localContext];
    
    
    //Put the pins of current trip on the map
    for(Pin *pin in pinsFromTrip){
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([pin.dec_latitude doubleValue], [pin.dec_longitude doubleValue]);
        
        GMSMarker *marker = [GMSMarker markerWithPosition:position];

        marker.title = [pin st_description];
        marker.map = mapView_;
        marker.userData = pin;
    }
    
}

-(void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    PinDetailViewController *pinview = [[PinDetailViewController alloc] init];
    pinview.pin = marker.userData;
    [self presentModalViewController:pinview animated:YES];

}

#pragma mark - CLLocationManagerDelegate

@end
