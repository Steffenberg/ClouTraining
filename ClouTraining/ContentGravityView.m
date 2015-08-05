//
//  ContentGravityView.m
//  GravityCircleProject
//
//  Created by Steffen Gruschka on 28.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ContentGravityView.h"
#import "ExerciseCircleView.h"
#import "GravityCircleView.h"

@implementation ContentGravityView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0f;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleContentViewMoveBegin:) name:@"ContentViewMoveBeginOpen" object:nil];
}

-(void)handleContentViewMoved:(NSNotification*)note{
    _child = [note.userInfo objectForKey:@"Object"];
    [self maximizeChild];
    
}

#pragma mark handle unfold child

-(void)maximizeChild{
    //change shape
    _child.displaysContent = YES;
    _occupied = YES;
    [_child setNeedsDisplay];
    
    //get point that child would have in self
    _child.center = [self convertPoint:_child.center fromView:_child.superview];
    [self addSubview:_child];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backupFrame = _child.frame;
        _child.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        _child.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
       // _child.center = [self.superview convertPoint:self.center toView:_child.superview];
    } completion:^(BOOL finished){
        _child.canMove = NO;
        
        [_child showContent];
    }];
}

#pragma mark handle begin-movement of children

-(void)shrinkChild:(ExerciseCircleView*)child{
    _child.displaysContent = NO;
    [_child hideContent];
    [_child setNeedsDisplay];
    CGRect frame = _child.frame;
    frame.size.width = _backupFrame.size.width;
    frame.size.height = _backupFrame.size.height;
    _child.frame = frame;
    child.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    /*[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        
    } completion:^(BOOL finished){
        
        
    }];*/
}

-(void)handleContentViewMoveBegin:(NSNotification*)note{
    _child.displaysContent = NO;
    [_child hideContent];
    [_child setNeedsDisplay];
    
    NSDictionary *touch = [note.userInfo objectForKey:@"Touch"];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect frame = _child.frame;
        frame.size.width = _backupFrame.size.width;
        frame.size.height = _backupFrame.size.height;
        _child.frame = frame;
        _child.center = CGPointMake([[touch objectForKey:@"X"]floatValue], [[touch objectForKey:@"Y"]floatValue]);
    } completion:^(BOOL finished){
        
        
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
