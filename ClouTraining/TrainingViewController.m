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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleChildMaximized:) name:@"ChildMaximized" object:nil];
    
    
    UITapGestureRecognizer *doubleRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTab:)];
    doubleRec.numberOfTapsRequired = 2;
    doubleRec.delegate = self;
    [self.view addGestureRecognizer:doubleRec];
    
    _dragHereLabel.shadowColor = UIColorFromRGB(DARK_GRAY);
    _dragHereLabel.shadowOffset = CGSizeMake(-0.5, -0.5);
    
    _firstStart = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_gravityCircleView setupView:5];
    [_gravityCircleView setNeedsDisplay];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(CGRectContainsPoint(_contentTabSuperview.frame, [touch locationInView:_contentTabSuperview])){
        return YES;
    }
    return NO;
}

-(void)handleDoubleTab:(UITapGestureRecognizer*)doubleTap{
    if(_currentOpenCircle){
        if([_currentOpenCircle.superview isEqual:_contentGravityView] && _contentGravityView.occupied){
            _contentGravityView.occupied = NO;
            _currentOpenCircle.hidden = NO;
            _contentTabSuperview.hidden = YES;
            [_contentGravityView shrinkChild:_currentOpenCircle];
        }
        [_gravityCircleView handleContentViewMoved:[NSNotification notificationWithName:@"" object:nil userInfo:@{@"Object":_currentOpenCircle}]];
    }
    
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

-(void)handleChildMaximized:(NSNotification*)note{
    
    _currentOpenCircle = note.object;
    _currentOpenCircle.hidden = !_currentOpenCircle.hidden;
    _currentOpenCircle.contentSuperview = _contentTabSuperview;
    _contentTabSuperview.hidden = !_contentTabSuperview.hidden;
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //NSLog(@"Layout");
    
    if(_firstStart && _gravityCircleView){
        
        
        _gravityCircleView.contentView = _contentGravityView;
        _contentGravityView.circleView = _gravityCircleView;
        
        _firstStart = NO;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
