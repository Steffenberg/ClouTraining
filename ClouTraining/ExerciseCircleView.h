//
//  ContentCircleView.h
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseCircleView : UIView{
    UITouch *touch;
    CGPoint previousPoint;
    CGPoint currentPoint;
    
    
}
@property BOOL displaysContent;
@property BOOL canMove;
@property NSTimer *unlockTimer;
@property UIView *contentSuperview;

-(void)snapToAnchor:(CGPoint)anchor;
-(void)showContent;
-(void)hideContent;
-(void)freeChild;

@end
