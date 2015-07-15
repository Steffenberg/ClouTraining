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
#import "AFNetworking.h"

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
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.178.42/clouTraining/scripts/CTSendExercise.php"]]];
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

-(void)reuqestMediaInfoFor:(Exercise*)e withData:(NSDictionary*)data andMedia:(NSData*)media{
    data = @{@"exerciseID":e.exerciseid,
             @"type":[NSNumber numberWithInteger:1],
             @"date":[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
             };
    NSData *jsonData = [DataConverter createJSONForData:data];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.178.42/clouTraining/scripts/CTCreateMedia.php"]]];
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
        return;
    }
    
    
    
    NSString *replyString = [[NSString alloc]initWithData:reply encoding:NSUTF8StringEncoding];
    NSLog(@"RESPONSE:%@",replyString);
    if([replyString hasPrefix:@"TEXTINSERT"]){
        
    }else if([replyString isEqualToString:@"ERROR"]){
        
    }else{
        NSArray *array = [replyString componentsSeparatedByString:@"-"];
        [self uploadMedia:media forID:[(NSString*)[array firstObject]integerValue] andKey:[array lastObject] completition:^(BOOL complete){
            
            
        }];
        
    }

}

-(void)uploadMedia:(NSData*)data forID:(NSInteger)mediaID andKey:(NSString*)key completition:(MediaComplete)completition{
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.178.42/clouTraining/scripts/CTUploadMedia.php?mediaid=%zd&key=%@",mediaID,key]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   completition(NO);
                               }else{
                                   NSString *replyString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE:%@",replyString);
                                   completition(YES);
                               }
                               
                           }];
    
    
    
}

@end
