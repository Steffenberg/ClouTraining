//
//  SettingsViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_table registerNib:[UINib nibWithNibName:@"SettingsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingsTableViewCell"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
     NSString *desiredText = textField.text;
    if([string isEqualToString:@""]){
        desiredText = [desiredText stringByReplacingCharactersInRange:NSMakeRange(desiredText.length-1, 1) withString:@""];
    }else{
        desiredText = [desiredText stringByAppendingString:string];
    }
    NSInteger days = desiredText.integerValue;
    if (days != 0){
        [GlobalHelperClass setTrainingDaysToShow:days];
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Trainings-Einstellungen";
    }
    if(section == 1){
        return @"Netzwerk-Einstelungen";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    if(section == 1){
        return 1;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"SettingsTableViewCell";
    SettingsTableViewCell *cell = (SettingsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    
    
    if(section == 0){
        if (row == 0) {
            cell.dateView.hidden = NO;
            cell.daysField.delegate = self;
            cell.daysField.text = [NSString stringWithFormat:@"%zd",[GlobalHelperClass getTrainingDaysToShow]];
        }
    }
    if(section == 1){
        if (row == 0) {
            cell.mobileView.hidden = NO;
            cell.mobileSwitch.on = ![Communicator dataOnlyWLAN];
        }
    }
    
    
    
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
