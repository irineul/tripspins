//
//  NewTripViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 31/08/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>


@interface NewTripViewController : UIViewController <GMSMapViewDelegate, UITextViewDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
- (IBAction)start:(id)sender;

@end
