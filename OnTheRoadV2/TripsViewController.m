//
//  TripsViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 31/08/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "TripsViewController.h"
#import "TripTableCell.h"
#import "Trip.h"
#import "NewTripViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TripDetailViewController.h"

@interface TripsViewController ()
@property (strong) NSMutableArray *trips;
@end

@implementation TripsViewController
{
    NSArray *tripsDb;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    /* Get all trips from database */
    tripsDb = [Trip MR_findAll];
    
    [self.tableTrips reloadData];
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tripsDb count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSNumber* atts = [trip int_total_attach];
    NSDate* dtStart = [trip dt_start];
    NSDate* dtFinish = [trip dt_finish];
    
    NSString* stPins = [NSString stringWithFormat:@"%d pins", [pins intValue]];
    NSString* stAttachs = [NSString stringWithFormat:@"%d attachments", [atts intValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString *stStart = [formatter stringFromDate:dtStart];
    NSString *stFinish = [formatter stringFromDate:dtFinish];
    
    if(![trip bool_in_active]){
        stFinish = @"Not finished";
    }
    
    NSString* stTripDate = [NSString stringWithFormat:@"%@ - %@", stStart, stFinish];
    

    cell.nameLabel.text = [trip st_name];
    cell.pinsLabel.text = stPins;
    cell.attsLabel.text = stAttachs;
    cell.dateLabel.text = stTripDate;
    cell.thumbnailImageView.image = [UIImage imageNamed:@"ic_see_on_map.png"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TripDetailViewController *tripDetailView = [[TripDetailViewController alloc] init];
    tripDetailView.trip = tripsDb[indexPath.row];
    [self presentModalViewController:tripDetailView animated:YES];
}

@end
