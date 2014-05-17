//
//  User.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 17/05/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * txt_username;
@property (nonatomic, retain) NSString * id_facebook;
@property (nonatomic, retain) NSString * txt_email;
@property (nonatomic, retain) NSString * txt_password;
@property (nonatomic, retain) NSString * txt_name;
@property (nonatomic, retain) NSNumber * id_on_server;
@property (nonatomic, retain) NSNumber * is_synced;

@end
