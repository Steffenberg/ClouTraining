//
//  SettingsViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end
