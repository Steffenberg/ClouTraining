//
//  SettingsTableViewCell.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *daysField;
@property (weak, nonatomic) IBOutlet UISwitch *mobileSwitch;
@property (weak, nonatomic) IBOutlet UIView *dateView;
- (IBAction)mobileSwitchChanged:(id)sender;

@end
