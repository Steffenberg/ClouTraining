//
//  TrainingContentViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "TrainingContentViewController.h"
#import "TrainingContentTableViewCell.h"
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

-(void)reloadToExercise:(Exercise*)e completition:(SetupComplete)complete{
    _exercise = e;
    if(_exercise){
        _titleLabel.text = e.name;
        
        complete(YES);
    }else{
        complete(NO);
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _exercise.sets.integerValue;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"TrainingContentTableViewCell";
    TrainingContentTableViewCell *cell = (TrainingContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    
    return cell;
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
