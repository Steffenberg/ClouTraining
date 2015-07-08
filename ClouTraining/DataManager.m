//
//  DataManager.m
//  Fitmeter
//
//  Created by Steffen Gruschka on 23.12.14.
//  Copyright (c) 2014 Steffen Gruschka. All rights reserved.
//

#import "DataManager.h"
#import "NSManagedObjectContext-EasyFetch.h"

@implementation DataManager

#pragma mark - Singleton creation

+(DataManager*)sharedInstance{
    static DataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc]init];
        [instance initializeCoreData];
    });
    return instance;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "de.private.asfdghjzguh" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)initializeCoreData{
    if ([self managedObjectContext]) return;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Fitmeter" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fitmeter.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    
    [self setPrivateContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
    [[self privateContext] setPersistentStoreCoordinator:coordinator];
    [[self managedObjectContext] setParentContext:[self privateContext]];
    
}

- (void)save{
    if (![[self privateContext] hasChanges] && ![[self managedObjectContext] hasChanges]) return;
    
    [[self managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        
        ZAssert([[self managedObjectContext] save:&error], @"Failed to save main context: %@\n%@", [error localizedDescription], [error userInfo]);
        
        [[self privateContext] performBlockAndWait:^{
            NSError *privateError = nil;
            ZAssert([[self privateContext] save:&privateError], @"Error saving private context: %@\n%@", [privateError localizedDescription], [privateError userInfo]);
        }];
    }];
}

#pragma mark - Training

-(Training*)createTraining{
    
    __block Training *training;
        [[self privateContext]performBlockAndWait:^{
        
            training = [NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:[self privateContext]];
            NSInteger randomid = [self generateRandomNumberWithlowerBound:999999 upperBound:9999999];
            training.trainingID = [NSNumber numberWithInteger:randomid];
            training.date = [NSDate date];
            training.comment = @"";
            training.sportsType = @"";
            training.mood = [NSNumber numberWithBool:YES];
            training.duration = [NSNumber numberWithInteger:0];
            training.maxPulse = [NSNumber numberWithInteger:[ZoneCalculator getMaxFrquency]];
            training.uploaded = [NSNumber numberWithBool:NO];
            training.kcal = [NSNumber numberWithInteger:0];
            training.participants = [NSNumber numberWithInteger:0];
            
            
            [self save];
            
            
        }];
        
    return training;

}

-(Training*)updateTraining:(Training*)training{
    NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"trainingID" ascending:YES predicateWithFormat:@"trainingID = %@",training.trainingID];
    
    if(fetchedTrainings.count == 1){
        Training *tmp = [fetchedTrainings lastObject];
        tmp.duration = training.duration;
        tmp.date = training.date;
        tmp.comment = training.comment;
        tmp.sportsType = training.sportsType;
        tmp.distance = training.distance;
        tmp.maxPulse = training.maxPulse;
        tmp.mood = training.mood;
        tmp.uploaded = training.uploaded;
        tmp.kcal = training.kcal;
        tmp.participants = training.participants;
        
        [self save];
        return tmp;
        
    }
    
    return nil;
}

-(BOOL)deleteTraining:(Training*)training{
    NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"trainingID" ascending:YES predicateWithFormat:@"trainingID = %@",training.trainingID];
    
    if(fetchedTrainings.count ==1){
        [[self managedObjectContext]deleteObject:[fetchedTrainings lastObject]];
        [self save];
        return YES;
    }
    
    return NO;
}

-(BOOL)deleteOldestTraining{
    NSArray *trainings = [self getAllTrainings];
    if([self deleteTraining:[trainings lastObject]]){
        return YES;
    }
    return NO;
    
}



-(void)updateDuration:(NSInteger)duration forTraining:(Training*)training{
    NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"trainingID" ascending:YES predicateWithFormat:@"trainingID = %@",training.trainingID];
    
    if(fetchedTrainings.count == 1){
        Training *tmp = [fetchedTrainings lastObject];
        tmp.duration = [NSNumber numberWithInteger:duration];
        
        [self save];
    }
    
}

-(void)setUploadedForTraining:(Training*)training{
    
    
        NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"trainingID" ascending:YES predicateWithFormat:@"trainingID = %@",training.trainingID];
        
        if(fetchedTrainings.count == 1){
            Training *tmp = [fetchedTrainings lastObject];
            tmp.uploaded = [NSNumber numberWithBool:YES];
            
            [self save];
        }
    
    
    
}
-(Training*)getTrainingForID:(NSNumber*)trainingID{
    NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"trainingID" ascending:YES predicateWithFormat:@"trainingID = %@",trainingID];
    
    if(fetchedTrainings.count == 1){
        return [fetchedTrainings lastObject];
    }
    
    return nil;
   
}

