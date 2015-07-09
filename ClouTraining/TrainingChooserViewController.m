//
//  TrainingChooserViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "TrainingChooserViewController.h"
#import "TrainingSelectionTableViewCell.h"
#import "TrainingViewController.h"
#import "Training.h"
#import "TrainingProtocol.h"

@interface TrainingChooserViewController ()

@end

@implementation TrainingChooserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table registerNib:[UINib nibWithNibName:@"TrainingSelectionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TrainingSelectionTableViewCell"];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _chosenTraining = nil;
    _chosenProtocol = nil;
    _recentProtocols = [[DataController sharedInstance]getRecentProtocols];
    _ownTrainings = [[DataController sharedInstance]getOwnTrainings];
    _foreignTrainings = [[DataController sharedInstance]getForeignTrainings];
    [_table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Kürzlich";
    }
    if(section == 1){
        return @"Eigene";
    }
    if (section == 2) {
        return @"Andere";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return _recentProtocols.count;
    }
    if(section == 1){
        return _ownTrainings.count;
    }
    if (section == 2) {
        return _foreignTrainings.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"TrainingSelectionTableViewCell";
    TrainingSelectionTableViewCell *cell = (TrainingSelectionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TrainingSelectionTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    if(section == 0){
        cell.titleLabel.text =[NSString stringWithFormat:@"%@",[(Training*)[(TrainingProtocol*)[_recentProtocols objectAtIndex:row]training]name]];
    }
    if(section == 1){
         cell.titleLabel.text =[NSString stringWithFormat:@"%@",[(Training*)[_ownTrainings objectAtIndex:row]name]];
    }
    if (section == 2) {
         cell.titleLabel.text =[NSString stringWithFormat:@"%@",[(Training*)[_foreignTrainings objectAtIndex:row]name]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        _chosenProtocol = [_recentProtocols objectAtIndex:row];
        
    }
    if(section == 1){
        _chosenTraining = [_ownTrainings objectAtIndex:row];
    }
    if (section == 2) {
        _chosenTraining = [_foreignTrainings objectAtIndex:row];
    }
    [self performSegueWithIdentifier:@"ShowTraining" sender:self];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowTraining"]){
        TrainingViewController *tvc = (TrainingViewController*)segue.destinationViewController;
        if(_chosenProtocol){
            tvc.activeProtocol = _chosenProtocol;
            tvc.activeTraining = _chosenProtocol.training;
            
        }else{
            tvc.activeTraining = _chosenTraining;
        }
    
    }
}


@end
