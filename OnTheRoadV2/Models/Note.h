//
//  Note.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 23/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, Pin;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * st_note;
@property (nonatomic, retain) Pin *pin;
@property (nonatomic, retain) Attachment *attachment;

@end
