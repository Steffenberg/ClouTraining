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

@interface CreateTippsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicUploadButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property Exercise *exercise;
@property UIImagePickerController *picker;
@property UIActionSheet *sheet;
@property NSInteger type;

@property (strong) NSData *uploadData;
@property UIImage *thumbnail;
@property NSString *mediaTitle;
//@property (strong) NSArray *images;

- (IBAction)createVideo:(id)sender;
- (IBAction)createImage:(id)sender;
- (IBAction)createText:(id)sender;
- (IBAction)closeThumbnailView:(id)sender;


@end
