//
//  ViewController.h
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GravityCircleView, ContentGravityView, ExerciseCircleView, Training, Exercise, ExerciseProtocol;

@interface TrainingViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *imagePresenterView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *textPresenterView;
@property (weak, nonatomic) IBOutlet UILabel *textTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *textClose;

@property (strong, nonatomic) IBOutlet GravityCircleView *gravityCircleView;
@property (weak, nonatomic) IBOutlet ContentGravityView *contentGravityView;
@property (weak, nonatomic) IBOutlet UILabel *dragHereLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property ExerciseCircleView *currentOpenCircle;
@property (weak, nonatomic) IBOutlet UIView *contentTabSuperview;
@property BOOL firstStart;

@property UIVisualEffectView *effectView;

@property Training *activeTraining;
@property TrainingProtocol *activeProtocol;
@property NSArray *exercises;
@end

