//
//  TrainingContentViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SetupComplete)(BOOL);

@class Exercise;

@interface TrainingContentViewController : UIViewController

@property Exercise *exercise;

-(void)reloadToExercise:(Exercise*)e completition:(SetupComplete)complete;

@end
