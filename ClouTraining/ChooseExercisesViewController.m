//
//  ChooseExercisesViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ChooseExercisesViewController.h"
#import "CreateExerciseViewController.h"
#import "CreateExerciseTabBarController.h"
#import "CreateTrainingTableViewCell.h"
#import "Exercise.h"
#import "Training.h"
#import "CreateTrainingViewController.h"

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
        if(self.tabBarController){
             _exercises = [[DataController sharedInstance]getAllExercises];
        }else{
            _exercises = [[DataController sharedInstance]getAllOwnExercises];
           
        }
        
    }
    [_table reloadData];
   
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
        if(self.tabBarController){
            cell.titleLabel.text = [(Exercise*)[_exercises objectAtIndex:row]name];
            CreateTrainingViewController *ctvc = [self.navigationController.viewControllers objectAtIndex:0];
            //CreateExerciseTabBarController *tabControl = (CreateExerciseTabBarController*)self.tabBarController;
            if ([ctvc hasExercise:[_exercises objectAtIndex:row]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            cell.titleLabel.text = [(Exercise*)[_exercises objectAtIndex:row]name];
        }
        
    }
    
    
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tabBarController){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        Exercise *e = [_exercises objectAtIndex:indexPath.row];
        if(e.shared.boolValue){
            [[Communicator sharedInstance]deleteExercise:e completition:^(BOOL complete){
                if(complete){
                    [[DataController sharedInstance]deleteExercise:e];
                    _exercises = [[DataController sharedInstance]getAllOwnExercises];
                    [tableView reloadData]; // tell table to refresh now
                }else{
                    [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Löschen nicht möglich"];
                }
            }];
        }else{
            
            [[DataController sharedInstance]deleteExercise:e];
            _exercises = [[DataController sharedInstance]getAllOwnExercises];
            [tableView reloadData];
            [[Communicator sharedInstance]deleteExercise:e completition:^(BOOL complete){
                // tell table to refresh now
                 if(complete){
                     [[ErrorHandler sharedInstance]handleSimpleError:@"Erfolg" andMessage:@"Löschenauf Server erfolgreich"];
                 }else{
                     [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Löschen auf Server nicht möglich"];
                 }
            }];
        }
        
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateTrainingTableViewCell *cell = (CreateTrainingTableViewCell*)[_table cellForRowAtIndexPath:indexPath];
    if(_training){
        if (_training.exercises.count < 16) {
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
            [[ErrorHandler sharedInstance]handleSimpleError:@"Achtung" andMessage:@"Dein Training darf aus maximal 16 Übungen bestehen."];
        }
        
        
    }else{
        if(self.tabBarController){
            CreateExerciseTabBarController *tabControl = (CreateExerciseTabBarController*)self.tabBarController;
            CreateTrainingViewController *ctvc = [self.navigationController.viewControllers objectAtIndex:0];
            //CreateExerciseTabBarController *tabControl = (CreateExerciseTabBarController*)self.tabBarController;
            if ([ctvc hasExercise:[_exercises objectAtIndex:indexPath.row]]) {
                [ctvc.chosenExercises removeObject:[_exercises objectAtIndex:indexPath.row]];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }else{
                if (tabControl.exercisesToAdd.count < 16) {
                    
                    if ([tabControl hasExercise:[_exercises objectAtIndex:indexPath.row]]) {
                        [tabControl.exercisesToAdd removeObject:[_exercises objectAtIndex:indexPath.row]];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }else{
                        [tabControl.exercisesToAdd addObject:[_exercises objectAtIndex:indexPath.row]];
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    
                }else{
                    [[ErrorHandler sharedInstance]handleSimpleError:@"Achtung" andMessage:@"Dein Training darf aus maximal 16 Übungen bestehen."];
                }
            }
            
            
            
        }else{
            _chosenExercise = [_exercises objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"ShowEditExercise" sender:self];
        }
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowEditExercise"]){
        CreateExerciseViewController *cevc = (CreateExerciseViewController*)segue.destinationViewController;
        cevc.exercise = _chosenExercise;
        
    }else if([segue.identifier isEqualToString:@"ShowCreateExercise"]){
        
    }
}


@end
