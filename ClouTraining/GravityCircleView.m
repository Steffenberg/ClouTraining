//
//  GravityCircleView.m
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "GravityCircleView.h"
#import "ExerciseCircleView.h"
#import "ContentGravityView.h"
#import "Exercise.h"
#include <math.h>

@implementation GravityCircleView

-(id)initWithFrame:(CGRect)frame amountOfChildren:(CGFloat)childAmount{
    if(frame.size.height != frame.size.width){
        return nil;
    }
    self = [super initWithFrame:frame];
    if(self){
        
        
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    _mayReload = YES;
}

-(void)setupView:(NSArray*)exercises{
    NSInteger childAmount = exercises.count;
    NSLog(@"Frame:%@", NSStringFromCGRect(self.frame));
    caliber = self.frame.size.height;
    //extent = 2*(caliber/2)*M_PI;
    if(childAmount <= 9){
        childCaliber = (caliber/3);
    }else if(childAmount >9 && childAmount <= 12){
        childCaliber = (caliber/3);
    }else if(childAmount >12 && childAmount <= 16){
        childCaliber = (caliber/3.5);
    }else{
        return;
    }
    
    children = childAmount;
    self.backgroundColor = [UIColor clearColor];
    [self createChildren:exercises];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleContentViewMoveBegin:) name:@"ContentViewMoveBegin" object:nil];
    
    _mayReload = NO;
}

-(void)createChildren:(NSArray*)exercises{
    
    _anchors = [NSMutableArray array];
    
    for(int i = 0; i<children; i++){
        
        ExerciseCircleView *child = [[ExerciseCircleView alloc]initWithFrame:CGRectMake(0, 0, childCaliber, childCaliber)];
        child.exercise = [exercises objectAtIndex:i];
        child.titleLabel.text = child.exercise.name;
        child.backgroundColor = [UIColor clearColor];
 
        if(children <= 9){
            child.center = [self getPositionFor3x3:i];
        }else if(children >9 && children <= 12){
            child.center = [self getPositionFor4x3:i];
        }else if(children >12 && children <= 16){
            child.center = [self getPositionFor4x4:i];
        }
        [self addSubview:child];
        [_anchors addObject:@{@"X":[NSNumber numberWithFloat:child.center.x],@"Y":[NSNumber numberWithFloat:child.center.y],@"Occupied":child}.mutableCopy];
    }
}

-(CGPoint)getPositionFor3x3:(NSInteger)number{
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat x = center.x;
    CGFloat y = center.y;
    
    if(number%3 == 0){
        x = x-(3*childCaliber/2);
        if(number-3 <0){
           y = y-(childCaliber);
        }else if (number-3 >=3){
            y = y+(childCaliber);
        }
    }else  if(number%3 == 1){
        x = center.x;
        if(number-3 <0){
            y = y-(childCaliber);
        }else if (number-3 >=3){
            y = y+(childCaliber);
        }
    }else  if(number%3 == 2){
         x = x+(3*childCaliber/2);
        if(number-3 <0){
            y = y-(childCaliber);
        }else if (number-3 >=3){
            y = y+(childCaliber);
        }
    }
    
    
    return CGPointMake(x, y);
}

-(CGPoint)getPositionFor4x3:(NSInteger)number{
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat x = center.x;
    CGFloat y = center.y;
    
    if(number%4 == 0){
        x = x-(3*childCaliber/2);
        if(number-4 <0){
            y = y-(childCaliber);
        }else if (number-4 >=4){
            y = y+(childCaliber);
        }
    }else  if(number%4 == 1){
        x = x-(childCaliber/2);
        if(number-4 <0){
            y = y-(childCaliber);
        }else if (number-4 >=4){
            y = y+(childCaliber);
        }
    }else  if(number%4 == 2){
        x = x+(childCaliber/2);
        if(number-4 <0){
            y = y-(childCaliber);
        }else if (number-4 >=4){
            y = y+(childCaliber);
        }
    }else  if(number%4 == 3){
        x = x+(3*childCaliber/2);
        if(number-4 <0){
            y = y-(childCaliber);
        }else if (number-4 >=4){
            y = y+(childCaliber);
        }
    }
    
    
    return CGPointMake(x, y);
}

