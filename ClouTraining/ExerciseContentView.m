//
//  ContentContentView.m
//  ClouTraining
//
//  Created by fastline on 21.04.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ExerciseContentView.h"

@implementation ExerciseContentView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat width = frame.size.width - 30;
        _setSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 10, 2*(width/3), 30)];
        [self addSubview:_setSlider];
        _setLabel = [[UILabel alloc]initWithFrame:CGRectMake(_setSlider.frame.origin.x+_setSlider.frame.size.width+10, 10, width/3, 30)];
        _setLabel.text = @"Check";
        [self addSubview:_setLabel];
    }
    return self;
}

-(void)reloadData{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
