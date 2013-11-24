//
//  NoteService.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 28/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
#import "Note.h"
#import "TripService.h"
#import "Pin.h"

@interface NoteService : NSObject{
    TripService *tripService;
}

-(BOOL) insert:(Note *)note: (NSManagedObjectID *) idCurrentTrip;
-(NSArray*) getNotesFromPin:(Pin*) pinId;

@end