//return a sorted array of all calendars in database
-(NSArray*)getAllTrainings{
    NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"date" ascending:NO];
    
    return fetchedTrainings;
}

-(NSInteger)getCountForTrainings{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Training" inManagedObjectContext:[self managedObjectContext]]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [[self managedObjectContext] countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    }
    
    return count;
}

#pragma mark -
#pragma mark Pulse Measure Points
//EVENTUELL COMPLETITION BLOCK EINFÜGEN!
-(void)insertMeasurePointToDB:(NSDictionary *)point forTraining:(Training*)training{
    
    
        NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"trainingID" ascending:YES predicateWithFormat:@"trainingID = %@",training.trainingID];
        
        if(fetchedTrainings.count == 1){
            Training *training = [fetchedTrainings lastObject];
            
            PulseMeasurePoint *measurePoint = [NSEntityDescription insertNewObjectForEntityForName:@"PulseMeasurePoint" inManagedObjectContext:[self managedObjectContext]];
            NSInteger randomid = [self generateRandomNumberWithlowerBound:999999 upperBound:999999999];
            measurePoint.pointID = [NSNumber numberWithInteger:randomid];
            measurePoint.timestamp = [point objectForKey:@"timestamp"];
            measurePoint.pulseValue = [point objectForKey:@"pulseValue"];
            measurePoint.zoneType = [point objectForKey:@"zoneType"];
            
            measurePoint.parent = training;
            [training addMeasurePointObject:measurePoint];
            
            [self save];
        }
    
    
}

-(void)insertMeasurePointToDBAsync:(NSDictionary *)point forTraining:(Training*)training{
    
    [[self privateContext] performBlock:^{
            NSArray *fetchedTrainings = [[self privateContext] fetchObjectsForEntityName:@"Training" sortByKey:@"trainingID" ascending:YES predicateWithFormat:@"trainingID = %@",training.trainingID];
            
            if(fetchedTrainings.count == 1){
                Training *training = [fetchedTrainings lastObject];
            
            PulseMeasurePoint *measurePoint = [NSEntityDescription insertNewObjectForEntityForName:@"PulseMeasurePoint" inManagedObjectContext:[self privateContext]];
            NSInteger randomid = [self generateRandomNumberWithlowerBound:999999 upperBound:999999999];
            measurePoint.pointID = [NSNumber numberWithInteger:randomid];
            measurePoint.timestamp = [point objectForKey:@"timestamp"];
            measurePoint.pulseValue = [point objectForKey:@"pulseValue"];
            measurePoint.zoneType = [point objectForKey:@"zoneType"];
            
            measurePoint.parent = training;
            [training addMeasurePointObject:measurePoint];
            
            [self save];
        }
    }];
}


-(BOOL)deletePMP:(PulseMeasurePoint*)pmp{
    
    NSArray *fetchedObjects = [[self managedObjectContext] fetchObjectsForEntityName:@"PulseMeasurePoint" sortByKey:@"timestamp" ascending:YES predicateWithFormat:@"(pointID == %@)",pmp.pointID];
    
    if(fetchedObjects.count == 1){
        [[self managedObjectContext] deleteObject:pmp];
        [self save];
        return YES;
    }
    return NO;
}


//returns an appointment for a given ID in a given timeline
-(NSArray*)getMeasurePointsForTraining:(Training*)training{
  
    NSArray *fetchedObjects = [[self managedObjectContext] fetchObjectsForEntityName:@"PulseMeasurePoint" sortByKey:@"timestamp" ascending:YES predicateWithFormat:@"(parent.trainingID == %@)",training.trainingID];
    
    return fetchedObjects;
    
    
}

-(NSArray*)getAllMeasurePoints{
    
    NSArray *fetchedObjects = [[self managedObjectContext] fetchObjectsForEntityName:@"PulseMeasurePoint" sortByKey:@"timestamp" ascending:YES];
    
    return fetchedObjects;
}


#pragma mark -
#pragma mark Trainers

-(NSArray*)getAllTrainer{
    NSArray *fetchedObjects = [[self managedObjectContext] fetchObjectsForEntityName:@"Trainer" sortByKey:@"trainerID" ascending:NO];
    
    return fetchedObjects;
}

