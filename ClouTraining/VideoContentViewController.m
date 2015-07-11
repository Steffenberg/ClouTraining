//
//  VideoContentViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "VideoContentViewController.h"

@interface VideoContentViewController ()

@end

@implementation VideoContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loadCapture:(id)sender {
    if(!_picker){
        _picker = [[UIImagePickerController alloc]init];
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.videoMaximumDuration = 120;
        _picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        _picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        
        [self presentViewController:_picker animated:YES completion:^(void){
            
        }];
    }
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

@end
