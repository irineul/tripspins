//
//  LoginViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 23/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)loginFailed;

@end

@implementation LoginViewController
@synthesize spinner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    
    self.spinner.hidesWhenStopped = YES;
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLogin:(id)sender {
    
    [self.spinner startAnimating];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.spinner stopAnimating];
}


- (IBAction)skip:(id)sender {
    _MainViewController *main = [[_MainViewController alloc] init];
    [self.navigationController pushViewController:main animated:NO];
    
}

#pragma FB Methods
- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
}

@end
