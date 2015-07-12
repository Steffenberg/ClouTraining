//
//  ChooseExerciseCaptureViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 11.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Exercise;

@interface ChooseExerciseCaptureViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSArray *exercises;
@property Exercise *chosenExercise;


@end
