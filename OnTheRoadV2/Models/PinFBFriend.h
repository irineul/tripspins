//
//  PinFBFriend.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 22/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pin;

@interface PinFBFriend : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) Pin *pin;

@end
