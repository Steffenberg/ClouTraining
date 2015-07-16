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

-(void)sendExerciseToServer:(Exercise*)e{
    NSData *jsonData = [DataConverter createJSONForExercise:e];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.178.45/clouTraining/scripts/CTSendExercise.php"]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   
                               }else{
                                   NSString *replyString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE:%@",replyString);
                                   
                                   if([replyString hasPrefix:@"OK-ID"]){
                                       replyString = [replyString stringByReplacingOccurrencesOfString:@"OK-ID" withString:@""];
                                       
                                       [[DataController sharedInstance]updateExercise:e ID:replyString.integerValue];
                                   }
                                   
                               }
                               
                           }];
    
    
    
    
    
    
    
    
}

-(void)reuqestMediaInfoWithData:(NSDictionary*)data andMedia:(NSData*)media{
    if(!media){
        return;
    }
    
    NSData *jsonData = [DataConverter createJSONForData:data];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.178.45/clouTraining/scripts/CTCreateMedia.php"]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   
                               }else{
                                   NSString *replyString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE:%@",replyString);
                                   if([replyString hasPrefix:@"SUCCESS"]){
                                       replyString = [replyString stringByReplacingOccurrencesOfString:@"SUCCESS" withString:@""];
                                       NSArray *array = [replyString componentsSeparatedByString:@"-"];
                                       
                                       if([(NSString*)[array lastObject]integerValue] == 1){
                                           [self uploadVideo:media withAFforID:[(NSString*)[array firstObject]integerValue] andKey:[array objectAtIndex:1]];
                                       }
                                       
                                       if([(NSString*)[array lastObject]integerValue] == 2){
                                           [self uploadImage:media withAFforID:[(NSString*)[array firstObject]integerValue] andKey:[array objectAtIndex:1]];
                                       }
                                       
                                       
                                   }else if([replyString hasPrefix:@"TEXTINSERT"]){
                                       
                                   }else if([replyString isEqualToString:@"ERROR"]){
                                       
                                   }else{
                                       
                                   }
                                   
                               }
                               
                           }];
    
    
    
}

-(void)getMediaURLsForExercise:(Exercise*)e type:(NSInteger)type{
    if(e.exerciseid.integerValue == 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaDataUpdate" object:@{}];
        return;
    }
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.178.45/clouTraining/scripts/CTGetMedia.php?exerciseID=%zd&type=%zd",e.exerciseid.integerValue,type]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   
                               }else{
                                   
                                    NSString *replyString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE:%@",replyString);
                                   
                                   if(![replyString hasPrefix:@"ERROR"]){
                                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaDataUpdate" object:dict];
                                   }
                                   
                                  
                                   
                                   
                                   
                                   
                               }
                               
                           }];

    
    
}

-(void)uploadVideo:(NSData*)data withAFforID:(NSInteger)mediaID andKey:(NSString*)key{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.178.45/clouTraining/scripts/"]];
    NSString *scriptPath = [NSString stringWithFormat:@"CTUploadMedia.php"];
    NSDictionary *parameters = @{@"mediaID":[NSNumber numberWithInteger:mediaID],
                                 @"randomKey":key,
                                 @"type":[NSNumber numberWithInteger:1]
                                 };
    
    AFHTTPRequestOperation *op = [manager POST:scriptPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:data name:@"video" fileName:@"video.mp4" mimeType:@"video/mp4"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
    }];
    [op start];
}

-(void)uploadImage:(NSData*)data withAFforID:(NSInteger)mediaID andKey:(NSString*)key{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.178.45/clouTraining/scripts/"]];
    NSString *scriptPath = [NSString stringWithFormat:@"CTUploadMedia.php"];
    NSDictionary *parameters = @{@"mediaID":[NSNumber numberWithInteger:mediaID],
                                 @"randomKey":key,
                                 @"type":[NSNumber numberWithInteger:2]
                                 };
    
    AFHTTPRequestOperation *op = [manager POST:scriptPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:data name:@"image" fileName:@"image.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
    }];
    [op start];
}

@end
