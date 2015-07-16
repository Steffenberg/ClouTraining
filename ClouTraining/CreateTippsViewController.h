//
//  CreateTippsPageViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


typedef void (^ExportCallback) (AVAssetExportSession*);



@interface CreateTippsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property Exercise *exercise;
@property UIImagePickerController *picker;
@property UIActionSheet *sheet;


@property (strong) NSData *uploadData;
@property (strong) NSArray *images;

- (IBAction)createVideo:(id)sender;
- (IBAction)createImage:(id)sender;
- (IBAction)createText:(id)sender;


@end
