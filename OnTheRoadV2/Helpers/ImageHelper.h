//
//  ImageHelper.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 07/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject

+ (ImageHelper*)sharedInstance;
- (NSString*) saveImageAndReturnPath:(UIImage*)image;
- (NSString *) getUniqueIdentifier;

@end
