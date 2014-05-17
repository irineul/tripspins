//
//  AppDelegate.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 31/08/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "AppDelegate.h"

#import "TripsViewController.h"
#import "LoginViewController.h"
#import "_MainViewController.h"
#import "User.h"
#import "UserService.h"
#import "Services/SyncService.h"

NSString *const SCSessionStateChangedNotification = @"br.com.trippins.OnTheRoadV2";

@interface AppDelegate()

@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) _MainViewController *mainViewController;

- (void)showLoginView;

@end

@implementation AppDelegate
@synthesize navController = _navController;
@synthesize mainViewController = _mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"tp.sqlite"];
    
    
    [GMSServices provideAPIKey:@"AIzaSyAlBGR6bIYrLaZof-U8PIs3FzOX8m1sIgs"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // See if the app has a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
        
        self.mainViewController = [[_MainViewController alloc]
                                   initWithNibName:@"_MainViewController" bundle:nil];
        
        UINavigationController *navController = [[UINavigationController alloc]
                                                 initWithRootViewController:self.mainViewController];
        
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
        
        //        [[UserService sharedInstance] persistUser:user];
        
        
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma FB Methods

- (void)createAndPresentLoginView {
    if (self.loginViewController == nil) {
        
        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController"
                                                                         bundle:nil];
        
        
        
        UINavigationController *navController = [[UINavigationController alloc]
                                                 initWithRootViewController:self.loginViewController];
        
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
        
    }
}

- (void)showLoginView {
    if (self.loginViewController == nil) {
        [self createAndPresentLoginView];
    } else {
        [self.loginViewController loginFailed];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            self.mainViewController = [[_MainViewController alloc] initWithNibName:@"_MainViewController" bundle:nil];
            
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
                if (error) {
                    // Handle error
                }
                
                else {
                    // If the user is not synced yet...
                    if(![[UserService sharedInstance] isUserSynced:[FBuser id]])
                    {
                        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
                        User *user = [User MR_createInContext:localContext];
                        [user setTxt_email:[FBuser objectForKey:@"email"]];
                        [user setTxt_name:[FBuser name]];
                        [user setId_facebook:[FBuser id]];
                        [user setIs_synced:[NSNumber numberWithInt:0]];
                        
                        // Save new user :)
                        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
                            if(!success)
                                NSLog(@"%@", error);
                        }];
                        
                        // Sync to ws
                        [[SyncService sharedInstance] syncUser:user];
                    }
                }
            }];
            
            self.window.rootViewController = self.mainViewController;
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
            break;
        }
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification
                                                        object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"usr_id::%@",user.id);
    NSLog(@"usr_first_name::%@",user.first_name);
    NSLog(@"usr_middle_name::%@",user.middle_name);
    NSLog(@"usr_last_nmae::%@",user.last_name);
    NSLog(@"usr_Username::%@",user.username);
    NSLog(@"usr_b_day::%@",user.birthday);
    
}

@end
