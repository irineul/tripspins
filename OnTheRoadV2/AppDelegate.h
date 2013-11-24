//
//  AppDelegate.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 31/08/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const SCSessionStateChangedNotification;

@class ViewController;
@class MainViewController;



@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

/*
@property (strong, nonatomic) LoginViewController *mainViewController;
@property (strong, nonatomic) UINavigationController* navController;
*/

- (void)openSession;

@end



