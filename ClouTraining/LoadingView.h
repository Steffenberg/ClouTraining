//
//  LoadingView.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property UIView *background;
@property UIView *blocker;
@property UIActivityIndicatorView *spinner;

+(LoadingView*)sharedInstance;
-(void)show;
-(void)hide;
@end
