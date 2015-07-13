//
//  TrainingContentViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SetupComplete)(BOOL);

@class Exercise, Training, TrainingProtocol, ExerciseProtocol;


@interface TrainingContentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property Training *training;
@property Exercise *exercise;
@property ExerciseProtocol *exProtocol;
@property NSArray *exerciseLogs;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;

-(void)reloadToExercise:(Exercise*)e ofTraining:(Training*)t completition:(SetupComplete)setupComplete;

@end
