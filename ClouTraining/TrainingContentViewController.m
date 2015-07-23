//
//  TrainingContentViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "TrainingContentViewController.h"
#import "TrainingContentTableViewCell.h"
#import "Training.h"
#import "TrainingProtocol.h"
#import "ExerciseProtocol.h"
#import "SetEntry.h"
#import "Exercise.h"

@interface TrainingContentViewController ()

@end

@implementation TrainingContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table registerNib:[UINib nibWithNibName:@"TrainingContentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TrainingContentTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadWithData:(NSDictionary*)data completition:(SetupComplete)complete{
    _exercise = [data objectForKey:@"Exercise"];
    _training = [data objectForKey:@"Training"];
    _tProtocol = [data objectForKey:@"TrainingProtocol"];
    _exProtocol = nil;
    _setLogs = nil;
    
    if(_exercise && _training && _tProtocol){
        
        _titleLabel.text = _exercise.name;
        _exProtocol = [[DataController sharedInstance]createExProtocolForTrainingProtocol:_tProtocol andExercise:_exercise];
        
        _setLogs = [[DataController sharedInstance]getSetEntriesForExProtocol:_exProtocol].mutableCopy;
        /*for(SetEntry *entry in _setLogs){
            NSLog(@"%zd: Weight: %.02f Reps: %zd", entry.setNumber.integerValue,entry.weight.floatValue, entry.repititions.integerValue);
        }*/
        
        [_table reloadData];
        complete(YES);
    }else{
        complete(NO);
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _setLogs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Satz: %zd", section+1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    static NSString *CellIdentifier = @"TrainingContentTableViewCell";
    TrainingContentTableViewCell *cell = (TrainingContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SetEntry *entry = [_setLogs objectAtIndex:section];
    float deci = entry.weight.floatValue - floorf(entry.weight.floatValue);
    NSInteger full = floor(entry.weight.floatValue);
    NSInteger reps = entry.repititions.integerValue;
    NSLog(@"%zd: Weight: %.02f Reps: %zd", entry.setNumber.integerValue,entry.weight.floatValue, entry.repititions.integerValue);
    
    if(_exercise.maxWeight.floatValue == 0.0f){
        cell.weightSlider.enabled = NO;
        cell.floatWeightSlider.enabled = NO;
    }
    
    cell.floatWeightSlider.value = deci;
    
    cell.weightSlider.maximumValue = floor(_exercise.maxWeight.floatValue);
    cell.weightSlider.value = full;
    
    cell.repSlider.value = reps;
    
    cell.repLabel.text = [NSString stringWithFormat:@"WDH: %zd", reps];
    cell.weightLabel.text = [NSString stringWithFormat:@"%zd.%.0f KG", full,deci*100.0f];
    
    cell.entry = entry;
    //CGFloat weight = _exercise.weight.integerValue/1000.0f;
    //cell.weightLabel.text = [NSString stringWithFormat:@"%.2f KG", weight];
    
    
    
    return cell;
}

- (IBAction)addSet:(id)sender {
    SetEntry *entry = [[DataController sharedInstance]createSetEntryForExProtocol:_exProtocol withNumber:_setLogs.count+1];
    [_setLogs addObject:entry];
    [_table reloadData];
    [_table setContentOffset:CGPointMake(0, _table.contentSize.height - _table.frame.size.height) animated:YES];
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
