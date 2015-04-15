//
//  ViewController.h
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GravityCircleView, ContentGravityView;

@interface TrainingViewController : UIViewController

@property (strong, nonatomic) GravityCircleView *gravityCircleView;
@property (weak, nonatomic) IBOutlet UIView *circleSuperView;
@property (weak, nonatomic) IBOutlet ContentGravityView *contentGravityView;

@end

