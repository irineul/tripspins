//
//  Pin.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 22/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, Note, PinFBFriend, Trip;

@interface Pin : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * dec_latitude;
@property (nonatomic, retain) NSDecimalNumber * dec_longitude;
@property (nonatomic, retain) NSDate * dt_start;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * st_description;
@property (nonatomic, retain) NSString * st_title;
@property (nonatomic, retain) NSSet *attachments;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) Trip *trip;
@end

@interface Pin (CoreDataGeneratedAccessors)

- (void)addAttachmentsObject:(Attachment *)value;
- (void)removeAttachmentsObject:(Attachment *)value;
- (void)addAttachments:(NSSet *)values;
- (void)removeAttachments:(NSSet *)values;

- (void)addFriendsObject:(PinFBFriend *)value;
- (void)removeFriendsObject:(PinFBFriend *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
