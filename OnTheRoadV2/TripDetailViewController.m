//
//  TripDetailViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 26/10/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "TripDetailViewController.h"
#import "TripDetailPinsViewController.h"

@interface TripDetailViewController ()

@end

@implementation TripDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTripDetails];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Trip Details
- (void)setTripDetails{
    _lblTripName.text = [_trip st_name];
    NSNumber* pins = [_trip int_total_pin];
    NSNumber* atts = [_trip int_total_attach];
    
    NSString* textBtnPins = [NSString stringWithFormat: @"Detail %d pins >>", [pins intValue]];
    NSString* textBtnAttachs = [NSString stringWithFormat: @"Detail %d attachments >>", [atts intValue]];
    
    [_btnPins setTitle:textBtnPins forState:UIControlStateNormal];
    [_btnAttachs setTitle:textBtnAttachs forState:UIControlStateNormal];
}


- (IBAction)detailPins:(id)sender {
    TripDetailPinsViewController *tripDetailPinsView = [[TripDetailPinsViewController alloc] init];
    tripDetailPinsView.trip = _trip;
    [self presentModalViewController:tripDetailPinsView animated:YES];
}
@end
