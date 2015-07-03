//
//  ContentCircleView.m
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ExerciseCircleView.h"
#import "ContentGravityView.h"

@implementation ExerciseCircleView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _canMove = YES;
        self.opaque = NO;
    }
    return self;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint pointInB = [_contentSuperview convertPoint:point fromView:self];
    
    if ([_contentSuperview pointInside:pointInB withEvent:event])
        return self;
    
    return [super hitTest:point withEvent:event];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touch = [touches anyObject];
    previousPoint = [touch locationInView:self.superview];
    
    if(!_displaysContent){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContentViewMoveBegin" object:nil userInfo:@{@"Object":self}];
    }else{
        if(_canMove){
          [[NSNotificationCenter defaultCenter]postNotificationName:@"ContentViewMoveBeginOpen" object:nil userInfo:@{@"Object":self, @"Touch":@{@"X":[NSNumber numberWithFloat:previousPoint.x],@"Y":[NSNumber numberWithFloat:previousPoint.y]}}];
        }else{
            [_unlockTimer invalidate];
            _unlockTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(freeChild) userInfo:nil repeats:NO];
        }
        
    }
    
}

-(void)freeChild{
    _canMove = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ContentViewMoveBeginOpen" object:nil userInfo:@{@"Object":self, @"Touch":@{@"X":[NSNumber numberWithFloat:previousPoint.x],@"Y":[NSNumber numberWithFloat:previousPoint.y]}}];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!_canMove){
        return;
    }
    touch = [touches anyObject];
    currentPoint = [touch locationInView:self.superview];
    CGFloat movedX = currentPoint.x-previousPoint.x;
    CGFloat movedY = currentPoint.y-previousPoint.y;
    
    CGPoint newCenter = CGPointMake(self.center.x + movedX, self.center.y + movedY);
    self.center = newCenter;
    
    previousPoint = currentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!_canMove){
        [_unlockTimer invalidate];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ContentViewMoved" object:nil userInfo:@{@"Object":self}];
    
}


-(void)snapToAnchor:(CGPoint)anchor{

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = anchor;
    } completion:^(BOOL finished){
        
    }];
}

-(void)showContent{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChildMaximized" object:self userInfo:@{@"training":@"Test",@"shown":[NSNumber numberWithBool:NO]}];
    
}

-(void)hideContent{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChildMaximized" object:self userInfo:@{@"training":@"Test",@"shown":[NSNumber numberWithBool:NO]}];
}

- (void)drawRect:(CGRect)rect {
    
    if(!_displaysContent){
        // Drawing code
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetFillColorWithColor( context, UIColorFromRGB(SECONDARY_PRIME).CGColor );
        CGContextSetStrokeColorWithColor(context,UIColorFromRGB(SECONDARY_PRIME).CGColor);
        //CGContextAddEllipseInRect(context, CGRectMake(self.frame.size.width/4, self.frame.size.height/2-self.frame.size.width/4, self.frame.size.width/2, self.frame.size.width/2));
        CGContextFillEllipseInRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        
        CGContextStrokePath(context);
    }else{
        // Drawing code
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetFillColorWithColor( context, UIColorFromRGB(SECONDARY_PRIME).CGColor );
        CGContextSetStrokeColorWithColor(context,UIColorFromRGB(SECONDARY_PRIME).CGColor);
        //CGContextAddEllipseInRect(context, CGRectMake(self.frame.size.width/4, self.frame.size.height/2-self.frame.size.width/4, self.frame.size.width/2, self.frame.size.width/2));
        CGContextFillRect (context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        
        CGContextStrokePath(context);
    }
    
    
    
}

@end
