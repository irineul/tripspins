//
//  PinTableCell.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 27/10/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *latLongLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
