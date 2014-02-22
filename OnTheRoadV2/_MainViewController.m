//
//  _MainViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 11/01/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import "_MainViewController.h"

#import "TripDetailViewController.h"


@interface _MainViewController ()

@end

@implementation _MainViewController
{
    NSArray *tripsDb;
    NSManagedObjectID *idCurrentTrip;
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
    
    [self.tabBar setSelectedItem:_tripsBarItem];
    
    [self createNavigationItems];
    
    /* Get all trips from database */
    [self verifyActiveTrip];
    
    NSLog(@"%d", self.isActiveTrip);
    
    //Notification of new Trip
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateCurrentTrip:)
     name:@"NewTrip"
     object:nil];
    
    //init objects
    tripService = [[TripService alloc] init];
    imageHelper = [[ImageHelper alloc] init];
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    //[self.tripsTable addGestureRecognizer:tap];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    /* Get all trips from database */
    tripsDb = [Trip MR_findAllSortedBy:@"dt_finish" ascending:false];
    
    [self.tripsTable reloadData];
    
    [self toggleDropdownView:YES animated:YES];
    
    
    NSLog(@"Appear %d", self.isActiveTrip);
    
    [super viewDidAppear:animated];
    
}

- (void)verifyActiveTrip{
    tripsDb = [Trip MR_findAllSortedBy:@"dt_finish" ascending:true];
    bool isActiveTrip = false;
    
    for (int x=0; x < [tripsDb count]; x++) {
        if([[tripsDb objectAtIndex:x] bool_in_active]){
            isActiveTrip = true;
            break;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark
#pragma Navigation Bar manipulation
- (void)createNavigationItems{
    
    // The button in the top-right
    UIButton *dropboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // The icon you want to use for the button
    [dropboxButton setImage:[UIImage imageNamed:@"more_icon_3"] forState:UIControlStateNormal];
    // This defines which method is triggered when the button is tapped
    [dropboxButton addTarget:self action:@selector(navButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    dropboxButton.frame = CGRectMake(0, 0, 44, 44);
    // Wrapping the button in a UIBarButtonItem
    UIBarButtonItem *dropboxItem = [[UIBarButtonItem alloc] initWithCustomView:dropboxButton];
    // Adding it to the navigationcontroller
    self.navigationItem.rightBarButtonItem = dropboxItem;
    
    // Setting the original background-color to black
    self.view.backgroundColor = [UIColor blackColor];
    // Adding a view on top of it, because when we show the dropdown, we want to lower the opacity without fading out the dropdown (due to it being a subview of self.view)
    _bottomView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bottomView.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:_bottomView];
    
    // Creating the dropdown as a UITableView, and setting its delegates to this ViewController
    CGFloat dropdownHeight;
    dropdownHeight = (CGRectGetHeight(self.view.frame)/4);
    
    _dropdownView = [[UITableView alloc]
                     initWithFrame:CGRectMake(0, -dropdownHeight, self.view.frame.size.width, dropdownHeight)
                     style:UITableViewStylePlain];
    _dropdownView.delegate = self;
    _dropdownView.dataSource = self;
    _dropdownView.scrollEnabled = NO;
    
    [self.view addSubview:_dropdownView];
}

// Called when the button is tapped
- (void)navButtonTapped
{
    BOOL toggle = (_dropdownView.frame.origin.y <= 64 && _dropdownView.frame.origin.y >= 63) ? YES : NO;
    NSLog(@" float = %f", _dropdownView.frame.origin.y);
    [self toggleDropdownView:toggle animated:YES];
}

// Showing the actual dropdown view
- (void)toggleDropdownView:(BOOL)toggle animated:(BOOL)animated
{
    CGRect destination = _dropdownView.frame;
    float backgroundOpacity = (toggle) ? 1 : 0.6;
    // toggle == YES means the dropdown should appear
    destination.origin.y = (toggle) ? -destination.size.height+64 : 64;
    // If the animated-parameter is false, animate it with a duration of zero
    NSTimeInterval duration = (animated) ? 0.4 : 0;
    // Animating the opacity & dropdown position
    [UIView animateWithDuration:duration animations:^{
        _dropdownView.frame = destination;
        _bottomView.layer.opacity = backgroundOpacity;
    }];
    [_dropdownView reloadData];
}

- (void)addNavigationItems{
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    
    bool isActiveTrip = false;
    
    for (int x=0; x < [tripsDb count]; x++) {
        if([[tripsDb objectAtIndex:x] bool_in_active]){
            isActiveTrip = true;
            break;
        }
    }
    
    
    if(isActiveTrip){
        //Finish Trip button
        [buttons addObject:[[UIBarButtonItem alloc] initWithTitle:
                            @"Finish" style:UIBarButtonItemStyleBordered target:
                            self action:@selector(finishTrip)]];
        
        //New Pin button
        [buttons addObject:[[UIBarButtonItem alloc] initWithTitle:
                            @"Pin" style:UIBarButtonItemStyleBordered target:
                            self action:@selector(newPin)]];
    }
    else{
        //New Trip button
        [buttons addObject:[[UIBarButtonItem alloc] initWithTitle:
                            @"New Trip" style:UIBarButtonItemStyleBordered target:
                            self action:@selector(newTrip)]];
        
    }
    
    [self.navigationItem setRightBarButtonItems:buttons];
}

#pragma Navigation Bar actions
- (void)newPin{
    _PinViewController *pinView = [[_PinViewController alloc] init];
    pinView.idCurrentTrip = idCurrentTrip;
    [self.navigationController pushViewController:pinView animated:NO];
}

- (void)finishTrip{
    
    tripService = [[TripService alloc] init];
    [tripService finish:idCurrentTrip];
    
    [self.tripsTable reloadData];
    
    //Reload the navigation items
    [self navButtonTapped];
}

- (void)newTrip{
    NewTripViewController *newTripView = [[NewTripViewController alloc] init];
    [self.navigationController pushViewController:newTripView animated:NO];
}



#pragma Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tripsTable)
        return [tripsDb count];
    //NavBar
    else{
        if(self.isActiveTrip)
            return 2;
        else
            return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tripsTable){
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        TripTableCell *cell = (TripTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TripTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        /* Format object to present */
        Trip *trip = [tripsDb objectAtIndex:[indexPath row]];
        NSNumber* pins = [trip int_total_pin];
        NSDate* dtStart = [trip dt_start];
        NSDate* dtFinish = [trip dt_finish];
        
        NSString* stPins = [NSString stringWithFormat:@"%d pins", [pins intValue]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *stStart = [formatter stringFromDate:dtStart];
        NSString *stFinish;
        NSString *stTripDate;
        
        if(![trip bool_in_active]){
            stFinish = [formatter stringFromDate:dtFinish];
            stTripDate = [NSString stringWithFormat:@"%@ - %@", stStart, stFinish];
            cell.nameLabel.text = [trip st_name];
            
            
        }
        else
        {
            stTripDate = stStart;
            cell.nameLabel.text = [NSString stringWithFormat:@"%@*", [trip st_name]];
            
            //set id of the current trip
            idCurrentTrip = [trip objectID];
        }
        
        cell.pinsLabel.text = stPins;
        cell.dateLabel.text = stTripDate;
        cell.thumbnailImageView.image = [UIImage imageNamed:@"pin.png"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else{
        UITableViewCell *cell = [_dropdownView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
        
        cell.textLabel.text = [self titleForCellAtIndexPath:indexPath];
        if(indexPath.row == 0)
            cell.imageView.image = [UIImage imageNamed:@"plus.png"];
        //Just apresent other row if the user is on a trip
        else{
            if(self.isActiveTrip)
                cell.imageView.image = [UIImage imageNamed:@"finish.png"];
        }
        
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tripsTable)
        return 78;
    else
        return 64;
}



- (NSString *)titleForCellAtIndexPath:(NSIndexPath *)idxPath
{
    
    self.isActiveTrip = false;
    
    for (int x=0; x < [tripsDb count]; x++) {
        if([[tripsDb objectAtIndex:x] bool_in_active]){
            self.isActiveTrip = true;
            idCurrentTrip = [[tripsDb objectAtIndex:x] objectID];
            break;
        }
    }
    
    NSString *title;
    
    if(self.isActiveTrip){
        switch (idxPath.row) {
            case 0:
                title = @"Add pin";
                break;
            case 1:
                title = @"Finish current trip";
                break;
        }
    }
    else{
        switch (idxPath.row) {
            case 0:
                title = @"Add trip";
                break;
        }
    }
    return title;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tripsTable){
        [self.tripsTable deselectRowAtIndexPath:indexPath animated:NO];
        TripDetailViewController *tripDetailView = [[TripDetailViewController alloc] init];
        tripDetailView.trip = tripsDb[indexPath.row];
        [self.navigationController pushViewController:tripDetailView animated:NO];
    }
    else{
        if(self.isActiveTrip){
            //Add pin
            if(indexPath.row == 0)
                [self newPin];
            //Finish trip
            else
                [self finishTrip];
        }
        else{
            [self newTrip];
        }
    }
}


#pragma mark
#pragma taps methods

/*-(void)didTapOnTableView:(UIGestureRecognizer*) recognizer {
    //CGPoint tapLocation = [recognizer locationInView:self.tripsTable];
    [self toggleDropdownView:YES animated:YES];
}*/


- (void)updateCurrentTrip:(NSNotification *) notification {
    NSDictionary* userInfo = notification.userInfo;
    idCurrentTrip = [userInfo objectForKey:@"idCurrentTrip"];
    if(idCurrentTrip != nil){
        self.isActiveTrip = YES;
    }
    else{
        self.isActiveTrip = NO;
    }
}
@end