//
//  LoadingView.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

+(LoadingView*)sharedInstance{
    static LoadingView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoadingView alloc]init];
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        sharedInstance.frame = CGRectMake(0, 0, window.frame.size.width, window
                                          .frame.size.height);
        
        sharedInstance.blocker = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sharedInstance.frame.size.width, sharedInstance.frame.size.height)];
        [sharedInstance addSubview:sharedInstance.blocker];
        
        sharedInstance.background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sharedInstance.frame.size.width/3, sharedInstance.frame.size.width/3)];
        sharedInstance.background.backgroundColor = [UIColor blackColor];
        sharedInstance.background.alpha = 0.75f;
        sharedInstance.background.center = CGPointMake(sharedInstance.frame.size.width/2, sharedInstance.frame.size.height/2);
        [sharedInstance addSubview:sharedInstance.background];
        
        sharedInstance.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        sharedInstance.spinner.center = CGPointMake(sharedInstance.frame.size.width/2, sharedInstance.frame.size.height/2);
        [sharedInstance addSubview:sharedInstance.spinner];
        
        
    
    });
    return sharedInstance;
}

-(void)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        [window addSubview:self];
        [_spinner startAnimating];
    });
}

-(void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [_spinner stopAnimating];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
