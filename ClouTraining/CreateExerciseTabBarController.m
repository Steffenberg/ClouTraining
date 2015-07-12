//
//  CreateExerciseTabBarController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "CreateExerciseTabBarController.h"
#import "Exercise.h"

@interface CreateExerciseTabBarController ()

@end

@implementation CreateExerciseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _exercisesToAdd = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(!_training){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ExercisesChosen" object:_exercisesToAdd];
    }
    
}

-(BOOL)hasExercise:(Exercise*)exercise{
    for(Exercise *e in _exercisesToAdd){
        if(e.objectID == exercise.objectID){
            return YES;
        }
    }
    return NO;
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
