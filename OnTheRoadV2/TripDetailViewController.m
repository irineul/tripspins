//
//  TripDetailViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 19/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import "TripDetailViewController.h"

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#import "_PinDetailViewController.h"

@interface TripDetailViewController ()
{
    NSArray *pins;
}

- (void) mapView: (GMSMapView *) mapView didTapInfoWindowOfMarker:(GMSMarker *) marker;

@end

@implementation TripDetailViewController{
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
    //Init map
    [self updateMap:0 :0];
    [self pinsOnMap];
    self.txtTitle.text = [_trip st_name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Map Methods
- (void)updateMap: (NSDecimalNumber*) latitude: (NSDecimalNumber*) longitude{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude.doubleValue
                                                            longitude:longitude.doubleValue
                                                                 zoom:6];

    self.mapView.camera = camera;
    self.mapView.delegate = self;
    
}

- (void)pinsOnMap{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Get current trip
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"trip == %@", _trip];
    pins = [Pin MR_findAllWithPredicate:predicate1 inContext:localContext];
    
    
    //Put the pins of the trip on the map
    if([pins count] > 0){
        
        [self updateMap:[[pins objectAtIndex:0] dec_latitude] :[[pins objectAtIndex:0] dec_longitude]];
        
        for(Pin *pin in pins){
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([pin.dec_latitude doubleValue], [pin.dec_longitude doubleValue]);
            
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            
            marker.title = [pin st_title];
            marker.map = self.mapView;
            marker.userData = pin;
        }
    }
    
    
}

-(void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    _PinDetailViewController *pinview = [[_PinDetailViewController alloc] init];
    pinview.pinSelected = marker.userData;
    //All pins
    pinview.pinsTrip = pins;
    [self.navigationController pushViewController:pinview animated:NO];
    
}


@end
