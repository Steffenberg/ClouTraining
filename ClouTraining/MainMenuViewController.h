//
//  MainMenuViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//
//XXX

#import <UIKit/UIKit.h>

@class MainMenuButton;

@interface MainMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet MainMenuButton *trainingButton;
@property (weak, nonatomic) IBOutlet MainMenuButton *editTrainingButton;
@property (weak, nonatomic) IBOutlet MainMenuButton *editExerciseButton;
@property (weak, nonatomic) IBOutlet MainMenuButton *createTippsButton;
@property (weak, nonatomic) IBOutlet MainMenuButton *settingsButton;

@end
