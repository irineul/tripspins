//
//  _MainViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 11/01/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>

//Cells
#import "TripTableCell.h"

//Models
#import "Trip.h"

//Controllers
#import "_PinViewController.h"
#import "NewTripViewController.h"

//Services
#import "TripService.h"
#import "ImageHelper.h"

@interface _MainViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{
    TripService *tripService;
    UITableView *_dropdownView;
    UIView *_bottomView;
    ImageHelper *imageHelper;
}

@property (weak, nonatomic) IBOutlet UITableView *tripsTable;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tripsBarItem;
@property (nonatomic) bool isActiveTrip;


@end
