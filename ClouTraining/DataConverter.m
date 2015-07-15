//
//  DataConverter.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 14.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "DataConverter.h"
#import "Exercise.h"

@implementation DataConverter

+(DataConverter*)sharedInstance{
    static DataConverter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataConverter alloc]init];
    });
    return sharedInstance;
}

+(NSData*)createJSONForExercise:(Exercise*)e{
    NSDictionary *data = @{@"exerciseID":e.exerciseid,
                           @"name":e.name,
                           @"describe":@"lol",
                           @"maxWeight":e.maxWeight,
                           @"shared":e.shared,
                           @"date":[NSNumber numberWithInteger:[e.date timeIntervalSince1970]]
                           
                           };
    NSString *jsonPrefix =@"data=";
    NSMutableData * jsonData = [jsonPrefix dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    
    [jsonData appendData:[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil]];
    NSString *check = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    
    
    return jsonData;
    
}

+(NSData*)createJSONForData:(NSDictionary*)data{
    
    NSString *jsonPrefix =@"data=";
    NSMutableData * jsonData = [jsonPrefix dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    
    [jsonData appendData:[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil]];
    NSString *check = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    
    
    return jsonData;
    
}

@end
