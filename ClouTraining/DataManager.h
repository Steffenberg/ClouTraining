//
//  DataManager.h
//  Fitmeter
//
//  Created by Steffen Gruschka on 23.12.14.
//  Copyright (c) 2014 Steffen Gruschka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ObjectReturnBlock)(id);

@class Training, Trainer, PreassembledTraining;

@interface DataManager : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong) NSManagedObjectContext *privateContext;
-(void)save;

+(DataManager *)sharedInstance;

-(Training*)createTraining;
-(Training*)updateTraining:(Training*)training;
-(BOOL)deleteTraining:(Training*)training;
-(BOOL)deleteOldestTraining;
-(void)setUploadedForTraining:(Training*)training;
-(Training*)getTrainingForID:(NSNumber*)trainingID;
-(NSArray*)getAllTrainings;
-(NSInteger)getCountForTrainings;

-(NSArray*)getMeasurePointsForTraining:(Training*)training;
-(void)insertMeasurePointToDB:(NSDictionary *)point forTraining:(Training*)training;
-(void)insertMeasurePointToDBAsync:(NSDictionary *)point forTraining:(Training*)training;
-(void)updateDuration:(NSInteger)duration forTraining:(Training*)training;

-(NSArray*)getAllTrainer;
-(void)createTrainerFromComponents:(NSArray*)components completition:(ObjectReturnBlock)block;
-(BOOL)deleteTrainer:(Trainer*)trainer;
-(NSInteger)getCountForTrainers;

-(PreassembledTraining*)createPreAssembledTraining:(NSString*)title duration:(NSInteger)duration;
-(void)deletePatternPreTrainings;
-(NSArray*)getAllPreTrainings;
-(NSArray*)getFavPreTrainings;
-(void)addPreTrainingToFavorites:(PreassembledTraining*)training;
-(NSArray*)getPatternPreTrainings;
-(PreassembledTraining*)createPreAssembledTrainingAsPattern:(NSString*)title duration:(NSInteger)duration;
-(void)insertMeasurePointToDB:(NSDictionary *)point forPreTraining:(PreassembledTraining*)training isInSeconds:(BOOL)isInSeconds;
-(NSArray*)getMeasurePointsForPreTraining:(PreassembledTraining*)training;

-(void)rollBackForRelog;
@end
