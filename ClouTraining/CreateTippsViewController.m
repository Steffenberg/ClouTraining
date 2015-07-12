//
//  CreateTippsPageViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateTippsViewController.h"

@interface CreateTippsViewController ()

@end

@implementation CreateTippsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createVideo:(id)sender {
    
        _picker = [[UIImagePickerController alloc]init];
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.videoMaximumDuration = 120;
        _picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        _picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        _picker.delegate = self;
        [self presentViewController:_picker animated:YES completion:^(void){
            
        }];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        NSLog(@"Image Captured");
    
         [info objectForKey:UIImagePickerControllerOriginalImage];
        
         [_picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    else if ([mediaType isEqualToString:@"public.movie"]){
        
        NSLog(@"Video Captured");
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoLargeData = [NSData dataWithContentsOfURL:videoURL];
        
        NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], @"vid.mp4"];
        NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
        
        [self convertVideoToLowQuailtyWithInputURL:videoURL outputURL:fileURL handler:^(AVAssetExportSession *exportSession)
         {
             if (exportSession.status == AVAssetExportSessionStatusCompleted)
             {
                 NSLog(@"completed");
                 //WICHTIG!!! QUELLVIEDEO LÖSCHEN!!!
                 
                 _videoData = [NSData dataWithContentsOfURL:fileURL];
                 
                 NSLog(@"Filesize - before: %f \nafter: %f", videoLargeData.length/1000.0f, _videoData.length/1000.0f);
             }
             else
             {
                 NSLog(@"error");
                 
             }
             
             [_picker dismissViewControllerAnimated:YES completion:nil];
         }];
        
        
    }
    
    
    
}

- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(ExportCallback)handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    NSLog(@"Expected length:%zd",exportSession.estimatedOutputFileLength);
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
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
    _picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    _picker.delegate = self;
    [self presentViewController:_picker animated:YES completion:^(void){
        
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



- (IBAction)createText:(id)sender {
}
@end
