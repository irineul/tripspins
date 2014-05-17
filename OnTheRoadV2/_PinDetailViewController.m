//
//  _PinDetailViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 21/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import "_PinDetailViewController.h"

//Services
#import "AttachmentService.h"
#import "PinFBFriendService.h"

//Helpers
#import "PinCell.h"
#import "ImageHelper.h"

//Models
#import "Attachment.h"

//Controllers
#import "TripDetailViewController.h"
#import "_PinImageViewController.h"


//Others
#import <FacebookSDK/FacebookSDK.h>

@interface _PinDetailViewController ()
{
    NSMutableArray *collectionViewCells;
}

@end

@implementation _PinDetailViewController

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
 
    //Initialize variables
    collectionViewCells = [[NSMutableArray alloc] init];
    
    //Disable fields
    self.txtTitle.enabled = NO;
    [self.txtDescription setEditable:NO];
    
    //Set texts
    self.txtTitle.text = self.pinSelected.st_title;
    self.txtDescription.text = self.pinSelected.st_description;
    
    //Load information
    //TODO: Threads
    [self initMap];
    [self setPinsOnTheMap];
    [self initCollectionView];
    [self loadCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collection View Methods
- (void)loadCollectionView{
    NSArray* attachments = [[AttachmentService sharedInstance] getAttachmentsFromPin:[self.pinSelected objectID]];
    NSArray* friends = [[PinFBFriendService sharedInstance] getFriendsFromPin:[self.pinSelected objectID]];
    
    [self addPictureCells:attachments];
    [self addFriendCells:friends];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
/*    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self back];
    } */
}
- (void)initCollectionView{
    
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
}


- (void)addPictureCells: (NSArray*) attachments
{
    for (int x = 0; x<[attachments count]; x++)
    {
        //Add the type of cell
        PinCell *cell = [[PinCell alloc] init];
        NSNumber* cellType = [NSNumber numberWithInt:1];
        cell.cellType = cellType;

        //Load image
        UIImage* image = [[ImageHelper sharedInstance] loadImageFromDocumentsDirectory:[[attachments objectAtIndex:x] st_file_path]];
        
        [cell setPicture:image];
        [cell setPicturePath:[[attachments objectAtIndex:x] st_file_path]];
        [collectionViewCells insertObject:cell atIndex:0];
    }
}

- (void)addFriendCells: (NSArray*) friends
{
    for (int x = 0; x<[friends count]; x++)
    {
        //Add the type of cell
        PinCell *cell = [[PinCell alloc] init];
        NSNumber* cellType = [NSNumber numberWithInt:2];
        cell.cellType = cellType;
        [cell setProfileId:[[friends objectAtIndex:x] id]];
        [collectionViewCells insertObject:cell atIndex:0];
    }
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [collectionViewCells count];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
        imageView.frame = CGRectMake(0, 0, 100, 100);
        
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
    
    return [[UICollectionViewCell alloc] init];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%d", indexPath.row);
    //Picture
    if(([[collectionViewCells objectAtIndex:(indexPath.row)] cellType]) == [NSNumber numberWithInt:1])
    {
        _PinImageViewController *pinImageView = [[_PinImageViewController alloc] init];
        pinImageView.picturePath = [[collectionViewCells objectAtIndex:indexPath.row] picturePath];
        [self.navigationController pushViewController:pinImageView animated:NO];
    }
    
}


#pragma mark Map Methods
- (void)initMap{
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.pinSelected.dec_latitude doubleValue]
                                                            longitude:[self.pinSelected.dec_longitude doubleValue]
                                                                 zoom:[self calculateMapZoom]];
    
    
    
    
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = true;
}

- (void)setPinsOnTheMap
{
    for(Pin *pin in self.pinsTrip){
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([pin.dec_latitude doubleValue], [pin.dec_longitude doubleValue]);
        
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.title = [pin st_title];
        marker.map = self.mapView;
        marker.userData = pin;
    }
}

- (float)calculateMapZoom
{
    //+ PINS -ZOOM
    float zoom = 15;
    for (int x = 0; x < [self.pinsTrip count]; x++) {
        if(zoom <= 5)
            break;
        zoom--;
    }
    return zoom;
}

-(void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    _PinDetailViewController *pinview = [[_PinDetailViewController alloc] init];
    pinview.pinSelected = marker.userData;
    //All pins
    pinview.pinsTrip = self.pinsTrip;
    
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:pinview animated:YES];

}


@end
