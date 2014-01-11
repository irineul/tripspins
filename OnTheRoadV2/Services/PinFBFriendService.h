//
//  PinFBFriendService.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 11/01/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinFBFriendService : NSObject


+ (PinFBFriendService*)sharedInstance;
- (NSArray*) createFBFriendModels: (NSArray*) friends;
@end
