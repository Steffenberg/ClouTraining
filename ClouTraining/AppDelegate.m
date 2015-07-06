//
//  AppDelegate.m
//  ClouTraining
//
//  Created by fastline on 15.04.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "AppDelegate.h"
#import "Training.h"
#import "Exercise.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [DataController sharedInstance];
        NSLog(@"DataController created");
        if(![[NSUserDefaults standardUserDefaults]objectForKey:@"CTVersion"]){
            
            [[DataController sharedInstance]createTrainingWithName:@"TestTraining1" andDescription:@"" completition:^(id object){
                if(object){
                    Training *t = object;
                    NSLog(@"Created: %@",t.name);
                    
                    [[DataController sharedInstance]createExerciseWithData:@{@"name":@"Bankdrücken",
                                                                             @"describe":@"",
                                                                             @"distance":[NSNumber numberWithInteger:0],
                                                                             @"duration":[NSNumber numberWithInteger:0],
                                                                             @"repititions":[NSNumber numberWithInteger:6],
                                                                             @"sets":[NSNumber numberWithInteger:3],
                                                                             @"shared":[NSNumber numberWithBool:YES],
                                                                             @"weight":[NSNumber numberWithInteger:60000]
                                                                             } forTraining:t];
                    [[DataController sharedInstance]createExerciseWithData:@{@"name":@"Kniebeugen",
                                                                             @"describe":@"",
                                                                             @"distance":[NSNumber numberWithInteger:0],
                                                                             @"duration":[NSNumber numberWithInteger:0],
                                                                             @"repititions":[NSNumber numberWithInteger:8],
                                                                             @"sets":[NSNumber numberWithInteger:3],
                                                                             @"shared":[NSNumber numberWithBool:YES],
                                                                             @"weight":[NSNumber numberWithInteger:60000]
                                                                             } forTraining:t];
                    [[DataController sharedInstance]createExerciseWithData:@{@"name":@"Arnoldpress",
                                                                             @"describe":@"",
                                                                             @"distance":[NSNumber numberWithInteger:0],
                                                                             @"duration":[NSNumber numberWithInteger:0],
                                                                             @"repititions":[NSNumber numberWithInteger:10],
                                                                             @"sets":[NSNumber numberWithInteger:3],
                                                                             @"shared":[NSNumber numberWithBool:YES],
                                                                             @"weight":[NSNumber numberWithInteger:12500]
                                                                             } forTraining:t];
                    [[DataController sharedInstance]createExerciseWithData:@{@"name":@"Klimmzüge Maschine",
                                                                             @"describe":@"",
                                                                             @"distance":[NSNumber numberWithInteger:0],
                                                                             @"duration":[NSNumber numberWithInteger:0],
                                                                             @"repititions":[NSNumber numberWithInteger:5],
                                                                             @"sets":[NSNumber numberWithInteger:4],
                                                                             @"shared":[NSNumber numberWithBool:YES],
                                                                             @"weight":[NSNumber numberWithInteger:25000]
                                                                             } forTraining:t];
                    [[DataController sharedInstance]createExerciseWithData:@{@"name":@"Hyperextension",
                                                                             @"describe":@"",
                                                                             @"distance":[NSNumber numberWithInteger:0],
                                                                             @"duration":[NSNumber numberWithInteger:0],
                                                                             @"repititions":[NSNumber numberWithInteger:10],
                                                                             @"sets":[NSNumber numberWithInteger:3],
                                                                             @"shared":[NSNumber numberWithBool:YES],
                                                                             @"weight":[NSNumber numberWithInteger:10000]
                                                                             } forTraining:t];
                    [[DataController sharedInstance]createExerciseWithData:@{@"name":@"Sit ups",
                                                                             @"describe":@"",
                                                                             @"distance":[NSNumber numberWithInteger:0],
                                                                             @"duration":[NSNumber numberWithInteger:0],
                                                                             @"repititions":[NSNumber numberWithInteger:12],
                                                                             @"sets":[NSNumber numberWithInteger:3],
                                                                             @"shared":[NSNumber numberWithBool:YES],
                                                                             @"weight":[NSNumber numberWithInteger:0]
                                                                             } forTraining:t];
                    
                    
                }
                
                
            }];
            ;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithFloat:1.0] forKey:@"CTVersion"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[DataController sharedInstance]save];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[DataController sharedInstance]save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DataController sharedInstance]save];
    
}



@end
