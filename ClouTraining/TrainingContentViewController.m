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
    
    if(_exercise && _training && _tProtocol){
        
        _titleLabel.text = _exercise.name;
        _exProtocol = [[DataController sharedInstance]createExProtocolForTrainingProtocol:_tProtocol andExercise:_exercise];
        
        _setLogs = [[DataController sharedInstance]getSetEntriesForExProtocol:_exProtocol].mutableCopy;
        [_table reloadData];
        complete(YES);
    }else{
        complete(NO);
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Satz: %zd", section+1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _setLogs.count;
    //return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"TrainingContentTableViewCell";
    TrainingContentTableViewCell *cell = (TrainingContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.weightLabel.text = [NSString stringWithFormat:@"%.02f KG", cell.weightSlider.value];
    cell.repLabel.text = [NSString stringWithFormat:@"WDH: %.0f",cell.repSlider.value];
    cell.weightSlider.maximumValue = _exercise.maxWeight.floatValue;
    //CGFloat weight = _exercise.weight.integerValue/1000.0f;
    //cell.weightLabel.text = [NSString stringWithFormat:@"%.2f KG", weight];
    
    
    
    return cell;
}

- (IBAction)addSet:(id)sender {
    SetEntry *entry = [[DataController sharedInstance]createSetEntryForExProtocol:_exProtocol withNumber:_setLogs.count+1];
    [_setLogs addObject:entry];
    [_table reloadData];
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
