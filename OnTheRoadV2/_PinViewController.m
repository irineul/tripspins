//
//  _PinViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 14/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//


//Header
#import "_PinViewController.h"

//Helpers
#import "ImageHelper.h"
#import "FileTypesEnum.h"
#import "PinCell.h"


//Models
#import "Pin.h"
#import "Trip.h"
#import "Attachment.h"
#import "PinFBFriend.h"

//iOS
#import <CoreLocation/CoreLocation.h>

//Controllers
#import "_PinFriendPickerViewController.h"




@interface _PinViewController ()

@end

@implementation _PinViewController {
    NSMutableArray *pictures;
    NSMutableArray *images;
    NSMutableArray* cells;
    NSMutableArray* collectionViewCells;
    NSArray *selectedFriends;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    bool isMapUpdated;
    bool isFriendSelection;
    NSInteger *rowSelected;
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
    isFriendSelection = false;
    
    pinFBFriendService = [[PinFBFriendService alloc] init];
    
    //Notification of selected friends
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(saveFriendsSelected:)
     name:@"_PinFriendPicker"
     object:nil];
    
    
    //User's position
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self setUserPosition];
    
    //hide navigation controller: No
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    //Initialize arrays
    pictures = [[NSMutableArray alloc] init];
    images = [[NSMutableArray alloc] init];
    cells = [[NSMutableArray alloc] init];
    collectionViewCells = [[NSMutableArray alloc] init];
    selectedFriends = [[NSArray alloc] init];
    
    //Create items on navigation bar
    [self addNavigationItems];
    
    
    //Register cells
    UINib *cellNib = [UINib nibWithNibName:@"ThumbnailCollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.collectionView.frame.size;
    [flowLayout setItemSize:CGSizeMake(75, 75)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.txtDescription.delegate = self;
    self.txtDescription.returnKeyType = UIReturnKeyDone;
    
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
    
    
    
    
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = true;
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
        [newPin setSt_title:self.txtTitle.text];
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
        
        //friends
        for (FBGraphObject<FBGraphUser> * friend in selectedFriends) {
            PinFBFriend *fbFriend = [PinFBFriend MR_createInContext:localContext];
            [fbFriend setId:[friend id]];
            [fbFriend setName:[friend first_name]];
            [fbFriend setLast_name:[friend last_name]];
            [fbFriend setPin:newPin];
        }
        
    } completion:^(BOOL success, NSError *error) {
        if(!success)
            NSLog(@"%@", error);
    }];
    
    [self.navigationController popViewControllerAnimated:FALSE];
}

#pragma Button Actions
- (IBAction)selectFriend:(id)sender {
    _PinFriendPickerViewController *pinFriendView = [[_PinFriendPickerViewController alloc] init];
    [self.navigationController pushViewController:pinFriendView animated:NO];
}

- (void)saveFriendsSelected:(NSNotification *) notification {
    NSDictionary* userInfo = notification.userInfo;
    selectedFriends = [userInfo objectForKey:@"friends"];
    
    isFriendSelection = true;
    
    NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
    
    
    for (int i = 0; i < [selectedFriends count]; i++){
        
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        
        //Add the type of cell
        PinCell *cell = [[PinCell alloc] init];
        NSNumber* cellType = [NSNumber numberWithInt:2];
        cell.cellType = cellType;
        [cell setProfileId:[[selectedFriends objectAtIndex:i] id]];
        [collectionViewCells insertObject:cell atIndex:i];
    }
    
    
    [_collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
    
}

#pragma Take Picture
- (IBAction)takePicture:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1){
        [self deleteCell:rowSelected];
    }
    else if(actionSheet.tag == 2){
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
    if(!picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary )
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //Save thumbnail
    CGSize destinationSize = CGSizeMake(125, 125);
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:newImage];
    
    isFriendSelection = false;
    
    //Add the type of cell
    PinCell *cell = [[PinCell alloc] init];
    NSNumber* cellType = [NSNumber numberWithInt:1];
    cell.cellType = cellType;
    [cell setPicture:newImage];
    [collectionViewCells insertObject:cell atIndex:0];
    
    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    
    
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

#pragma Collectionview

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [collectionViewCells count];
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *identifier = @"Cell";
    
    NSLog(@"%@",[[collectionViewCells objectAtIndex:(indexPath.row)] cellType]);
    //Picture
    if(([[collectionViewCells objectAtIndex:(indexPath.row)] cellType]) == [NSNumber numberWithInt:1]){
        
        UICollectionViewCell *cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        
        FBProfilePictureView *friendImage = (FBProfilePictureView*) [cell viewWithTag:101];
        
        friendImage.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        UIImage *picture = [[collectionViewCells objectAtIndex:indexPath.row] picture
                            ];
        imageView.image = picture;
        return cell;
        
    }
    //FB Friend
    else if(([[collectionViewCells objectAtIndex:indexPath.row] cellType]) ==[NSNumber numberWithInt:2]){
        
        UICollectionViewCell *cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        FBProfilePictureView *friendImage = (FBProfilePictureView*) [cell viewWithTag:101];
        
        friendImage.profileID = [[collectionViewCells objectAtIndex:indexPath.row] profileId
                                 ];
        return cell;
    }
    
}

- (void)deleteCell:(NSInteger*) row{
    [collectionViewCells removeObjectAtIndex:row];
    if([collectionViewCells count] == 0){
        [_collectionView reloadData];
    }
    else{
        [self.collectionView performBatchUpdates:^{
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:row inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Delete", nil];
    
    actionSheet.tag = 1;
    rowSelected = indexPath.row;
    
    [actionSheet showInView:self.view];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = [[[self tabBarController] tabBar] frame];
    frame.origin.y = 712;
    [UIView animateWithDuration:0.25f animations:^
     {
         [[[self tabBarController] tabBar] setFrame:frame];
     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
@end

