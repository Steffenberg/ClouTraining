//
//  MainMenuViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataController sharedInstance]createTrainingWithName:@"Bankdrücken" andDescription:@""];
    [[DataController sharedInstance]createTrainingWithName:@"Bizeps Curls" andDescription:@""];
    [[DataController sharedInstance]createTrainingWithName:@"Rudern" andDescription:@""];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showChooseTraining:(id)sender{
    [self performSegueWithIdentifier:@"ShowTrainingChooser" sender:self];
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
