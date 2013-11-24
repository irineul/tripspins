//
//  TripDetailViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 26/10/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface TripDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTripName;
@property (weak, nonatomic) IBOutlet UIButton *btnPins;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachs;
- (IBAction)detailPins:(id)sender;
@property (nonatomic) Trip *trip;
@end
