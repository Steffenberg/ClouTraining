//
//  DataController.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 06.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^InitCallbackBlock)(void);

@interface DataController : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

+(DataController*)sharedInstanceWithCallback:(InitCallbackBlock)callback;
+(DataController*)sharedInstance;

-(void)save;

-(void)createTrainingWithName:(NSString *)name andDescription:(NSString*)desc;

-(NSArray*)getAllTrainings;

@end
