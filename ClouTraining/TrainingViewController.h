//
//  ViewController.h
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GravityCircleView, ContentGravityView, ExerciseCircleView, Training, Exercise;

@interface TrainingViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet GravityCircleView *gravityCircleView;
@property (weak, nonatomic) IBOutlet ContentGravityView *contentGravityView;
@property (weak, nonatomic) IBOutlet UILabel *dragHereLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property ExerciseCircleView *currentOpenCircle;
@property (weak, nonatomic) IBOutlet UIView *contentTabSuperview;
@property BOOL firstStart;
@property Training *activeTraining;
@property NSArray *exercises;
@end

