//
//  GlobalHelperClass.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHelperClass : NSObject

+(NSDate*)dateFromString:(NSString*)dateString;

+(void)setTrainingDaysToShow:(NSInteger)days;
+(NSInteger)getTrainingDaysToShow;

@end
