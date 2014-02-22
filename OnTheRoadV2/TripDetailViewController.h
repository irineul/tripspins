//
//  TripDetailViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 19/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>


//Models
#import "Trip.h"

@interface TripDetailViewController : UIViewController <GMSMapViewDelegate>

@property (nonatomic) Trip *trip;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@end
