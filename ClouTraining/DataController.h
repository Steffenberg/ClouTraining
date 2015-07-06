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
typedef void (^ObjectReturnBlock)(id);

@class Training, Exercise, Media;

@interface DataController : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;

@property (strong) NSManagedObjectContext *privateContext;

+(DataController*)sharedInstanceWithCallback:(InitCallbackBlock)callback;
+(DataController*)sharedInstance;

-(void)save;

-(void)createTrainingWithName:(NSString *)name andDescription:(NSString*)desc completition:(ObjectReturnBlock)block;
-(void)addExercise:(Exercise*)e toTraining:(Training*)t;
-(NSArray*)getAllTrainings;

-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t;
-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t completition:(ObjectReturnBlock)block;
-(NSArray*)getExercisesForTraining:(Training*)t;
@end
