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

//NSString const *ipprefix = @"http://192.168.178.29";
NSString const *ipprefix = @"http://127.0.0.1";

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
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTSendExercise.php",ipprefix]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       NSString *str = [NSString stringWithFormat:@"Error: %@",error.localizedDescription];
                                       UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"Fehler" message:str delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                                       [alerView show];
                                   });
                                   
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

-(void)getSharedExercises{
   
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTGetSharedExercises.php",ipprefix]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [urlRequest setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       NSString *str = [NSString stringWithFormat:@"Error: %@",error.localizedDescription];
                                       UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"Fehler" message:str delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                                       [alerView show];
                                   });
                                   
                               }else{
                                   
                                   NSString *replyString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE:%@",replyString);
                                   
                                   if(![replyString hasPrefix:@"ERROR"]){
                                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"SharedExercisesUpdate" object:dict];
                                   }
                                   
                                   
                                   
                                   
                                   
                                   
                               }
                               
                           }];

    
    
    
    
    
    
    
    
}

-(BOOL)setShared:(BOOL)shared forExercise:(Exercise*)e{
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTSetExerciseShared.php?exerciseID=%@&shared=%@",ipprefix,e.exerciseid,e.shared]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *reply = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (error != nil)
    {
        
        return NO;
    }
    
    NSString *replyString = [[NSString alloc]initWithData:reply encoding:NSUTF8StringEncoding];
    NSLog(@"RESPONSE:%@",replyString);
    
    if([replyString isEqualToString:@"SUCCESS"]){
        
        
        return YES;
    }
    
    return NO;

    
}

-(void)deleteExercise:(Exercise*)e completition:(OnlineComplete)complete{
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTDeleteExercise.php?exerciseID=%@",ipprefix,e.exerciseid]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   
                                   complete(NO);
                                   
                               }else{
                                   NSString *replyString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE:%@",replyString);
                                   
                                   if([replyString isEqualToString:@"SUCCESS"]){
                                       
                                       complete(YES);
                                   }
                                   if([replyString isEqualToString:@"NOTFOUND"]){
                                       
                                       complete(YES);
                                   }
                                   
                               }
                               complete(NO);
                           }];
    
    
    
}

-(void)reuqestMediaInfoWithData:(NSDictionary*)data andMedia:(NSData*)media{
    if(!media){
        return;
    }
    
    NSData *jsonData = [DataConverter createJSONForData:data];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTCreateMedia.php",ipprefix]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:error];
                                   
                                   
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
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:@"ERROR"];
                                   }else{
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:@"ERROR"];
                                   }
                                   
                               }
                               
                           }];
    
    
    
}

-(void)getMediaURLsForExercise:(Exercise*)e type:(NSInteger)type{
    if(e.exerciseid.integerValue == 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaDataUpdate" object:@{}];
        return;
    }
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTGetMedia.php?exerciseID=%zd&type=%zd",ipprefix,e.exerciseid.integerValue,type]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       NSString *str = [NSString stringWithFormat:@"Error: %@",error.localizedDescription];
                                       UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"Fehler" message:str delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                                       [alerView show];
                                   });
                                   
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
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/",ipprefix]]];
    NSString *scriptPath = [NSString stringWithFormat:@"CTUploadMedia.php"];
    NSDictionary *parameters = @{@"mediaID":[NSNumber numberWithInteger:mediaID],
                                 @"randomKey":key,
                                 @"type":[NSNumber numberWithInteger:1]
                                 };
    
    AFHTTPRequestOperation *op = [manager POST:scriptPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:data name:@"video" fileName:@"video.mp4" mimeType:@"video/mp4"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:nil];
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:error];
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
    }];
    [op start];
}

-(void)uploadImage:(NSData*)data withAFforID:(NSInteger)mediaID andKey:(NSString*)key{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/",ipprefix]]];
    NSString *scriptPath = [NSString stringWithFormat:@"CTUploadMedia.php"];
    NSDictionary *parameters = @{@"mediaID":[NSNumber numberWithInteger:mediaID],
                                 @"randomKey":key,
                                 @"type":[NSNumber numberWithInteger:2]
                                 };
    
    AFHTTPRequestOperation *op = [manager POST:scriptPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:data name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:nil];
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:error];
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
    }];
    [op start];
}

@end
