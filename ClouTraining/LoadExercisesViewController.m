//
//  LoadExercisesViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "LoadExercisesViewController.h"
#import "CreateTrainingTableViewCell.h"
#import "Exercise.h"

@interface LoadExercisesViewController ()

@end

@implementation LoadExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleExerciseUpdate:) name:@"SharedExercisesUpdate" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[Communicator sharedInstance]getSharedExercises];
}

-(void)handleExerciseUpdate:(NSNotification*)note{
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSDictionary *data = note.object;
        NSMutableArray *tmp = [NSMutableArray array];
        for(NSString *str in [data allKeys]){
            if(![[DataController sharedInstance]hasExerciseForID:[[data objectForKey:str]objectForKey:@"exerciseID"] own:NO]){
                 [tmp addObject:[data objectForKey:str]];
            }
           
        }
        _exercises = tmp;
        
        [_table reloadData];
    });
}


#pragma mark - tableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Übungen online";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _exercises.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
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
       cell.titleLabel.text = [(NSDictionary*)[_exercises objectAtIndex:row]objectForKey:@"name"];
    }else{
       cell.titleLabel.text = [(NSDictionary*)[_exercises objectAtIndex:row]objectForKey:@"name"];
        
    }
    
    
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tabBarController){
        return NO;
    }
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_training){
        
        NSDictionary * extData = [_exercises objectAtIndex:indexPath.row];
        
        
        if(![[DataController sharedInstance]hasExerciseForID:[extData objectForKey:@"exerciseID"] own:NO]){
            Exercise *e = [[DataController sharedInstance]createReturnExerciseWithExtData:extData];
            if(e){
                [[DataController sharedInstance]addExercise:e toTraining:_training];
            }
        }
        
        
        
        
    }else{
        NSDictionary * extData = [_exercises objectAtIndex:indexPath.row];
        
        [[DataController sharedInstance]createExerciseWithExtData:extData];
        
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
