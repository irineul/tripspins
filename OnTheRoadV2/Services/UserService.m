//
//  UserService.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 17/05/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import "UserService.h"
#import "SyncService.h"

@implementation UserService

+ (UserService*)sharedInstance
{
    static UserService *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserService alloc] init];
    });
    return _sharedInstance;
}

- (void)persistUser: (User*) user
{
    // Verify if the user already exists on database and is synced
    if(![self isUserSynced:[user id_facebook]])
    {
        [[SyncService sharedInstance] syncUser:user];
    }
    
}

- (NSNumber*)isUserSynced: (NSString* ) id_facebook
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"id_facebook == %@", id_facebook];
    
    NSArray* users = [NSMutableArray new];
    
    users = [User MR_findAllWithPredicate:predicate1];
    if(users != nil && [users count] > 0)
    {
        return [[users objectAtIndex:0] is_synced];
    }
    else
        return 0;
}

- (User*)getUserByIdFacebook: (NSString*) id_facebook
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"id_facebook == %@", id_facebook];
    
    NSArray* users = [NSMutableArray new];
    
    users = [User MR_findAllWithPredicate:predicate1];
    if(users != nil && [users count] > 0)
    {
        return [users objectAtIndex:0];
    }
    else
        return 0;
}


- (void)updateIdOnServer:(NSNumber*) idOnServer: (NSManagedObjectID*) userId
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Get user
    User *user = (User*) [localContext objectWithID:userId];
    
    // Update id on server
    [user setId_on_server:idOnServer];
    
    // Set as synced
    [user setIs_synced:[NSNumber numberWithInt:1]];
    
    // Save
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            NSLog(@"%@", error);
    }];
    
}


@end
