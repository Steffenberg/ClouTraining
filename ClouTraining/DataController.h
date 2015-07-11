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

@class Training, Exercise, Media, Set, Entry,TrainingProtocol;

@interface DataController : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;

@property (strong) NSManagedObjectContext *privateContext;

+(DataController*)sharedInstanceWithCallback:(InitCallbackBlock)callback;
+(DataController*)sharedInstance;

-(void)save;

-(Training*)createTrainingWithData:(NSDictionary*)data;
-(void)updateTraining:(Training *)t withData:(NSDictionary*)data;
-(BOOL)deleteTraining:(Training*)t;
-(void)addExercise:(Exercise*)e toTraining:(Training*)t;
-(NSArray*)getOwnTrainings;
-(NSArray*)getForeignTrainings;
-(NSArray*)getAllTrainings;
-(NSArray*)getRecentTrainings;

-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t;
-(Exercise*)createReturnExerciseWithData:(NSDictionary *)data forTraining:(Training*)t;
-(NSArray*)getExercisesForTraining:(Training*)t;

-(void)createSets:(NSArray *)sets forExercise:(Exercise*)e;
-(BOOL)deleteSet:(Set*)s;
-(NSArray*)getSetsForExercise:(Exercise*)e;

-(TrainingProtocol*)createProtocolForTraining:(Training*)training;
-(void)updateProtocol:(TrainingProtocol *)p withData:(NSDictionary*)data;
-(NSArray*)getRecentProtocols;

-(Entry*)createEntry:(NSDictionary*)data forProtocol:(TrainingProtocol*)protocol andSet:(Set*)set;
-(void)updateEntry:(Entry *)e withData:(NSDictionary*)data;
@end
