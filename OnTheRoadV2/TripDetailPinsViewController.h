//
//  TripDetailPinsViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 27/10/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface TripDetailPinsViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Trip *trip;

@end
