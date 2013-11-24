//
//  MainViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 15/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteService.h"

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NoteService *noteService;
    TripService *tripService;
}

@property (weak, nonatomic) IBOutlet UILabel *labelCurrentTrip;
@property (weak, nonatomic) IBOutlet UIButton *btnInitTrip;
@property (weak, nonatomic) IBOutlet UILabel *labelApproxAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelLongitude;
@property (weak, nonatomic) IBOutlet UILabel *labelLatitude;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePic;
@property (weak, nonatomic) IBOutlet UIButton *btnMakeMovie;
@property (weak, nonatomic) IBOutlet UIButton *btnWriteNote;
@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
- (IBAction)takePicture:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *finishTrip;
@property (weak, nonatomic) IBOutlet UIButton *btnPin;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
- (IBAction)listTrips:(id)sender;

- (IBAction)initTrip:(id)sender;

@end
