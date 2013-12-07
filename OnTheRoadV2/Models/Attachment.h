//
//  Attachment.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 07/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Pin;

@interface Attachment : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * in_attachment;
@property (nonatomic, retain) NSString * st_file_path;
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) Pin *pin;

@end
