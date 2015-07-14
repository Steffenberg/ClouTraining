//
//  Communicator.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 14.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "Communicator.h"
#import "DataConverter.h"
#import "Exercise.h"

@implementation Communicator

+(Communicator*)sharedInstance{
    static Communicator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Communicator alloc]init];
    });
    return sharedInstance;
}

-(BOOL)sendExerciseToServer:(Exercise*)e{
    NSData *jsonData = [DataConverter createJSONForExercise:e];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.178.36/clouTraining/scripts/CTSendExercise.php"]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *reply = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (error != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Synchronisierung fehlgeschlagen: %@", [error localizedDescription]);
            
            
        });
        return NO;
    }
    
    
    
    NSString *replyString = [[NSString alloc]initWithData:reply encoding:NSUTF8StringEncoding];
    NSLog(@"RESPONSE:%@",replyString);
    if([replyString hasPrefix:@"OK-ID"]){
        replyString = [replyString stringByReplacingOccurrencesOfString:@"OK-ID" withString:@""];
        
        [[DataController sharedInstance]updateExercise:e ID:replyString.integerValue];
    }
    
    
    return YES;
}

@end
