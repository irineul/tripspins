//
//  PinDetailViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 23/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"

@interface PinDetailViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Pin *pin;
@property (weak, nonatomic) IBOutlet UITableView *tableAttachs;

@end
