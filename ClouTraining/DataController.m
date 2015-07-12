//
//  DataController.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 06.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "DataController.h"
#import "AppDelegate.h"
#import "NSManagedObjectContext-EasyFetch.h"
#import "Training.h"
#import "Exercise.h"
#import "Media.h"
#import "TrainingProtocol.h"
#import "SetEntry.h"

@interface DataController()




@property (copy) InitCallbackBlock initCallback;

-(void)initializeCoreData;

@end

@implementation DataController


+(DataController*)sharedInstanceWithCallback:(InitCallbackBlock)callback{
    static DataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataController alloc]init];
        [sharedInstance setInitCallback:callback];
        [sharedInstance initializeCoreData];
    });
    return sharedInstance;
}

+(DataController*)sharedInstance{
    static DataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataController alloc]init];
        [sharedInstance initializeCoreData];
    });
    return sharedInstance;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "de.private.asfdghjzguh" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)initializeCoreData{
    if ([self managedObjectContext]) return;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ClouTraining" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ClouTraining.sqlite"];
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


#pragma mark - Trainings

-(Training*)createTrainingWithData:(NSDictionary*)data{
    
    if([[self privateContext]fetchObjectsForEntityName:@"Training" predicateWithFormat:@"name = %@",[data objectForKey:@"name"]].count <1){
        
        __block Training *t;
        [[self privateContext]performBlockAndWait:^{
            
            t = [NSEntityDescription insertNewObjectForEntityForName:@"Training" inManagedObjectContext:[self privateContext]];
            [t setName:[data objectForKey:@"name"]];
            [t setDescribe:[data objectForKey:@"describe"]];
            [t setOwn:[data objectForKey:@"own"]];
            
            [self save];
            
            
        }];
        
        return t;
    }
    
    return nil;

    
}

-(void)updateTraining:(Training *)t withData:(NSDictionary*)data{
    Training *training = (Training*)[[self managedObjectContext]existingObjectWithID:t.objectID error:nil];
    [training setName:[data objectForKey:@"name"]];
    [training setDescribe:[data objectForKey:@"describe"]];
    [self save];
}

-(BOOL)deleteTraining:(Training*)t{
    Training *training = (Training*)[[self managedObjectContext]existingObjectWithID:t.objectID error:nil];
    if(training){
        [[self managedObjectContext]deleteObject:training];
        [self save];
        return YES;
    }
    return NO;
}

-(NSArray*)getOwnTrainings{
    return [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"name" ascending:YES predicateWithFormat:@"own = 1"];
}

-(NSArray*)getForeignTrainings{
    return [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"name" ascending:YES predicateWithFormat:@"own = 0"];
}

-(NSArray*)getAllTrainings{
    return [[self managedObjectContext] fetchObjectsForEntityName:@"Training" sortByKey:@"name" ascending:YES];
}

#pragma mark - Exercises <-> Training

-(void)addExercise:(Exercise *)e toTraining:(Training *)t{
    Exercise *exercise = (Exercise*)[[self managedObjectContext]existingObjectWithID:e.objectID error:nil];
    Training *training = (Training*)[[self managedObjectContext]existingObjectWithID:t.objectID error:nil];
    
    [exercise addTrainingsObject:training];
    [training addExercisesObject:e];
    
    [self save];
}

-(void)removeExercise:(Exercise*)e fromTraining:(Training*)t{
    Exercise *exercise = (Exercise*)[[self managedObjectContext]existingObjectWithID:e.objectID error:nil];
    Training *training = (Training*)[[self managedObjectContext]existingObjectWithID:t.objectID error:nil];
    
    [exercise removeTrainingsObject:training];
    [training removeExercisesObject:exercise];
    
    [self save];
}

#pragma mark - Exercises

-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t{
    
        [[self privateContext]performBlockAndWait:^{
            
             Training *training = (Training*)[[self privateContext]existingObjectWithID:t.objectID error:nil];
            
            Exercise *e = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:[self privateContext]];
            e.name = [data objectForKey:@"name"];
            e.describe = [data objectForKey:@"describe"];
            e.shared = [data objectForKey:@"shared"];
            
            [e addTrainingsObject:training];
            [training addExercisesObject:e];
            [self save];
            
        }];
        
    
    
    
    
}


-(Exercise*)createReturnExerciseWithData:(NSDictionary *)data forTraining:(Training*)t{
    
    __block Exercise *e;
        [[self privateContext]performBlockAndWait:^{
            
            Training *training = (Training*)[[self privateContext]existingObjectWithID:t.objectID error:nil];
            
            e = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:[self privateContext]];
            e.name = [data objectForKey:@"name"];
            e.describe = [data objectForKey:@"describe"];
            e.shared = [data objectForKey:@"shared"];
            
            [training addExercisesObject:e];
            [e addTrainingsObject:training];
            
            [self save];
            
        }];
        
    
    return e;
}


-(NSArray*)getExercisesForTraining:(Training*)t{
    Training *training = (Training*)[[self privateContext]existingObjectWithID:t.objectID error:nil];
    return [training.exercises sortedArrayUsingDescriptors:nil];
}

-(NSArray*)getAllExercises{
    return [[self managedObjectContext] fetchObjectsForEntityName:@"Exercise" sortByKey:@"name"ascending:YES];
}

-(NSArray*)getAllSharedExercises{
    return [[self managedObjectContext] fetchObjectsForEntityName:@"Exercise" sortByKey:@"name"ascending:YES predicateWithFormat:@"shared = 1"];
}

-(NSArray*)getAllExercisesNotInTraining:(Training*)t{
    NSArray *exercises = [self getAllExercises];
    NSMutableArray *result = [NSMutableArray array];
    for (Exercise *e in exercises){
        BOOL found = NO;
        for(Training *tmp in e.trainings){
            if(tmp.objectID == t.objectID){
                found = YES;
                break;
            }
        }
        if(!found){
            [result addObject:e];
        }
    }
    return result;
}


#pragma mark - TrainingProtocol

-(TrainingProtocol*)createProtocolForTraining:(Training*)training{
    
    __block TrainingProtocol *protocol;
    [[self privateContext]performBlockAndWait:^{
        
        Training *tmp = (Training*)[[self privateContext]existingObjectWithID:training.objectID error:nil];
        
        protocol = [NSEntityDescription insertNewObjectForEntityForName:@"TrainingProtocol" inManagedObjectContext:[self privateContext]];
        protocol.date = [NSDate date];
        protocol.comment = @"";
        protocol.duration = [NSNumber numberWithInteger:0];
        
        [protocol setTraining:tmp];
        [tmp addProtocolsObject:protocol];
        
        [self save];
        
        
    }];
    
    return protocol;
}

-(void)updateProtocol:(TrainingProtocol *)p withData:(NSDictionary*)data{
    TrainingProtocol *protocol = (TrainingProtocol*)[[self managedObjectContext]existingObjectWithID:p.objectID error:nil];
    protocol.date = [NSDate date];
    protocol.comment = [data objectForKey:@"comment"];
    protocol.duration = [data objectForKey:@"duration"];
    [self save];
}

-(NSArray*)getRecentProtocols{
    return [[self managedObjectContext] fetchObjectsForEntityName:@"TrainingProtocol" sortByKey:@"date" ascending:NO predicateWithFormat:@"date>=%@", [NSDate dateWithTimeIntervalSinceNow:-(30*24*60*60)]];
}



#pragma mark - Media




@end
