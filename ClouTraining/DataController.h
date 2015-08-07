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

-(void)createExerciseWithData:(NSDictionary *)data;
-(Exercise*)createReturnExerciseWithData:(NSDictionary *)data;
-(Exercise*)createReturnExerciseWithExtData:(NSDictionary *)data;
-(void)createExerciseWithExtData:(NSDictionary *)data;
-(void)createExerciseWithLoginData:(NSDictionary *)data;

-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t;
-(Exercise*)createReturnExerciseWithData:(NSDictionary *)data forTraining:(Training*)t;
-(void)updateExercise:(Exercise *)e;
-(void)updateExercise:(Exercise *)e ID:(NSInteger)exerciseID;
-(void)deleteExercise:(Exercise*)e;
-(NSArray*)getExercisesForTraining:(Training*)t;
-(NSArray*)getAllExercises;
-(NSArray*)getAllSharedExercises;
-(NSArray*)getAllOwnExercises;
-(NSArray*)getAllExercisesNotInTraining:(Training*)t;
-(BOOL)hasExerciseForID:(NSNumber*)exerciseID own:(BOOL)own;

-(TrainingProtocol*)createProtocolForTraining:(Training*)training;
-(void)updateProtocol:(TrainingProtocol *)p withData:(NSDictionary*)data;
-(NSArray*)getRecentProtocols;

-(ExerciseProtocol*)createExProtocolForTrainingProtocol:(TrainingProtocol*)tp andExercise:(Exercise*)e;
-(ExerciseProtocol*)getExProtocolForTrainingProtocol:(TrainingProtocol*)tp andExercise:(Exercise*)e;

-(SetEntry*)createSetEntryForExProtocol:(ExerciseProtocol*)exp withNumber:(NSInteger)number;
-(void)updateSetEntry:(SetEntry*)e withData:(NSDictionary*)data;
-(NSArray*)getSetEntriesForExProtocol:(ExerciseProtocol*)exp;



@end
