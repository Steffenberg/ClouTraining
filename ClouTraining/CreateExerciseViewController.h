//
//  CreateExerciseViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateExerciseViewController : UIViewController<UITabBarDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descField;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;
@property NSMutableArray *sets;
@property Exercise *exercise;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

- (IBAction)onlineSwitchChanged:(id)sender;
- (IBAction)addSet:(id)sender;

@end
