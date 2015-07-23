//
//  ErrorHandler.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHandler : NSObject

+(ErrorHandler*)sharedInstance;

-(void)handleSimpleError:(NSString *)title andMessage:(NSString*)message;

@end
