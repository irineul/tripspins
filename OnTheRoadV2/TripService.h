//
//  TripService.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 28/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface TripService : NSObject

-(BOOL) finish:(NSManagedObjectID*)tripId;
-(Trip*) getTrip:(NSManagedObjectID*)tripId;

@end
