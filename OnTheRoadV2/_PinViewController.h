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

@interface _PinViewController : UIViewController <GMSMapViewDelegate>{
    UIButton *navButton;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) NSManagedObjectID *idCurrentTrip;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@end