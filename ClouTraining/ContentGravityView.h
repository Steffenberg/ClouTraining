//
//  ContentGravityView.h
//  GravityCircleProject
//
//  Created by Steffen Gruschka on 28.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseContentView.h"

@class ExerciseCircleView, GravityCircleView;

@interface ContentGravityView : UIView

@property (strong)ExerciseCircleView *child;
@property CGRect backupFrame;

@property GravityCircleView *circleView;

@property BOOL occupied;

-(void)handleContentViewMoved:(NSNotification*)note;
@end
