//
//  ManageTrainingsTableViewCell.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageTrainingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
