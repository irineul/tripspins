//
//  SyncService.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 05/04/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
#import "User.h"


@interface SyncService : NSURLConnection
+ (SyncService*)sharedInstance;
- (void) syncTrip: (NSString*) txt_title: (NSString*) id_user: (NSString*) txt_status;
- (void) syncUser: (User*) user;
@end

