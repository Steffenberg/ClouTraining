//
//  CreateExerciseTabBarController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateExerciseTabBarController : UITabBarController

@property Training *training;
@property NSMutableArray *exercisesToAdd;

-(BOOL)hasExercise:(Exercise*)exercise;

@end
