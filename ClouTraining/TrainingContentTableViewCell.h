//
//  TrainingContentTableViewCell.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 09.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetEntry;

@interface TrainingContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *repLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UISlider *repSlider;
@property (weak, nonatomic) IBOutlet UISlider *weightSlider;
@property (weak, nonatomic) IBOutlet UISlider *floatWeightSlider;

@property SetEntry *entry;
@end
