//
//  _PinViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 14/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

//Services
#import "PinFBFriendService.h"

//Models
#import "Trip.h"

@interface _PinViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate, UITextViewDelegate, AVAudioRecorderDelegate>{
    UIButton *navButton;
    PinFBFriendService *pinFBFriendService;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) NSManagedObjectID *idCurrentTrip;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@end