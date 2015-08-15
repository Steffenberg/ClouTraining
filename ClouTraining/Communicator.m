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

NSString const *ipprefix = @"http://192.168.178.58";
//NSString const *ipprefix = @"http://127.0.0.1";

@implementation Communicator



+(Communicator*)sharedInstance{
    static Communicator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Communicator alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
        
        sharedInstance.reachability = [Reachability reachabilityForInternetConnection];
        [sharedInstance.reachability startNotifier];
        
        NetworkStatus remoteHostStatus = [sharedInstance.reachability currentReachabilityStatus];
        
        if(remoteHostStatus == NotReachable) {NSLog(@"no");}
        else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
        else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
        
    });
    return sharedInstance;
}

+(BOOL)dataOnlyWLAN{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"dataOnlyWLAN"];
}

+(void)setDataOnlyLAN:(BOOL)only{
    [[NSUserDefaults standardUserDefaults]setBool:only forKey:@"dataOnlyWLAN"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    
    NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {NSLog(@"no");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
}

-(void)performLogin:(NSString*)nickname password:(NSString*)password{
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTlogin.php?username=%@&password=%@",ipprefix,nickname,password]]];
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
                                   
                                   if([replyString hasPrefix:@"OK"]){
                                       replyString = [replyString stringByReplacingOccurrencesOfString:@"OK" withString:@""];
                                       NSArray *array = [replyString componentsSeparatedByString:@"-"];
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginComplete" object:@{@"userid":[NSNumber numberWithInteger:[(NSString*)[array firstObject]integerValue]],
                                                                                                                           @"nickname":nickname,
                                                                                                                           @"password":password,
                                                                                                                           @"trainings":[array lastObject]
                                                                                                                           }];
                                   }else{
                                       
                                   }
                               }
                               
                           }];
}

-(void)performRegister:(NSString*)mail password:(NSString*)password nickname:(NSString*)nickname{
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTRegister.php?email=%@&username=%@&password=%@",ipprefix,mail,nickname,password]]];
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
                                   
                                   if([replyString isEqualToString:@"OK"]){
                                       replyString = [replyString stringByReplacingOccurrencesOfString:@"OK" withString:@""];
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterComplete" object:nil];
                                   }else if([replyString isEqualToString:@"email"]){
                                       [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"email bereits vergeben"];
                                   }else if([replyString isEqualToString:@"nickname"]){
                                       [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Benutzername bereits vergeben"];
                                   }
                               }
                               
                           }];
}

-(void)sendExerciseToServer:(Exercise*)e{
    if(![GlobalHelperClass getUsername]){
        return;
    }
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten"];
            return;
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet."];
            return;
        }
        
    }
    
    
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
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten"];
            return;
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet."];
            return;
        }
    }
    //NSString *check = [NSString stringWithFormat:@"%@/clouTraining/scripts/CTGetSharedExercises.php?username=%@&password=%@",ipprefix,[GlobalHelperClass getUsername],[GlobalHelperClass getPassword]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTGetSharedExercises.php?username=%@&password=%@",ipprefix,[GlobalHelperClass getUsername],[GlobalHelperClass getPassword]]]];
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
    if(![GlobalHelperClass getUsername]){
        return NO;
    }
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten"];
            return NO;
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet."];
            return NO;
        }
    }
    
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
    if(![GlobalHelperClass getUsername]){
        complete(NO);
    }
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten"];
            complete(NO);
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet."];
            complete(NO);
        }
    }
    
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

-(void)getMediaURLsForExercise:(Exercise*)e type:(NSInteger)type{
    if(e.exerciseid.integerValue == 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaDataUpdate" object:@{}];
        return;
    }
    
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten"];
            return;
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet."];
            return;
        }
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
#pragma mark - send tipp
-(void)sendText:(NSString*)text withTitle:(NSString*)title forExercise:(Exercise*)e completition:(OnlineComplete)complete{
    if(![GlobalHelperClass getUsername]){
        complete(NO);
    }
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten"];
            complete(NO);
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet."];
            complete(NO);
        }
    }
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTCreateMedia.php",ipprefix]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSDictionary *data = @{@"username":[GlobalHelperClass getUsername],
                           @"password":[GlobalHelperClass getPassword],
                           @"exerciseID":e.exerciseid,
                          @"text":text,
                           @"title":title,
                           @"type":[NSNumber numberWithInteger:3],
                           @"date":[NSNumber numberWithInteger:[e.date timeIntervalSince1970]],
                          };
    
    [urlRequest setHTTPBody:[DataConverter createJSONForData:data]];
    
    [[LoadingView sharedInstance]show];
    
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   
                                   complete(NO);
                                   
                               }else{
                                   NSString *replyString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE:%@",replyString);
                                   
                                   if([replyString isEqualToString:@"TEXTINSERT"]){
                                       
                                       complete(YES);
                                   }
                                   if([replyString hasPrefix:@"ERROR"]){
                                       
                                       complete(NO);
                                   }
                                   
                                   
                               }
                               complete(NO);
                           }];
    
    
    
}


#pragma mark - send media

-(void)reuqestMediaInfoWithData:(NSDictionary*)data andMedia:(NSData*)media{
    if(!media){
        return;
    }
    if(![GlobalHelperClass getUsername]){
        return;
    }
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten"];
            return;
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet."];
            return;
        }
    }
    
    NSData *jsonData = [DataConverter createJSONForData:data];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clouTraining/scripts/CTCreateMedia.php",ipprefix]]];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    
    [[LoadingView sharedInstance]show];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error){
                                   NSLog(@"Schwerer Fehler:%@",error.localizedDescription);
                                   [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:error];
                                   
                                   [[LoadingView sharedInstance]hide];
                                   
                                   
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
                                       
                                       [[LoadingView sharedInstance]hide];
                                   }else{
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:@"ERROR"];
                                       
                                       [[LoadingView sharedInstance]hide];
                                   }
                                   
                               }
                               
                           }];
    
    
    
}



-(void)uploadVideo:(NSData*)data withAFforID:(NSInteger)mediaID andKey:(NSString*)key{
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten. Vorgang abgebrochen"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:@"ERROR"];
            [[LoadingView sharedInstance]hide];
            return;
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet. Vorgang abgebrochen."];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:@"ERROR"];
            [[LoadingView sharedInstance]hide];
            return;
        }
    }
    
    
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
        [[LoadingView sharedInstance]hide];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:nil];
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[LoadingView sharedInstance]hide];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:error];
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
    }];
    [op start];
}

-(void)uploadImage:(NSData*)data withAFforID:(NSInteger)mediaID andKey:(NSString*)key{
    if([Communicator dataOnlyWLAN]){
        if([_reachability isReachable] && ![_reachability isReachableViaWiFi]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht eine Verbindung zum Internet, du hast jedoch die Kommunikation für mobile Daten aktiviert. Verbinde dich mit einem WLAN oder aktiviere die Kommunikation für mobile Daten. Vorgang abgebrochen"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:@"ERROR"];
            [[LoadingView sharedInstance]hide];
            return;
        }
    }else{
        if(![_reachability isReachable]){
            [[ErrorHandler sharedInstance]handleSimpleError:@"Netzwerkfehler" andMessage:@"Es besteht keine Verbindung zum Internet. Vorgang abgebrochen."];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:@"ERROR"];
            [[LoadingView sharedInstance]hide];
            return;
        }
    }
    
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
        [[LoadingView sharedInstance]hide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaUploadRecall" object:error];
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [[LoadingView sharedInstance]hide];
        
    }];
    [op start];
}

@end
