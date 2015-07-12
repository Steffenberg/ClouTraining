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



@interface CreateTippsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property Exercise *exercise;
@property UIImagePickerController *picker;

@property (strong) NSData *videoData;
@property (strong) NSArray *images;

- (IBAction)createVideo:(id)sender;
- (IBAction)createImage:(id)sender;
- (IBAction)createText:(id)sender;


@end
