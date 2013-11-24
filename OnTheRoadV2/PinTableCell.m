//
//  PinTableCell.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 27/10/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "PinTableCell.h"

@implementation PinTableCell

@synthesize descriptionLabel = _descriptionLabel;
@synthesize latLongLabel = _latLongLabel;
@synthesize thumbnailImageView = _thumbnailImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
