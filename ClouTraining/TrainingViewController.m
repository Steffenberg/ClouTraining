//
//  ViewController.m
//  GravityCircleProject
//
//  Created by fastline on 24.03.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "TrainingViewController.h"
#import "GravityCircleView.h"
#import "ExerciseCircleView.h"
#import "ContentGravityView.h"

@interface TrainingViewController ()

@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleContentViewMoved:) name:@"ContentViewMoved" object:nil];
    
    _gravityCircleView.contentView = _contentGravityView;
    _contentGravityView.circleView = _gravityCircleView;
    
    _dragHereLabel.shadowColor = UIColorFromRGB(DARK_GRAY);
    _dragHereLabel.shadowOffset = CGSizeMake(-0.5, -0.5);
    
    _firstStart = YES;
}

-(void)handleContentViewMoved:(NSNotification*)note{
    ExerciseCircleView *child = [note.userInfo objectForKey:@"Object"];
    if(CGRectContainsPoint(_contentGravityView.frame, child.center)){
        if(!_contentGravityView.occupied){
            [_contentGravityView handleContentViewMoved:note];
        }else{
            [_gravityCircleView handleContentViewMoved:note];
        }
        
    }else{
        if([child.superview isEqual:_contentGravityView] && _contentGravityView.occupied){
            _contentGravityView.occupied = NO;
        }
        [_gravityCircleView handleContentViewMoved:note];
        
    }
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //NSLog(@"Layout");
    
    if(_firstStart){
        _gravityCircleView = [[GravityCircleView alloc]initWithFrame:CGRectMake(15, 15, _circleSuperView.frame.size.width-30, _circleSuperView.frame.size.height-30) amountOfChildren:5.0f];
        
        [_circleSuperView addSubview:_gravityCircleView];
        _firstStart = NO;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
     [_gravityCircleView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
