//
//  Attachment.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 23/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment_Type, Note, Pin;

@interface Attachment : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * st_file_path;
@property (nonatomic, retain) NSString * in_attachment;
@property (nonatomic, retain) Attachment_Type *attachment;
@property (nonatomic, retain) Pin *pin;
@property (nonatomic, retain) Note *note;

@end
