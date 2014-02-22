//
//  _PinImageViewController.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 22/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import "_PinImageViewController.h"

@interface _PinImageViewController ()

@end

@implementation _PinImageViewController

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

    self.navigationController.navigationBar.translucent = NO;
    
    UIImage *picture = [UIImage imageWithContentsOfFile: self.picturePath];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:picture];

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    imageView.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:imageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
