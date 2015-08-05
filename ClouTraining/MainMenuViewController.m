//
//  MainMenuViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainMenuButton.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_trainingButton setImage:[UIImage imageNamed:@"standingMan@3x"] forState:UIControlStateNormal];
    [_editTrainingButton setImage:[UIImage imageNamed:@"screwdriver3@3x"] forState:UIControlStateNormal];
    [_editExerciseButton setImage:[UIImage imageNamed:@"screwdriver3@3x"] forState:UIControlStateNormal];
    [_createTippsButton setImage:[UIImage imageNamed:@"question3@3x"] forState:UIControlStateNormal];
    [_settingsButton setImage:[UIImage imageNamed:@"little17@3x"] forState:UIControlStateNormal];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showChooseTraining:(id)sender{
    [self performSegueWithIdentifier:@"ShowTrainingChooser" sender:self];
}

-(IBAction)showCreateTraining:(id)sender{
    [self performSegueWithIdentifier:@"ShowManageTrainings" sender:self];
}


-(IBAction)showManageExercises:(id)sender{
    [self performSegueWithIdentifier:@"ShowManageExercises" sender:self];
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
