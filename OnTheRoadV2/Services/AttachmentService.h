//
//  AttachmentService.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 07/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pin.h"

@interface AttachmentService : NSObject

+ (AttachmentService*)sharedInstance;
- (void)saveArrayImagePath: (NSMutableArray* )paths: (Pin *) pin;

@end
