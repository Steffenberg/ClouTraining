//
//  ManageTrainingViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ManageTrainingsViewController.h"
#import "ManageTrainingsTableViewCell.h"
#import "Training.h"
#import "CreateTrainingViewController.h"

@interface ManageTrainingsViewController ()

@end

@implementation ManageTrainingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_table registerNib:[UINib nibWithNibName:@"ManageTrainingsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ManageTrainingsTableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _chosenTraining = nil;
    _trainings = [[DataController sharedInstance]getAllTrainings];
    [_table reloadData];
}


#pragma mark - tableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _trainings.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"ManageTrainingsTableViewCell";
    ManageTrainingsTableViewCell *cell = (ManageTrainingsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ManageTrainingsTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.TitleLabel.text = [(Training*)[_trainings objectAtIndex:row]name];
    cell.editButton.tag = row;
    cell.deleteButton.tag = row;
    
    [cell.editButton setImage:[UIImage imageNamed:@"documents"] forState:UIControlStateNormal];
    [cell.deleteButton setImage:[UIImage imageNamed:@"mini2"] forState:UIControlStateNormal];
    
    [cell.editButton addTarget:self action:@selector(loadEditTraining:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteTraining:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}


#pragma mark - buttonTargets

-(void)loadEditTraining:(UIButton*)button{
    _chosenTraining = [_trainings objectAtIndex:button.tag];
    [self performSegueWithIdentifier:@"ShowEditTraining" sender:self];
}

-(void)deleteTraining:(UIButton*)button{
    [[DataController sharedInstance]deleteTraining:[_trainings objectAtIndex:button.tag]];
    _trainings = [[DataController sharedInstance]getAllTrainings];
    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowEditTraining"]){
        if(_chosenTraining){
            CreateTrainingViewController *ctvc = (CreateTrainingViewController*)[[segue.destinationViewController viewControllers]objectAtIndex:0];
            ctvc.training = _chosenTraining;
        }
    }
}


@end
