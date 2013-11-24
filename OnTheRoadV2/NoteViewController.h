//
//  NoteViewController.h
//  OnTheRoadV2
//
//  Created by Irineu Licks on 28/09/13.
//  Copyright (c) 2013 On The Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteService.h"

@interface NoteViewController : UIViewController{
    NoteService *noteService;
}
@property (weak, nonatomic) IBOutlet UIButton *btSave;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (nonatomic) NSManagedObjectID *idCurrentTrip;
@property (nonatomic) NSManagedObjectID *idCurrentPin;

@end
