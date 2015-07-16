//
//  ContentTabBarViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ContentTabBarViewController.h"
#import "ExerciseCircleView.h"
#import "TrainingContentViewController.h"

@interface ContentTabBarViewController ()

@end

@implementation ContentTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)reloadToExercise:(Exercise*)e ofTraining:(Training*)t hide:(BOOL)hide completition:(SetupComplete)setupComplete{
    if(!hide){
        _exercise = e;
        _training = t;
        TrainingContentViewController *tcvc = [self.viewControllers objectAtIndex:0];
        [tcvc reloadToExercise:e ofTraining:(Training*)t completition:^(BOOL complete){
            if(complete){
                [self setSelectedIndex:0];
                setupComplete(YES);
            }else{
                setupComplete(NO);
            }
        }];
   }else{
        _exercise = nil;
       setupComplete (YES);
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
