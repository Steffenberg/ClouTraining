//
//  ContentCircleView.h
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCircleView : UIView{
    UITouch *touch;
    CGPoint previousPoint;
    CGPoint currentPoint;
    
    
}

@property BOOL displaysContent;

-(void)snapToAnchor:(CGPoint)anchor;
@end
