//
//  CreateExerciseTableViewCell.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateExerciseTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *repField;
@property NSMutableDictionary *data;

@end