-(void)createTrainerFromComponents:(NSArray*)components completition:(ObjectReturnBlock)block{
    
    
    [[self privateContext]performBlockAndWait:^{
        if(components.count == 4){
            if(![self hasTrainer:[components objectAtIndex:3]]){
                Trainer *trainer = [NSEntityDescription insertNewObjectForEntityForName:@"Trainer" inManagedObjectContext:[self privateContext]];
                trainer.trainerID = [NSNumber numberWithInteger:[[components objectAtIndex:0]integerValue]];
                trainer.name = [NSString stringWithFormat:@"%@ %@",[components objectAtIndex:1],[components objectAtIndex:2]];
                trainer.email = [components objectAtIndex:3];
                
                [self save];
                block(trainer);
            }
        }
        block(nil);
    }];
  
    
    
}

-(BOOL)deleteTrainer:(Trainer*)trainer{
    
    NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"Trainer" sortByKey:@"trainerID" ascending:YES predicateWithFormat:@"trainerID = %@",trainer.trainerID];
    
    if(fetchedTrainings.count == 1){
        [[self managedObjectContext]deleteObject:[fetchedTrainings lastObject]];
        [self save];
        return YES;
    }
    
    return NO;

   
}

-(BOOL)hasTrainer:(NSString*)nickname{
    NSArray *fetchedObjects = [[self managedObjectContext] fetchObjectsForEntityName:@"Trainer" sortByKey:@"trainerID" ascending:NO predicateWithFormat:@"(email == %@)",nickname];
    
    if(fetchedObjects.count > 0){
        return YES;
    }else{
        return NO;
    }
    
}

-(NSInteger)getCountForTrainers{
    
    return [self getAllTrainer].count;
}


#pragma mark -
#pragma mark pre-assembled Trainings

-(PreassembledTraining*)createPreAssembledTraining:(NSString*)title duration:(NSInteger)duration{
    if([self hasPreTraining:title]){
        return nil;
    }
    
    __block PreassembledTraining *training;
    [[self privateContext]performBlockAndWait:^{
        training = [NSEntityDescription insertNewObjectForEntityForName:@"PreassembledTraining" inManagedObjectContext:[self privateContext]];
        NSInteger randomid = [self generateRandomNumberWithlowerBound:999999 upperBound:9999999];
        training.preTrainingID = [NSNumber numberWithInteger:randomid];
        training.title = title;
        training.isPattern = [NSNumber numberWithBool:NO];
        training.duration = [NSNumber numberWithInteger:duration];
        
        [self save];
    }];
    
    return training;
    
}

-(BOOL)deletePreTraining:(PreassembledTraining*)training{
    NSArray *fetchedTrainings = [[self managedObjectContext] fetchObjectsForEntityName:@"PreassembledTraining" sortByKey:@"title" ascending:YES predicateWithFormat:@"preTrainingID = %@",training.preTrainingID];
    
    if(fetchedTrainings.count ==1){
        [[self managedObjectContext]deleteObject:[fetchedTrainings lastObject]];
        [self save];
        return YES;
    }
    
    return NO;
}

-(void)deletePatternPreTrainings{
    NSArray *patternTrainings = [self getPatternPreTrainings];
    for(PreassembledTraining *training in patternTrainings){
        [self deletePreTraining:training];
    }
}


-(NSArray*)getAllPreTrainings{
    
    NSArray *fetchedObjects = [[self managedObjectContext]fetchObjectsForEntityName:@"PreassembledTraining" sortByKey:@"title" ascending:YES predicateWithFormat:@"isPattern == 0"];
    
    return fetchedObjects;
}


-(NSArray*)getFavPreTrainings{
    NSArray *fetchedObjects = [[self managedObjectContext]fetchObjectsForEntityName:@"PreassembledTraining" sortByKey:@"title" ascending:YES predicateWithFormat:@"isFavorite == 1"];
    
    return fetchedObjects;
}

-(void)addPreTrainingToFavorites:(PreassembledTraining*)training{
    NSArray *fetchedTrainings = [[self managedObjectContext]fetchObjectsForEntityName:@"PreassembledTraining" sortByKey:@"title" ascending:YES predicateWithFormat:@"preTrainingID == %@", training.preTrainingID];
    

    if(fetchedTrainings.count == 1){
        PreassembledTraining *tmp = [fetchedTrainings lastObject];
        tmp.isFavorite = training.isFavorite;
        
        [self save];
    }
    
}


