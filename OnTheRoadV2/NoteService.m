//
//  NoteService.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 28/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "NoteService.h"
#import "TripService.h"

@implementation NoteService


-(BOOL) insert:(Note *)note:(NSManagedObjectID *) idCurrentPin: (NSManagedObjectID *) idCurrentTrip
{
    /* Get the pin */
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    Pin *pinDb = [localContext objectWithID:idCurrentPin];
    Trip *tripDb = [localContext objectWithID:idCurrentTrip];

    note.pin = pinDb;
    
    
    /* Update trip, incrementing total attachs*/
    int attachs = [tripDb.int_total_attach intValue];
    NSNumber *atts = [NSNumber numberWithInt:attachs+1];
    [tripDb setInt_total_attach:atts];
    
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
    
    return true;
}


-(NSArray*) getNotesFromPin:(NSManagedObjectID*) pinId{
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"pin == %@", pinId];
  
    NSArray* notes = [NSMutableArray new];
    //Return notes from pin
    notes = [Note MR_findAllWithPredicate:predicate1];
    return notes;
}

@end
