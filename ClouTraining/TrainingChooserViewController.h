//
//  TrainingChooserViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Training, TrainingProtocol;

@interface TrainingChooserViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property NSArray *recentProtocols;
@property NSArray *ownTrainings;
@property NSArray *foreignTrainings;

@property TrainingProtocol *chosenProtocol;
@property Training *chosenTraining;

@end
