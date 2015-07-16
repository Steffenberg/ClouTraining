//
//  GravityCircleView.h
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentGravityView, ExerciseCircleView;

@interface GravityCircleView : UIView{
    CGRect circleRect;
    
    
    
    CGFloat caliber;
    float extent;
    float lowerExtend;
    CGFloat childCaliber;
    
    CGFloat children;
}

@property NSMutableArray *anchors;
@property ContentGravityView *contentView;
@property BOOL mayReload;

-(id)initWithFrame:(CGRect)frame amountOfChildren:(CGFloat)childAmount;
-(void)setupView:(NSArray*)exercises;
-(void)handleContentViewMoved:(NSNotification*)note;
-(NSMutableDictionary*)getClosestAnchorForChild:(ExerciseCircleView*)child;
-(void)occuyAnchorForChildren:(ExerciseCircleView *)child;
@end
