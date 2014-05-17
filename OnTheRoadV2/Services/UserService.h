//
//  UserService.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 17/05/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserService : NSObject

+ (UserService*)sharedInstance;
- (void)persistUser: (User*) user;
- (User*)getUserByIdFacebook: (NSString*) id_facebook;
- (NSNumber*)isUserSynced: (NSString* ) id_facebook;
- (void)updateIdOnServer:(NSNumber*) idOnServer: (NSManagedObjectID*) userId;
@end