-(CGPoint)getPositionFor4x4:(NSInteger)number{
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat x = center.x;
    CGFloat y = center.y;
    
    if(number%4 == 0){
        x = x-(3*childCaliber/2);
        if(number-4 <0){
            y = y-(3*childCaliber/2);
        }else if(number-4 >=0 && number-4 <4){
            y = y-(childCaliber/2);
        }else if(number-4 >=4 && number-4 <8){
            y = y+(childCaliber/2);
        }else if (number-4 >=8){
            y = y+(3*childCaliber/2);
        }
    }else  if(number%4 == 1){
        x = x-(childCaliber/2);
        if(number-4 <0){
            y = y-(3*childCaliber/2);
        }else if(number-4 >=0 && number-4 <4){
            y = y-(childCaliber/2);
        }else if(number-4 >=4 && number-4 <8){
            y = y+(childCaliber/2);
        }else if (number-4 >=8){
            y = y+(3*childCaliber/2);
        }
    }else  if(number%4 == 2){
        x = x+(childCaliber/2);
        if(number-4 <0){
            y = y-(3*childCaliber/2);
        }else if(number-4 >=0 && number-4 <4){
            y = y-(childCaliber/2);
        }else if(number-4 >=4 && number-4 <8){
            y = y+(childCaliber/2);
        }else if (number-4 >=8){
            y = y+(3*childCaliber/2);
        }
    }else  if(number%4 == 3){
        x = x+(3*childCaliber/2);
        if(number-4 <0){
            y = y-(3*childCaliber/2);
        }else if(number-4 >=0 && number-4 <4){
            y = y-(childCaliber/2);
        }else if(number-4 >=4 && number-4 <8){
            y = y+(childCaliber/2);
        }else if (number-4 >=8){
            y = y+(3*childCaliber/2);
        }
    }
    
    
    return CGPointMake(x, y);
}

#pragma mark handle begin-movement of children

-(void)handleContentViewMoveBegin:(NSNotification*)note{

    ExerciseCircleView *child = [note.userInfo objectForKey:@"Object"];
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
    ExerciseCircleView *child = [note.userInfo objectForKey:@"Object"];
    
    //child is not on circle view -> previously showed content
    if(![child.superview isEqual:self]){
        CGPoint center = [child.superview convertPoint:child.center toView:self];
        child.center = center;
        [self addSubview:child];
        child.displaysContent = NO;
        
    }
    
    
    [self occuyAnchorForChildren:child];
}

-(void)occuyAnchorForChildren:(ExerciseCircleView *)child{
    NSMutableDictionary *closestAnchor = [self getClosestAnchorForChild:child];
    
    if(closestAnchor){
        [child snapToAnchor:CGPointMake([[closestAnchor objectForKey:@"X"]floatValue],[[closestAnchor objectForKey:@"Y"]floatValue])];
        [closestAnchor setObject:child forKey:@"Occupied"];
    }
}

-(NSMutableDictionary*)getClosestAnchorForChild:(ExerciseCircleView*)child{
    NSMutableDictionary *closestAnchor;
    CGFloat closeDistance = 0.0f;
    CGFloat closeX;
    CGFloat closeY;
    // determine possible anchors
    NSMutableArray *possibleAnchors = [NSMutableArray array];
    for(NSMutableDictionary *dic in _anchors){
        if(![dic objectForKey:@"Occupied"]){
            [possibleAnchors addObject:dic];
        }
        
    }
    
    
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
    
    return closestAnchor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.frame;
    CGRect superFrame = self.superview.frame;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetFillColorWithColor( context, UIColorFromRGB(MID_GRAY).CGColor );
    CGContextSetStrokeColorWithColor(context,UIColorFromRGB(MID_GRAY).CGColor);
    
    //CGContextAddEllipseInRect(context, CGRectMake(self.frame.size.width/4, self.frame.size.height/2-self.frame.size.width/4, self.frame.size.width/2, self.frame.size.width/2));
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    CGContextStrokePath(context);
}*/


@end
