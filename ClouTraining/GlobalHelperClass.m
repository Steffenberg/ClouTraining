//
//  GlobalHelperClass.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "GlobalHelperClass.h"
#include <unistd.h>
#include <netdb.h>
#import <CommonCrypto/CommonDigest.h>

@implementation GlobalHelperClass

+(NSDate*)dateFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}

+(void)setTrainingDaysToShow:(NSInteger)days{
    [[NSUserDefaults standardUserDefaults]setInteger:days forKey:@"TrainingDaysToShow"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSInteger)getTrainingDaysToShow{
    return [[NSUserDefaults  standardUserDefaults]integerForKey:@"TrainingDaysToShow"];
}

+(void)setUsername:(NSString*)username{
    [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString*)getUsername{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
}

+(void)setMail:(NSString*)mail{
    [[NSUserDefaults standardUserDefaults]setObject:mail forKey:@"mail"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString*)getMail{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"mail"];
}

+(void)setPassword:(NSString*)password{
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString*)getPassword{
     return [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
}

+ (NSString *) createSHA512:(NSString *)source {
    
    NSString * rawstr = [NSString stringWithFormat:@"%@%@",source,@"kk6Tr7vxG0pqeZZdU7l35Ru1"];
    
    //const char *s = [rawstr cStringUsingEncoding:NSASCIIStringEncoding];
    
    //NSData *keyDataOld = [NSData dataWithBytes:s length:strlen(s)];
    
    NSData *keyData = [rawstr dataUsingEncoding:NSASCIIStringEncoding];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}

@end
