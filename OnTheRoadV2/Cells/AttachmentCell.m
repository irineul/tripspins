//
//  AttachmentCell.m
//  OnTheRoadV2
//
//  Created by Irineu Licks on 23/11/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "AttachmentCell.h"

@implementation AttachmentCell
@synthesize lblAttachText = _lblAttachText;
@synthesize lblDateTime = _lblDateTime;

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
