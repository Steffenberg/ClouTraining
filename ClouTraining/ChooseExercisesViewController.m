//
//  ChooseExercisesViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ChooseExercisesViewController.h"
#import "CreateExerciseTabBarController.h"
#import "CreateTrainingTableViewCell.h"
#import "Exercise.h"
#import "Training.h"

@interface ChooseExercisesViewController ()

@end

@implementation ChooseExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_table registerNib:[UINib nibWithNibName:@"CreateTrainingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateTrainingTableViewCell"];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_training){
        _exercises = [[DataController sharedInstance]getAllExercisesNotInTraining:_training];
        _trainingExercises = [[DataController sharedInstance]getExercisesForTraining:_training];
    }else{
        _exercises = [[DataController sharedInstance]getAllExercises];
        
        
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
            return @"Im Training vorhanden";
        }
        if(section == 1){
            return @"Wähle Übung";
        }
    }
    return @"Übungen";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_training){
        if(section == 0){
            return _trainingExercises.count;
        }
        if(section == 1){
            return _exercises.count;
        }
    }
    return _exercises.count;
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
            cell.titleLabel.text = [(Exercise*)[_trainingExercises objectAtIndex:row]name];
        }
        if(section == 1){
            cell.titleLabel.text = [(Exercise*)[_exercises objectAtIndex:row]name];
            
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.titleLabel.text = [(Exercise*)[_exercises objectAtIndex:row]name];
        
        CreateExerciseTabBarController *tabControl = (CreateExerciseTabBarController*)self.tabBarController;
        if ([tabControl hasExercise:[_exercises objectAtIndex:row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_training){
        if(indexPath.section == 0){
            [[DataController sharedInstance]removeExercise:[_trainingExercises objectAtIndex:indexPath.row] fromTraining:_training];
            
            _exercises = [[DataController sharedInstance]getAllExercisesNotInTraining:_training];
            _trainingExercises = [[DataController sharedInstance]getExercisesForTraining:_training];
            
            [tableView reloadData];
            
        }
        if(indexPath.section == 1){
            [[DataController sharedInstance]addExercise:[_exercises objectAtIndex:indexPath.row] toTraining:_training];
            _exercises = [[DataController sharedInstance]getAllExercisesNotInTraining:_training];
            _trainingExercises = [[DataController sharedInstance]getExercisesForTraining:_training];
            
            
            [tableView reloadData];
            
            
        }
    }else{
        CreateExerciseTabBarController *tabControl = (CreateExerciseTabBarController*)self.tabBarController;
        if ([tabControl hasExercise:[_exercises objectAtIndex:indexPath.row]]) {
            [tabControl.exercisesToAdd removeObject:[_exercises objectAtIndex:indexPath.row]];
        }else{
            [tabControl.exercisesToAdd addObject:[_exercises objectAtIndex:indexPath.row]];
        }
        [tableView reloadData];
        
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

@end
