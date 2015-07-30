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

+(void)setUsername:(NSString*)username;
+(NSString*)getUsername;
+(void)setMail:(NSString*)mail;
+(NSString*)getMail;
+(void)setPassword:(NSString*)password;
+(NSString*)getPassword;

+ (NSString *) createSHA512:(NSString *)source;
@end
