//
//  PinCell.h
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 13/02/14.
//  Copyright (c) 2014 On The Road. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PinCell : NSObject

//1 - Picture
//2 - Friend
@property (nonatomic, strong) NSNumber * cellType;
@property (nonatomic, retain) NSString * profileId;
@property (nonatomic, retain) UIImage * picture;
@property (nonatomic, retain) NSString * picturePath;

@end
