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

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerComplete:) name:@"RegisterComplete" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginComplete:) name:@"LoginComplete" object:nil];
}



- (void)registerComplete:(NSNotification*)note{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginComplete:(NSNotification*)note{
    NSDictionary *dic = note.object;
    
    [GlobalHelperClass setUsername:[dic objectForKey:@"username"]];
    [GlobalHelperClass setPassword:[dic objectForKey:@"password"]];
    
    [_table reloadData];
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
    if([GlobalHelperClass getUsername]){
        return 3;
    }
    return 4;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([GlobalHelperClass getUsername]){
        if(section == 0){
            return @"Login";
        }
        if(section == 1){
            return @"Trainings-Einstellungen";
        }
        if(section == 2
           ){
            return @"Netzwerk-Einstelungen";
        }
    }else{
        if(section == 0){
            return @"Login";
        }
        if(section == 1){
            return @"Registrieren";
        }
        if(section == 2){
            return @"Trainings-Einstellungen";
        }
        if(section == 3){
            return @"Netzwerk-Einstelungen";
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if([GlobalHelperClass getUsername]){
        if(section == 0){
            return 80.0f;
        }
        if(section == 1){
            return 44.0f;
        }
        if(section == 2
           ){
            return 44.0f;
        }
    }else{
        if(section == 0){
            return 80.0f;
        }
        if(section == 1){
            return 120.0f;
        }
        if(section == 2){
            return 44.0f;
        }
        if(section == 3){
            return 44.0f;
        }
    }
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([GlobalHelperClass getUsername]){
        if(section == 0){
            return 1;
        }
        if(section == 1){
            return 1;
        }
        if(section == 2
           ){
            return 1;
        }
    }else{
        if(section == 0){
            return 1;
        }
        if(section == 1){
            return 1;
        }
        if(section == 2){
            return 1;
        }
        if(section == 3){
            return 1;
        }
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
       cell.loginView.hidden = NO;
        if([GlobalHelperClass getUsername]){
            cell.nicknameField.text = [GlobalHelperClass getUsername];
        }
    }
    
    if(section == 1){
        if([GlobalHelperClass getUsername]){
            if (row == 0) {
                cell.dateView.hidden = NO;
                cell.daysField.delegate = self;
                cell.daysField.text = [NSString stringWithFormat:@"%zd",[GlobalHelperClass getTrainingDaysToShow]];
            }
            
        }else{
            cell.registerView.hidden = NO;
        }
    }
    if(section == 2){
        if([GlobalHelperClass getUsername]){
            if (row == 0) {
                cell.mobileView.hidden = NO;
                cell.mobileSwitch.on = ![Communicator dataOnlyWLAN];
            }
        }else{
            cell.dateView.hidden = NO;
            cell.daysField.delegate = self;
            cell.daysField.text = [NSString stringWithFormat:@"%zd",[GlobalHelperClass getTrainingDaysToShow]];
            
        }
        
    }
    
    if(section == 3){
        cell.mobileView.hidden = NO;
        cell.mobileSwitch.on = ![Communicator dataOnlyWLAN];
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
