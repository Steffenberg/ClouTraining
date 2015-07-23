//
//  ErrorHandler.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+(ErrorHandler*)sharedInstance{
    static ErrorHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ErrorHandler alloc]init];
        
        
    });
    return sharedInstance;
}

-(void)handleSimpleError:(NSString *)title andMessage:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alerView show];
    });
    
}

@end
