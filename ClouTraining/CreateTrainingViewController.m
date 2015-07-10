//
//  CreateTrainingViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateTrainingViewController.h"
#import "CreateTrainingTableViewCell.h"
#import "Exercise.h"
#import "Training.h"

@interface CreateTrainingViewController ()

@end

@implementation CreateTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_table registerNib:[UINib nibWithNibName:@"CreateTrainingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateTrainingTableViewCell"];
    _exercises = [NSMutableArray array];
    _addedExercises = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exerciseAdded:) name:@"ExerciseAdded" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_training){
        _exercises = [[DataController sharedInstance]getExercisesForTraining:_training].mutableCopy;
        _nameField.text = _training.name;
        _descField.text = _training.describe;
        _trainingSwitch.on = YES;
        _onlineSwitch.on = _training.publicate.boolValue;
    }
    [_table reloadData];
}

-(void)exerciseAdded:(NSNotification*)note{
    NSDictionary *e = (NSDictionary*)note.object;
    [_addedExercises addObject:e];
}

#pragma mark - saving

-(void)saveTraining{
    if(!_training){
        [self createTraining];
        
    }else{
        [[DataController sharedInstance]updateTraining:_training withData:@{@"name":_nameField.text,
                                                                            @"describe":_descField.text,
                                                                            @"publicate":[NSNumber numberWithBool:_onlineSwitch.on],
                                                                            }];
        _training.name = _nameField.text;
        _training.describe = _descField.text;
        for(NSDictionary *d in _addedExercises){
            Exercise *e = [[DataController sharedInstance]createReturnExerciseWithData:d forTraining:_training];
            if(e){
                NSArray *sets = [d objectForKey:@"sets"];
                [[DataController sharedInstance]createSets:sets forExercise:e];
            }
        }
    }
}

-(void)createTraining{
    _training = [[DataController sharedInstance]createTrainingWithData:@{@"name":_nameField.text,
                                                                         @"describe":_descField.text,
                                                                         @"publicate":[NSNumber numberWithBool:_onlineSwitch.on],
                                                                         @"own":[NSNumber numberWithBool:YES]
                                                                         }];
    if(_training){
        for(NSDictionary *d in _addedExercises){
            Exercise *e = [[DataController sharedInstance]createReturnExerciseWithData:d forTraining:_training];
            if(e){
                NSArray *sets = [d objectForKey:@"sets"];
                [[DataController sharedInstance]createSets:sets forExercise:e];
                
            }
        }
    }
}

#pragma mark - tableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(_training){
        if(section == 0){
            return @"Neue Übungen";
        }
        if(section == 1){
            return @"Alte Übungen";
        }
    }
    return @"Übungen";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_training){
        if(section == 0){
            return _addedExercises.count;
        }
        if(section == 1){
            return _exercises.count;
        }
    }
    return _addedExercises.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_training){
        return 2;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"CreateTrainingTableViewCell";
    CreateTrainingTableViewCell *cell = (CreateTrainingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CreateTrainingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(_training){
        if(section == 0){
            cell.titleLabel.text = [(NSDictionary*)[_addedExercises objectAtIndex:row]objectForKey:@"name"];
        }
        if(section == 1){
            cell.titleLabel.text = [(Exercise*)[_exercises objectAtIndex:row]name];
            NSLog(@"Name:%@ - Sets:%zd",[(Exercise*)[_exercises objectAtIndex:row]name],[(Exercise*)[_exercises objectAtIndex:row]sets].count);
        }
    }else{
        cell.titleLabel.text = [(NSDictionary*)[_addedExercises objectAtIndex:row]objectForKey:@"name"];
    }
    
    
    
    
    return cell;
}

#pragma mark - textField/View

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)dismissCreation:(id)sender{
    UIBarButtonItem *bbi = (UIBarButtonItem*)sender;
    if(bbi.tag == 11){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if(bbi.tag == 22){
        [self saveTraining];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)trainingSwitchChanged:(id)sender {
    
}

- (IBAction)onlineSwitchChanged:(id)sender {
    if(_training)_training.publicate = [NSNumber numberWithBool:_onlineSwitch.on];
}
@end
