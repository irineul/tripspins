//
//  Trip.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 24/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pin;

@interface Trip : NSManagedObject

@property (nonatomic, retain) NSNumber * bool_in_active;
@property (nonatomic, retain) NSDate * dt_finish;
@property (nonatomic, retain) NSDate * dt_start;
@property (nonatomic, retain) NSNumber * int_total_attach;
@property (nonatomic, retain) NSNumber * int_total_pin;
@property (nonatomic, retain) NSString * st_name;
@property (nonatomic, retain) NSSet *pins;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)addPinsObject:(Pin *)value;
- (void)removePinsObject:(Pin *)value;
- (void)addPins:(NSSet *)values;
- (void)removePins:(NSSet *)values;

@end
