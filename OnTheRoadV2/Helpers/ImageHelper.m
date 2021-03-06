//
//  ImageHelper.m
//  OnTheRoadV2
//
//  Created by Irineu Licks Filho on 07/12/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (ImageHelper*)sharedInstance
{
    static ImageHelper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ImageHelper alloc] init];
    });
    return _sharedInstance;
}

- (NSString *) getUniqueIdentifier
{
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    
    return (__bridge NSString *)(uuidStr);
}

//saving an image
- (NSString*)saveImageAndReturnPath:(UIImage*)image {
    
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self getUniqueIdentifier]]];
    
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    
    NSLog(@"image saved");
    
    return fullPath;
    
}

// user generated images are stored in the documents directory
-(UIImage *) loadImageFromDocumentsDirectory:(NSString *)imageUrl
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imageUrl];
    
    return image;
}

- (UIImage *)thumbnailOfSize:(CGSize)size: (UIImage*) image {
    //if( self.previewThumbnail )
    //	return self.previewThumbnail; // returned cached thumbnail
    
    UIGraphicsBeginImageContext(size);
    
    // draw scaled image into thumbnail context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    // pop the context
    UIGraphicsEndImageContext();
    
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    
    //self.previewThumbnail = newThumbnail;
    
    return newThumbnail;
    //return self.previewThumbnail;
}

@end
