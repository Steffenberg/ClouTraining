//
//  ContentCircleView.m
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ContentCircleView.h"
#import "ContentGravityView.h"

@implementation ContentCircleView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touch = [touches anyObject];
    previousPoint = [touch locationInView:self.superview];
    
    if(!_displaysContent){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContentViewMoveBegin" object:nil userInfo:@{@"Object":self}];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContentViewMoveBeginOpen" object:nil userInfo:@{@"Object":self, @"Touch":@{@"X":[NSNumber numberWithFloat:previousPoint.x],@"Y":[NSNumber numberWithFloat:previousPoint.y]}}];
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touch = [touches anyObject];
    currentPoint = [touch locationInView:self.superview];
    CGFloat movedX = currentPoint.x-previousPoint.x;
    CGFloat movedY = currentPoint.y-previousPoint.y;
    
    CGPoint newCenter = CGPointMake(self.center.x + movedX, self.center.y + movedY);
    self.center = newCenter;
    
    previousPoint = currentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ContentViewMoved" object:nil userInfo:@{@"Object":self}];
    
}



-(void)snapToAnchor:(CGPoint)anchor{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = anchor;
    } completion:^(BOOL finished){
        
    }];
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetFillColorWithColor( context, [UIColor greenColor].CGColor );
    CGContextSetStrokeColorWithColor(context,[UIColor greenColor].CGColor);
    
    //CGContextAddEllipseInRect(context, CGRectMake(self.frame.size.width/4, self.frame.size.height/2-self.frame.size.width/4, self.frame.size.width/2, self.frame.size.width/2));
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    CGContextStrokePath(context);
    
    
}

@end
