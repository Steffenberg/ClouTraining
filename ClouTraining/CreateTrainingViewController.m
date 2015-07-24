//
//  CreateTrainingViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateTrainingViewController.h"
#import "CreateTrainingTableViewCell.h"
#import "CreateExerciseTabBarController.h"
#import "Exercise.h"
#import "Training.h"

@interface CreateTrainingViewController ()

@end

@implementation CreateTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    _exercises = [NSMutableArray array];
    _addedExercises = [NSMutableArray array];
    _chosenExercises = [NSMutableArray array];
    
    _descField.layer.borderWidth = 0.5f;
    _descField.layer.cornerRadius = 5.0f;
    _descField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exerciseAdded:) name:@"ExerciseAdded" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exercisesChosen:) name:@"ExercisesChosen" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_training){
        _exercises = [[DataController sharedInstance]getExercisesForTraining:_training].mutableCopy;
        _nameField.text = _training.name;
        _descField.text = _training.describe;
        _trainingSwitch.on = YES;
    }
    [_table reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_nameField resignFirstResponder];
    [_descField resignFirstResponder];
}

-(void)exerciseAdded:(NSNotification*)note{
    NSDictionary *e = (NSDictionary*)note.object;
    [_addedExercises addObject:e];
}

-(void)exercisesChosen:(NSNotification*)note{
    if(!_training){
        [_chosenExercises addObjectsFromArray:(NSArray*)note.object];
    }
    
}

#pragma mark - saving

-(void)saveTraining{
    if(!_training){
        [self createTraining];
        
    }else{
        [[DataController sharedInstance]updateTraining:_training withData:@{@"name":_nameField.text,
                                                                            @"describe":_descField.text,
                                                                            @"publicate":[NSNumber numberWithBool:_onlineSwitch.on]
                                                                            }];
        _training.name = _nameField.text;
        _training.describe = _descField.text;
        for(NSDictionary *d in _addedExercises){
            [[DataController sharedInstance]createExerciseWithData:d forTraining:_training];
            
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
            [[DataController sharedInstance]createExerciseWithData:d forTraining:_training];
            
        }
        for(Exercise *e in _chosenExercises){
            [[DataController sharedInstance]addExercise:e toTraining:_training];
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
    }else{
        if(section == 0){
            return @"Erstellte Übungen";
        }
        if(section == 1){
            return @"Bestehende Übungen";
        }
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_training){
        if(section == 0){
            return _addedExercises.count;
        }
        if(section == 1){
            return _exercises.count;
        }
    }else{
        if(section == 0){
            return _addedExercises.count;
        }
        if(section == 1){
            return _chosenExercises.count;
        }
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
            
        }
    }else{
        if(section == 0){
            cell.titleLabel.text = [(NSDictionary*)[_addedExercises objectAtIndex:row]objectForKey:@"name"];
        }
        if(section == 1){
            cell.titleLabel.text = [(Exercise*)[_chosenExercises objectAtIndex:row]name];
        }
        
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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"ShowEditExercises"]){
         CreateExerciseTabBarController *tabControl = (CreateExerciseTabBarController*)segue.destinationViewController;
         tabControl.training = _training;
         for(UIViewController *ctrl in tabControl.viewControllers){
             if([ctrl respondsToSelector:@selector(setTraining:)]){
                 [ctrl performSelector:@selector(setTraining:) withObject:_training];
             }
         }
     }
 }
 

- (IBAction)trainingSwitchChanged:(id)sender {
    
}


@end
