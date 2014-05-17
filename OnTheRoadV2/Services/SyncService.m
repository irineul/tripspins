//
//  SyncService.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 05/04/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import "SyncService.h"
#import "UserService.h"

#define WS_USER @"http://tripsandpins.com/site/index.php/api/user"
#define WS_TRIP @"http://tripsandpins.com/site/index.php/api/trips"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation SyncService

+ (SyncService*)sharedInstance
{
    static SyncService *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SyncService alloc] init];
    });
    return _sharedInstance;
}

-   (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{
    NSLog(@"String sent from server %@",[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding]);
    
}

- (NSInteger*) syncUser: (User*) user
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *postURL = [NSURL URLWithString: WS_USER];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [user txt_name], @"txt_name",
                              [user id_facebook], @"id_facebook",
                              [user txt_email], @"txt_email",
                              [user txt_password], @"txt_passowrd",
                              nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: postURL
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 60.0];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    NSURLResponse * response = nil;
    
    // Id returned by WS
    __block NSInteger *idOnServer = 0;
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   NSLog(@"TESTE");
                               } else {
                                   NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   
                                   [[UserService sharedInstance] updateIdOnServer:[NSNumber numberWithInteger: [[result objectForKey:@"_id"] integerValue]]:[user objectID]];
                               }
                           }
     ];
    
    return idOnServer;
}


- (void) syncTrip: (NSString*) txt_title: (NSString*) id_user: (NSString*) txt_status
{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        txt_title, @"txt_title",
                                        id_user, @"id_user",
                                        txt_status, @"txt_status",
                                    nil];
    
    
    NSData * JsonData =[NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString= [[NSString alloc] initWithData:JsonData encoding:NSUTF8StringEncoding];
    
    
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"%@",jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:WS_TRIP]]];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   // Handle the error
                                   
                                   NSLog(@"Server Error : %@", error);
                               } else {
                                   // Handle the success
                                   
                                   NSLog(@"Server Response :%@",response);
                               }
                           }
     ];    
    

}

//-(void) updateUser: (NSDictionary*) result
//{
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//    
//    //Insert on database
//    [[UserService share
//    [user setId_on_server:[NSNumber numberWithInteger: [[result objectForKey:@"_id"] integerValue]]];
//    
//    
//    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
//        if(!success)
//            NSLog(@"%@", error);
//    }];
//    
//}
@end
