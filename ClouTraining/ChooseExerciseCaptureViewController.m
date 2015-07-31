//
//  ChooseExerciseCaptureViewController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 11.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ChooseExerciseCaptureViewController.h"
#import "CreateTippsViewController.h"
#import "CreateTrainingTableViewCell.h"
#import "Exercise.h"



@interface ChooseExerciseCaptureViewController ()

@end

@implementation ChooseExerciseCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _exercises = [[DataController sharedInstance]getAllSharedExercises];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![GlobalHelperClass getUsername]){
        [[ErrorHandler sharedInstance]handleSimpleError:@"Achtung" andMessage:@"Du musst dich einloggen um Tipps erstellen zu können"];
        [self.navigationController popViewControllerAnimated:YES];
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
    
    return @"Übungen";
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
    
   cell.titleLabel.text = [(Exercise*)[_exercises objectAtIndex:row]name];
        

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*NSURL *movieURL = [NSURL URLWithString:@"http://192.168.178.45/clouTraining/media/12/videos/12-54-16_07_15video.mp4"];
    _movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [self presentMoviePlayerViewControllerAnimated:_movieController];
    [_movieController.moviePlayer play];
    
    return;*/
    
    _chosenExercise = [_exercises objectAtIndex:indexPath.row];
    [[Communicator sharedInstance]sendExerciseToServer:_chosenExercise];
    [self performSegueWithIdentifier:@"ShowCaptureForExercise" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowCaptureForExercise"]){
        CreateTippsViewController *ctvc = (CreateTippsViewController*)segue.destinationViewController;
        ctvc.exercise = _chosenExercise;
    }
}


@end
