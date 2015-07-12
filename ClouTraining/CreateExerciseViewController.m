//
//  CreateExerciseViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateExerciseViewController.h"

@interface CreateExerciseViewController ()

@end

@implementation CreateExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarController.navigationItem.title = @"Übung erstellen";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Speichern" style:UIBarButtonItemStylePlain target:self action:@selector(saveExercise)];
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

        
        NSDictionary *data = @{@"name":_nameField.text,
                               @"describe":_descField.text,
                               @"shared":[NSNumber numberWithBool:_onlineSwitch.on]};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ExerciseAdded" object:data];
        
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
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
