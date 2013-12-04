//
//  PinViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 21/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (nonatomic) NSManagedObjectID *idCurrentTrip;
@property (weak, nonatomic) IBOutlet UILabel *txtLongitude;
@property (weak, nonatomic) IBOutlet UILabel *txtLatitude;
@property (weak, nonatomic) IBOutlet UILabel *txtAddress;

-(NSString *) saveImageIntoDocumentsDirectoryAndReturnPath:(UIImage *)imageToSave;
-(NSString *) getUniqueIdentifier;

@end
