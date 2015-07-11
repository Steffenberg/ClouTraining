//
//  CreateExerciseViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateExerciseViewController.h"
#import "CreateExerciseTableViewCell.h"

@interface CreateExerciseViewController ()

@end

@implementation CreateExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table registerNib:[UINib nibWithNibName:@"CreateExerciseTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateExerciseTableViewCell"];
    _sets = [NSMutableArray array];
    
    self.tabBarController.navigationItem.title = @"Übung erstellen";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Speichern" style:UIBarButtonItemStylePlain target:self action:@selector(saveExercise)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self observeKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopObservingKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveExercise{
    if(!_exercise){
        for(int i = 0; i<[_table numberOfSections]; i++){
            CreateExerciseTableViewCell *cell = (CreateExerciseTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            [_sets replaceObjectAtIndex:i withObject:@{@"weight":[NSNumber numberWithFloat:cell.weightField.text.floatValue],
                                                       @"repititions":[NSNumber numberWithInteger:cell.repField.text.integerValue]}];
        }
        
        NSDictionary *data = @{@"name":_nameField.text,
                               @"describe":_descField.text,
                               @"shared":[NSNumber numberWithBool:_onlineSwitch.on],
                               @"sets":_sets};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ExerciseAdded" object:data];
        
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
    
    

}

#pragma mark - tableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Satz %zd", section+1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sets.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"CreateExerciseTableViewCell";
    CreateExerciseTableViewCell *cell = (CreateExerciseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CreateExerciseTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.repField.text = [NSString stringWithFormat:@"%zd", [[(NSDictionary*)[_sets objectAtIndex:section]objectForKey:@"repititions"]integerValue]];
    cell.weightField.text = [NSString stringWithFormat:@"%.2f", [[(NSDictionary*)[_sets objectAtIndex:section]objectForKey:@"weight"]floatValue]];
    
    
    return cell;
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

- (IBAction)addSet:(id)sender {
    for(int i = 0; i<[_table numberOfSections]; i++){
        CreateExerciseTableViewCell *cell = (CreateExerciseTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [_sets replaceObjectAtIndex:i withObject:@{@"weight":[NSNumber numberWithFloat:cell.weightField.text.floatValue],
                                                   @"repititions":[NSNumber numberWithInteger:cell.repField.text.integerValue]}];
    }
    
    [_sets addObject:@{@"weight":[NSNumber numberWithFloat:0.0f],
                       @"repititions":[NSNumber numberWithInteger:0]}];
    [_table reloadData];
}


#pragma mark - keyboard

- (void)observeKeyboardNotifications
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
    
    _bottomConstraint.constant += keyboardFrame.size.height;
    [self.view setNeedsUpdateConstraints];
    
    
    [UIView animateWithDuration:[n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _bottomConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:[n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
