//
//  PinFBFriendService.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 11/01/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import "PinFBFriendService.h"

//Models
#import "PinFBFriend.h"

//Others
#import <FacebookSDK/FacebookSDK.h>

@implementation PinFBFriendService

+ (PinFBFriendService*)sharedInstance
{
    static PinFBFriendService *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PinFBFriendService alloc] init];
    });
    return _sharedInstance;
}

-(NSArray*) getFriendsFromPin:(NSManagedObjectID*) pinId{
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"pin == %@", pinId];
    
    NSArray* friends = [NSMutableArray new];
    
    //Return friends of pin
    friends = [PinFBFriend MR_findAllWithPredicate:predicate1];
    return friends;
}



@end
