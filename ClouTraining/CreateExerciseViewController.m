//
//  CreateExerciseViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateExerciseViewController.h"
#import "Exercise.h"
#import "Training.h"
#import "CreateExerciseTabBarController.h"

@interface CreateExerciseViewController ()

@end

@implementation CreateExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(_exercise){
         self.navigationItem.title = @"Übung bearbeiten";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Speichern" style:UIBarButtonItemStylePlain target:self action:@selector(saveExercise)];
        _nameField.text = _exercise.name;
        _descField.text = _exercise.describe;
        _onlineSwitch.on = _exercise.shared.boolValue;
        _maxWeightField.text = [NSString stringWithFormat:@"%@",_exercise.maxWeight];
    }else{
        if(self.tabBarController){
            self.tabBarController.navigationItem.title = @"Übung erstellen";
            self.tabBarController.navigationItem.title = @"Übung erstellen";
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Speichern" style:UIBarButtonItemStylePlain target:self action:@selector(saveExercise)];
        }else{
            self.navigationItem.title = @"Übung erstellen";
            self.navigationItem.title = @"Übung erstellen";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Speichern" style:UIBarButtonItemStylePlain target:self action:@selector(saveExercise)];
        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveExercise{
    if(!_exercise){
        if(self.tabBarController){
            CreateExerciseTabBarController *tabControl = (CreateExerciseTabBarController*)self.tabBarController;
            if (tabControl.exercisesToAdd.count + tabControl.training.exercises.count < 16) {
                NSDictionary *data = @{@"name":_nameField.text,
                                       @"describe":_descField.text,
                                       @"shared":[NSNumber numberWithBool:_onlineSwitch.on],
                                       @"maxWeight":[NSNumber numberWithFloat:[_maxWeightField.text floatValue]],
                                       @"own":[NSNumber numberWithBool:YES],
                                       @"date":[NSDate date]
                                       };
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ExerciseAdded" object:data];
                
                [self.tabBarController.navigationController popViewControllerAnimated:YES];
            }else{
                [[ErrorHandler sharedInstance]handleSimpleError:@"Achtung" andMessage:@"Dein Training darf aus maximal 16 Übungen bestehen."];
            }
            
        }else{
            NSDictionary *data = @{@"name":_nameField.text,
                                   @"describe":_descField.text,
                                   @"shared":[NSNumber numberWithBool:_onlineSwitch.on],
                                   @"maxWeight":[NSNumber numberWithFloat:[_maxWeightField.text floatValue]],
                                   @"own":[NSNumber numberWithBool:YES],
                                   @"date":[NSDate date]
                                   };
            
            Exercise *e = [[DataController sharedInstance]createReturnExerciseWithData:data];
            
            if(e.shared.boolValue){
                [[Communicator sharedInstance] sendExerciseToServer:e];
            }
                
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
       
    }else{
        [_exercise setName:_nameField.text];
        [_exercise setDescribe:_descField.text];
        [_exercise setShared:[NSNumber numberWithBool:_onlineSwitch.on]];
        [_exercise setMaxWeight:[NSNumber numberWithFloat:[_maxWeightField.text floatValue]]];
        [[DataController sharedInstance] updateExercise:_exercise];
        
        
        if(_exercise.shared.boolValue){
            [[Communicator sharedInstance] sendExerciseToServer:_exercise];
        }else{
            [[Communicator sharedInstance]setShared:_exercise.shared.boolValue forExercise:_exercise];
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    

}


#pragma mark - textField/View

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onlineSwitchChanged:(id)sender {
    
}



#pragma mark - keyboard

/*- (void)observeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopObservingKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)n
{
    CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //_bottomConstraint.constant += keyboardFrame.size.height;
    [self.view setNeedsUpdateConstraints];
    
    
    [UIView animateWithDuration:[n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //_bottomConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:[n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}*/
@end
