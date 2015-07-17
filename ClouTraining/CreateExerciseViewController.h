//
//  CreateExerciseViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateExerciseViewController : UIViewController< UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descField;
@property (weak, nonatomic) IBOutlet UITextField *maxWeightField;
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;

@property Exercise *exercise;


- (IBAction)onlineSwitchChanged:(id)sender;

@end