-(NSArray*)getPatternPreTrainings{
    NSArray *fetchedObjects = [[self managedObjectContext]fetchObjectsForEntityName:@"PreassembledTraining" sortByKey:@"title" ascending:YES predicateWithFormat:@"isPattern == 1"];
    
    return fetchedObjects;
}

-(PreassembledTraining*)createPreAssembledTrainingAsPattern:(NSString*)title duration:(NSInteger)duration{
    if([self hasPreTraining:title]){
        return nil;
    }
    
    __block PreassembledTraining *training;
    [[self privateContext]performBlockAndWait:^{
        training = [NSEntityDescription insertNewObjectForEntityForName:@"PreassembledTraining" inManagedObjectContext:[self privateContext]];
        NSInteger randomid = [self generateRandomNumberWithlowerBound:999999 upperBound:9999999];
        training.preTrainingID = [NSNumber numberWithInteger:randomid];
        training.title = title;
        training.isPattern = [NSNumber numberWithBool:YES];
        training.duration = [NSNumber numberWithInteger:duration];
        
        [self save];
    }];
    
    return training;
    
}

-(BOOL)hasPreTraining:(NSString*)title{
    
    NSArray *fetchedObjects = [[self managedObjectContext]fetchObjectsForEntityName:@"PreassembledTraining" predicateWithFormat:@"title == %@",title];
    
    if(fetchedObjects.count > 0){
        return YES;
    }else{
        return NO;
    }
    
}

-(void)insertMeasurePointToDB:(NSDictionary *)point forPreTraining:(PreassembledTraining*)training isInSeconds:(BOOL)isInSeconds{
    
    
    
        NSArray *fetchedTrainings = [[self managedObjectContext]fetchObjectsForEntityName:@"PreassembledTraining" sortByKey:@"title" ascending:YES predicateWithFormat:@"preTrainingID == %@", training.preTrainingID];
    
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
    
        if(fetchedTrainings.count == 1){
            PreassembledTraining *training = [fetchedTrainings lastObject];
            
            PulseMeasurePoint *measurePoint = [NSEntityDescription insertNewObjectForEntityForName:@"PulseMeasurePoint" inManagedObjectContext:[self managedObjectContext]];
            NSInteger randomid = [self generateRandomNumberWithlowerBound:999999 upperBound:999999999];
            measurePoint.pointID = [NSNumber numberWithInteger:randomid];
            if(isInSeconds){
                measurePoint.timestamp = [f numberFromString:[point objectForKey:@"timestamp"]];
            }else{
                NSInteger recalc = [[f numberFromString:[point objectForKey:@"timestamp"]]integerValue];
                recalc = recalc *60;
                measurePoint.timestamp = [NSNumber numberWithInteger:recalc];
            }
            
            measurePoint.pulseValue = [NSNumber numberWithInt:0];
            measurePoint.zoneType = [f numberFromString:[point objectForKey:@"zoneType"]];
            
            measurePoint.preParent = training;
            [training addMeasurePointObject:measurePoint];
            
            [self save];
            
        }
    
    
   

}

-(NSArray*)getMeasurePointsForPreTraining:(PreassembledTraining*)training{
    NSArray *fetchedObjects = [[self managedObjectContext]fetchObjectsForEntityName:@"PulseMeasurePoint" sortByKey:@"timestamp" ascending:YES predicateWithFormat:@"(preParent.preTrainingID == %@)",training.preTrainingID];
    
    return fetchedObjects;
    
    
}
#pragma mark -
#pragma mark Utility

//resets Complete local database
-(void)rollBackForRelog{
    NSArray *trainings = [self getAllTrainings];
    for(Training *training in trainings){
        [self deleteTraining:training];
    }
    NSArray *trainers = [self getAllTrainer];
    for(Trainer *trainer in trainers){
        [self deleteTrainer:trainer];
    }
    NSArray *patternTrainings = [self getPatternPreTrainings];
    for(PreassembledTraining *training in patternTrainings){
        [self deletePreTraining:training];
    }
}



//access app delegate to get context
- (AppDelegate *)appDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
-(NSInteger) generateRandomNumberWithlowerBound:(NSInteger)lowerBound
                                     upperBound:(NSInteger)upperBound
{
    NSInteger rendem = (arc4random() % upperBound)+lowerBound;
    return rendem;
}

@end
