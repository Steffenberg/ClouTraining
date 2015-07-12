//
//  ChooseExercisesViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseExercisesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property NSArray *exercises;
@property NSArray *trainingExercises;

@property Training *training;

@end
