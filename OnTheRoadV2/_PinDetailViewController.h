//
//  _PinDetailViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 21/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

#import "Pin.h"

@interface _PinDetailViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate, UITextViewDelegate>

@property (nonatomic) Pin *pinSelected;
@property (nonatomic) NSArray *pinsTrip;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end
