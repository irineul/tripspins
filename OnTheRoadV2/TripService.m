//
//  TripService.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 28/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "TripService.h"

@implementation TripService


-(BOOL) finish:(NSManagedObjectID*)tripId
{

    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    /* Get trip */
    Trip *tripDb = [Trip MR_createInContext:localContext];
    tripDb = (Trip*) [localContext objectWithID:tripId];
    
    tripDb.bool_in_active = false;
    NSDate *currentDate = [NSDate date];
    tripDb.dt_finish = currentDate;
    
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
    
    return true;
}

-(BOOL) update: (Trip*) trip{
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    Trip *tripDb = [Trip MR_createInContext:localContext];
    tripDb = trip;
    
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
    
    return true;
}

-(Trip*) getTrip:(NSManagedObjectID*)tripId{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    return [localContext objectWithID:tripId];
}

@end
