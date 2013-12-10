//
//  AttachmentService.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 07/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "AttachmentService.h"
#import "Attachment.h"
#import "FileTypesEnum.h"
#import "Pin.h"
#import "ImageHelper.h"

@implementation AttachmentService

+ (AttachmentService*)sharedInstance
{
    static AttachmentService *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AttachmentService alloc] init];
    });
    return _sharedInstance;
}

- (void)saveArrayImagePath: (NSMutableArray* )paths: (Pin *) pin{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (int i =0; i<[paths count]; i++) {
        Attachment *attachment = [Attachment MR_createInContext:localContext];
        [attachment setIn_attachment:[NSNumber numberWithInt:1]];
        [attachment setSt_file_path:[paths objectAtIndex:i]];
        [attachment setPin:pin];
    }

    
    //Save
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
}

@end
