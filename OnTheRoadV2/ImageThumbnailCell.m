//
//  ImageThumbnailCell.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 21/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "ImageThumbnailCell.h"

@implementation ImageThumbnailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont boldSystemFontOfSize:35.0];
        self.label.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.label];;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
