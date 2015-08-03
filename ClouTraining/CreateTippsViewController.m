//
//  CreateTippsPageViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateTippsViewController.h"
#import "Exercise.h"

@interface CreateTippsViewController ()

@end

@implementation CreateTippsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_closeButton setImage:[ImageConverter maskImage:_closeButton.imageView.image withColor:[UIColor redColor]] forState:UIControlStateNormal];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapReturn)];
    [_previewView addGestureRecognizer:tap];
    
    [_uploadButton setTintColor:[UIColor whiteColor]];
    [_uploadButton setImage:[ImageConverter maskImage:[UIImage imageNamed:@"small74@2x"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_dynamicUploadButton setTintColor:[UIColor whiteColor]];
    [_dynamicUploadButton setImage:[ImageConverter maskImage:[UIImage imageNamed:@"small74@2x"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    self.navigationItem.title = _exercise.name;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleUploadRecall:) name:@"MediaUploadRecall" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handleUploadRecall:(NSNotification*)note{
    if(!note.object){
        [self showThumbnailView:NO];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"Fehler" message:@"Hochladen fehlgeschlagen" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alerView show];
        });
        
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)showThumbnailView:(BOOL)show{
    if(show){
        [self.view bringSubviewToFront:_previewView];
        [UIView animateWithDuration:0.4 animations:^{
            _previewView.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            _previewView.alpha = 0.0;
        } completion:^(BOOL finished){
            [self.view sendSubviewToBack:_previewView];
            _thumbnailView.image = nil;
            _thumbnailView.hidden = NO;
            _textView.text =@"";
            _textView.hidden = YES;
            _titleField.text = @"";
            _mediaTitle = nil;
            _thumbnail = nil;
            _uploadData = nil;
        }];
    }
}

-(IBAction)uploadConfirm:(id)sender{
    _mediaTitle = _titleField.text;
    if([sender isEqual:_dynamicUploadButton]){
        [_textView resignFirstResponder];
        
        
    }
    if(_textView.hidden){
        [self showActionSheetWithType:_type];
    }else{
        if(![_textView.text isEqualToString:@""]){
            [[Communicator sharedInstance]sendText:_textView.text withTitle:_mediaTitle forExercise:_exercise completition:^(BOOL complete){
                [[LoadingView sharedInstance]hide];
                if(complete){
                    [self showThumbnailView:NO];
                }
            }];
            
        }
    }
    
}

- (IBAction)createVideo:(id)sender {
    
    _picker = [[UIImagePickerController alloc]init];
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.videoMaximumDuration = 120;
    _picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    _picker.videoQuality = UIImagePickerControllerQualityType640x480;
    _picker.delegate = self;
    [self.navigationController presentViewController:_picker animated:YES completion:^(void){
        
    }];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        NSLog(@"Image Captured");
        
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
            
            CGSize compressedSize = CGSizeMake(img.size.width/6, img.size.height/6);
            UIImage *compressImage = [self imageWithImage:img scaledToSize:compressedSize];
            
            //_uploadData = UIImagePNGRepresentation(compressImage);
            _uploadData = UIImageJPEGRepresentation(compressImage, 1.0f);
            
            _type = 2;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(_uploadData){
                    _thumbnailView.image = compressImage;
                    //[self showActionSheetWithType:2];
                    [self showThumbnailView:YES];
                }
            });
            
        }];
        
    }else if ([mediaType isEqualToString:@"public.movie"]){
        
        NSLog(@"Video Captured");
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSURL *tempURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mp4"]];
        
        [self convertVideoToLowerQuailtyWithInputURL:videoURL outputURL:tempURL handler:^(AVAssetExportSession *e){
            [picker.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
                
                _thumbnail = [self getThumbnailForVideo:tempURL];
                _thumbnailView.image = _thumbnail;
                _type = 1;
                _uploadData = [NSData dataWithContentsOfURL:tempURL];
                
                NSLog(@"Filesize - %f ", _uploadData.length/1000.0f);
                
                //WICHTIG!!! QUELLVIEDEOS LÖSCHEN!!!
                [[NSFileManager defaultManager] removeItemAtPath:[tempURL path] error:nil];
                
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if(_uploadData){
                        [self showThumbnailView:YES];
                        
                        //[self showActionSheetWithType:1];
                    }
                });
                
            }];
        }];
        
        /*[picker.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
            
            _thumbnail = [self getThumbnailForVideo:videoURL];
            _thumbnailView.image = _thumbnail;
            _type = 1;
            _uploadData = [NSData dataWithContentsOfURL:videoURL];
            
            NSLog(@"Filesize - %f ", _uploadData.length/1000.0f);
            
            //WICHTIG!!! QUELLVIEDEOS LÖSCHEN!!!
            [[NSFileManager defaultManager] removeItemAtPath:[videoURL path] error:nil];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(_uploadData){
                    [self showThumbnailView:YES];

                    //[self showActionSheetWithType:1];
                }
            });
            
        }];*/
        
    }
    
}

- (void)convertVideoToLowerQuailtyWithInputURL:(NSURL*)inputURL
                                     outputURL:(NSURL*)outputURL
                                       handler:(ExportCallback)handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
   
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         [[NSFileManager defaultManager] removeItemAtURL:inputURL error:nil];
         handler(exportSession);
         
     }];
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Capture Canceled");
}

- (IBAction)createImage:(id)sender {
    _picker = [[UIImagePickerController alloc]init];
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    _picker.delegate = self;
    [self.navigationController presentViewController:_picker animated:YES completion:^(void){
        
    }];
    
    /*if(!_imagePicker){
     _imagePicker = [[ELCImagePickerController alloc] initImagePicker];
     _imagePicker.maximumImagesCount = 4; //Set the maximum number of images to select, defaults to 4
     _imagePicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
     _imagePicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
     _imagePicker.onOrder = YES; //For multiple image selection, display and return selected order of images
     _imagePicker.imagePickerDelegate = self;
     }*/
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)getThumbnailForVideo:(NSURL*)vidPath{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

- (IBAction)createText:(id)sender {
    [self showThumbnailView:YES];
    _textView.hidden = NO;
    _thumbnailView.hidden = YES;
    
}

- (IBAction)closeThumbnailView:(id)sender {
    [self showThumbnailView:NO];
}

-(void)showActionSheetWithType:(NSInteger)type{
    if(type == 1){
        _sheet = [[UIActionSheet alloc]initWithTitle:@"Video Hochladen" delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Hochladen" otherButtonTitles:nil];
    }
    if(type == 2){
        _sheet = [[UIActionSheet alloc]initWithTitle:@"Bild Hochladen" delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Hochladen" otherButtonTitles:nil];
    }
    
    _sheet.tag = type;
    
    [_sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex == 0){
        if(!_mediaTitle) {
            _mediaTitle = @"Kein Titel";
            _titleField.text = _mediaTitle;
        }
        NSDictionary *data = @{@"username":[GlobalHelperClass getUsername],
                               @"password":[GlobalHelperClass getPassword],
                               @"exerciseID":_exercise.exerciseid,
                               @"title":_mediaTitle,
                               @"type":[NSNumber numberWithInteger:actionSheet.tag],
                               @"date":[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
                               };
        
        [[Communicator sharedInstance]reuqestMediaInfoWithData:data andMedia:_uploadData];
        
        return;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)tapReturn{
    [_textView resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextField *)textField{
    _dynamicUploadButton.hidden = NO;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    _dynamicUploadButton.hidden = YES;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]){
        
    }
    
    return YES;
}



@end
