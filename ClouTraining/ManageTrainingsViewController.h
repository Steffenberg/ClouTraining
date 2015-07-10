//
//  ManageTrainingViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Training;

@interface ManageTrainingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property NSArray *trainings;
@property Training *chosenTraining;
@end
