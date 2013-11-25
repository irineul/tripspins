//
//  Pin.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 24/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, Note, Trip;

@interface Pin : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * dec_latitude;
@property (nonatomic, retain) NSDecimalNumber * dec_longitude;
@property (nonatomic, retain) NSDate * dt_start;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * st_description;
@property (nonatomic, retain) Attachment *attachments;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) Trip *trip;
@end

@interface Pin (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
