//
//  CreateTrainingViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Training;

@interface CreateTrainingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descField;
@property (weak, nonatomic) IBOutlet UISwitch *trainingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;

@property Training *training;
@property NSArray *exercises;
@property NSMutableArray *addedExercises;
@property NSMutableArray *chosenExercises;

- (IBAction)trainingSwitchChanged:(id)sender;
- (IBAction)onlineSwitchChanged:(id)sender;
-(BOOL)hasExercise:(Exercise*)exercise;

@end
