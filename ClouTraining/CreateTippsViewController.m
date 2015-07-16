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
        
        _uploadData = UIImagePNGRepresentation(img);
        if(_uploadData){
            [self showActionSheetWithType:2];
        }
        
        
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
            if(_uploadData){
                [self showActionSheetWithType:1];
            }
        }];
        
    }
    
    else if ([mediaType isEqualToString:@"public.movie"]){
        
        NSLog(@"Video Captured");
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
            
            
            
            _uploadData = [NSData dataWithContentsOfURL:videoURL];
            
            NSLog(@"Filesize - %f ", _uploadData.length/1000.0f);
            
            //WICHTIG!!! QUELLVIEDEOS LÖSCHEN!!!
            [[NSFileManager defaultManager] removeItemAtPath:[videoURL path] error:nil];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(_uploadData){
                    [self showActionSheetWithType:1];
                }
            });
            
        }];
        
    }
    
}

- (void)convertVideoToLowerQuailtyWithInputURL:(NSURL*)inputURL
                                     outputURL:(NSURL*)outputURL
                                       handler:(ExportCallback)handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset640x480];
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



- (IBAction)createText:(id)sender {
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

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSDictionary *data = @{@"exerciseID":_exercise.exerciseid,
                               @"title":@"Titel einfuegen",
                               @"type":[NSNumber numberWithInteger:actionSheet.tag],
                               @"date":[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
                               };
        
        [[Communicator sharedInstance]reuqestMediaInfoWithData:data andMedia:_uploadData];
        return;
    }
}



@end
