//
//  _PinViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 14/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//


#import "_PinViewController.h"

//Helpers
#import "ImageHelper.h"
#import "FileTypesEnum.h"


//Models
#import "Pin.h"
#import "Trip.h"
#import "Attachment.h"

//iOS
#import <CoreLocation/CoreLocation.h>

@interface _PinViewController ()

@end

@implementation _PinViewController {
    GMSMapView *mapView_;
    NSMutableArray *pictures;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    bool isMapUpdated;
}

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
    
    isMapUpdated = false;
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self setUserPosition];
    
    //hide navigation controller
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    //Initialize pics array
    pictures = [[NSMutableArray alloc] init];
    
    //Create items on navigation bar
    [self addNavigationItems];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:15];
    
    
    
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,45, 320, 200) camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:_toolBar];
}

#pragma mark

#pragma Navigation Bar manipulation
- (void)addNavigationItems{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:
                                 @"Save" style:UIBarButtonItemStyleBordered target:
                                 self action:@selector(savePin)];
    
    [self.navigationItem setRightBarButtonItem:saveItem];
}

#pragma Navigation Bar Actions
#pragma save
-(IBAction) savePin{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        // Get current trip
        Trip *tripDb = (Trip*) [localContext objectWithID:self.idCurrentTrip];
        
        //Create a pin
        Pin *newPin = [Pin MR_createInContext:localContext];
        [newPin setSt_description:self.txtDescription.text];
        [newPin setTrip:tripDb];
        /* Set latitude & longitude */
        newPin.dec_latitude = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:currentLocation.coordinate.latitude];
        newPin.dec_longitude = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:currentLocation.coordinate.longitude];
        
        //Get current pins for this trip and add the new
        NSMutableArray *currentPins = [tripDb pins];
        [currentPins addObject:newPin];
        
        /* Update trip, incrementing total pins*/
        int pins = [tripDb.int_total_pin intValue];
        NSNumber *pinsN = [NSNumber numberWithInt:pins+1];
        [tripDb setInt_total_pin:pinsN];

        //Images
        for (int y=0; y<[pictures count]; y++) {
            Attachment *attachment = [Attachment MR_createInContext:localContext];
            [attachment setIn_attachment:[NSNumber numberWithInt:IMAGE]];
            [attachment setSt_file_path:[pictures objectAtIndex:y]];
            [attachment setPin:newPin];
        }
        
        
    } completion:^(BOOL success, NSError *error) {
        if(!success)
            NSLog(@"%@", error);
    }];
    
    [self dismissModalViewControllerAnimated:YES];
}


#pragma Button Actions

#pragma Take Picture
- (IBAction)takePicture:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}
- (void)takeNewPhotoFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:NULL];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    
    //Save image, get the path and add to the array of paths
    [pictures addObject:[[ImageHelper sharedInstance] saveImageAndReturnPath:image]];
    
    //Save to the user's album
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    //Verify if the map is already on the screen, if isn't then initialize the map
    if(!isMapUpdated){
        [self initMap];
        isMapUpdated = true;
    }
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void) setUserPosition{
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

@end
