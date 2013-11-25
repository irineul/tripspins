//
//  Attachment.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 24/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Pin;

@interface Attachment : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * in_attachment;
@property (nonatomic, retain) NSString * st_file_path;
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) Pin *pin;

@end
