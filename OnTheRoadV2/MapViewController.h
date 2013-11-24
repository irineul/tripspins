//
//  PinViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 16/10/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController <GMSMapViewDelegate>
@property (weak, nonatomic) CLLocation *currentLocation;
@property (nonatomic) NSManagedObjectID *idCurrentTrip;

@end
