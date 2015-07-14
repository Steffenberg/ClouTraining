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

@class Training, Exercise, Media, ExerciseProtocol, SetEntry,TrainingProtocol;

@interface DataController : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;

@property (strong) NSManagedObjectContext *privateContext;

+(DataController*)sharedInstanceWithCallback:(InitCallbackBlock)callback;
+(DataController*)sharedInstance;

-(void)save;

-(Training*)createTrainingWithData:(NSDictionary*)data;
-(void)updateTraining:(Training *)t withData:(NSDictionary*)data;
-(BOOL)deleteTraining:(Training*)t;
-(NSArray*)getOwnTrainings;
-(NSArray*)getForeignTrainings;
-(NSArray*)getAllTrainings;

-(void)addExercise:(Exercise*)e toTraining:(Training*)t;
-(void)removeExercise:(Exercise*)e fromTraining:(Training*)t;

-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t;
-(Exercise*)createReturnExerciseWithData:(NSDictionary *)data forTraining:(Training*)t;
-(void)updateExercise:(Exercise *)e ID:(NSInteger)exerciseID;
-(NSArray*)getExercisesForTraining:(Training*)t;
-(NSArray*)getAllExercises;
-(NSArray*)getAllSharedExercises;
-(NSArray*)getAllExercisesNotInTraining:(Training*)t;

-(TrainingProtocol*)createProtocolForTraining:(Training*)training;
-(void)updateProtocol:(TrainingProtocol *)p withData:(NSDictionary*)data;
-(NSArray*)getRecentProtocols;

-(ExerciseProtocol*)createExProtocolForTrainingProtocol:(TrainingProtocol*)tp andExercise:(Exercise*)e;
-(ExerciseProtocol*)getExProtocolForTrainingProtocol:(TrainingProtocol*)tp andExercise:(Exercise*)e;


@end
