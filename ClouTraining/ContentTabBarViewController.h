//
//  ContentTabBarViewController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 03.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SetupComplete)(BOOL);

@class Exercise;

@interface ContentTabBarViewController : UITabBarController

@property Exercise *exercise;

-(void)reloadToExercise:(Exercise*)e hide:(BOOL)hide completition:(SetupComplete)setupComplete;

@end
