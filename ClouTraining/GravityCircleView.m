//
//  GravityCircleView.m
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "GravityCircleView.h"
#import "ContentCircleView.h"
#import "ContentGravityView.h"
#include <math.h>

@implementation GravityCircleView

-(id)initWithFrame:(CGRect)frame amountOfChildren:(CGFloat)childAmount{
    if(frame.size.height != frame.size.width){
        return nil;
    }
    self = [super initWithFrame:frame];
    if(self){
        caliber = self.frame.size.height;
        extent = 2*(caliber/2)*M_PI;
        childCaliber = (extent/childAmount)/2;
        children = childAmount;
        self.backgroundColor = [UIColor clearColor];
        [self createChildren];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleContentViewMoveBegin:) name:@"ContentViewMoveBegin" object:nil];
        
        
    }
    return self;
}

-(void)createChildren{
    _anchors = [NSMutableArray array];
    for(int i = 0; i<children; i++){
        ContentCircleView *child = [[ContentCircleView alloc]initWithFrame:CGRectMake(0, 0, childCaliber, childCaliber)];
        child.backgroundColor = [UIColor clearColor];
        CGFloat radian = (360.0/children)* (M_PI / 180);
        CGFloat xy = self.frame.size.width/2;
        
        child.center = CGPointMake(((caliber-childCaliber/2)/2)*cosf(i*radian)+xy, ((caliber-childCaliber/2)/2)*sinf(i*radian)+xy);
        [self addSubview:child];
        [_anchors addObject:@{@"X":[NSNumber numberWithFloat:child.center.x],@"Y":[NSNumber numberWithFloat:child.center.y],@"Occupied":child}.mutableCopy];
    }
}

#pragma mark handle begin-movement of children

-(void)handleContentViewMoveBegin:(NSNotification*)note{
    
    ContentCircleView *child = [note.userInfo objectForKey:@"Object"];
    NSInteger changeIndex = -1;
    for(NSDictionary *dic in _anchors){
        if([[dic objectForKey:@"Occupied"]isEqual:child]){
            changeIndex = [_anchors indexOfObject:dic];
        }
    }
    if(changeIndex != -1){
        NSMutableDictionary *dic = [_anchors objectAtIndex:changeIndex];
        [dic removeObjectForKey:@"Occupied"];
    }
}

#pragma mark handle end-movement of children

-(void)handleContentViewMoved:(NSNotification*)note{
    ContentCircleView *child = [note.userInfo objectForKey:@"Object"];
    
    //child is not on circle view -> previously showed content
    if(![child.superview isEqual:self]){
        CGPoint center = [child.superview convertPoint:child.center toView:self];
        child.center = center;
        [self addSubview:child];
        child.displaysContent = NO;
        
    }
    
    // determine possible anchors
    NSMutableArray *possibleAnchors = [NSMutableArray array];
    for(NSMutableDictionary *dic in _anchors){
        if(![dic objectForKey:@"Occupied"]){
            [possibleAnchors addObject:dic];
        }
        
    }
    NSMutableDictionary *closestAnchor;
    CGFloat closeDistance = 0.0f;
    CGFloat closeX;
    CGFloat closeY;
    
    //find closest anchor on circleview
    for(NSMutableDictionary *dic in possibleAnchors){
        if([dic isEqual:[possibleAnchors firstObject]]){
            closestAnchor = dic;
            closeX = fabs(child.center.x - [[dic objectForKey:@"X"]floatValue]);
            closeY = fabs(child.center.y - [[dic objectForKey:@"Y"]floatValue]);
            closeDistance = sqrtf(closeX*closeX + closeY+closeY);
        }else{
            CGFloat currentX = fabs(child.center.x - [[dic objectForKey:@"X"]floatValue]);
            CGFloat currentY = fabs(child.center.y - [[dic objectForKey:@"Y"]floatValue]);
            CGFloat currentDistance = sqrtf(currentX*currentX + currentY*currentY);
            
            if(currentDistance < closeDistance){
                closeX = currentX;
                closeY = currentY;
                closeDistance = currentDistance;
                closestAnchor = dic;
            }
            
            NSLog(@"Current: %f - Closest: %f", currentDistance, closeDistance);
        }
    }
    if(closestAnchor){
        [child snapToAnchor:CGPointMake([[closestAnchor objectForKey:@"X"]floatValue],[[closestAnchor objectForKey:@"Y"]floatValue])];
        [closestAnchor setObject:child forKey:@"Occupied"];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect frame = self.frame;
    CGRect superFrame = self.superview.frame;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetFillColorWithColor( context, [UIColor redColor].CGColor );
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    
    //CGContextAddEllipseInRect(context, CGRectMake(self.frame.size.width/4, self.frame.size.height/2-self.frame.size.width/4, self.frame.size.width/2, self.frame.size.width/2));
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    CGContextStrokePath(context);
}


@end
