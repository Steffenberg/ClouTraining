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

-(void)createTrainingWithName:(NSString *)name andDescription:(NSString*)desc completition:(ObjectReturnBlock)block{
    
    if([[self privateContext]fetchObjectsForEntityName:@"Training" predicateWithFormat:@"name = %@",name].count <1){
        
        
        [[self privateContext]performBlock:^{
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Training" inManagedObjectContext:[self privateContext]];
            
            Training *t = [[Training alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:[self privateContext]];
            [t setName:name];
            [t setDescribe:desc];
            [t setOwn:[NSNumber numberWithBool:YES]];
            
            [[self privateContext] insertObject:t];
            [self save];
            
            block(t);
        }];
        
    }
    
    block(nil);

    
}

-(void)addExercise:(Exercise*)e toTraining:(Training*)t{

        [t addExerciseObject:e];
        [e setTraining:t];
        [self save];
    
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

#pragma mark - Exercises

-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t{
    
    NSString *name = [data objectForKey:@"name"];
    
    if([[self privateContext]fetchObjectsForEntityName:@"Exercise" predicateWithFormat:@"name = %@",name].count <1){
        
        
        [[self privateContext]performBlock:^{
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:[self privateContext]];
            
            Exercise *e = [[Exercise alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:[self privateContext]];
            e.name = name;
            e.describe = [data objectForKey:@"describe"];
            e.distance = [data objectForKey:@"distance"];
            e.duration = [data objectForKey:@"duration"];
            e.repititions = [data objectForKey:@"repititions"];
            e.sets = [data objectForKey:@"sets"];
            e.shared = [data objectForKey:@"shared"];
            e.weight = [data objectForKey:@"weight"];
            
            [e setTraining:t];
            [t addExerciseObject:e];
            
            [[self privateContext] insertObject:e];
            [self save];
            
        }];
        
    }
    
    
    
}
-(void)createExerciseWithData:(NSDictionary *)data forTraining:(Training*)t completition:(ObjectReturnBlock)block{
    
    NSString *name = [data objectForKey:@"name"];
    
    if([[self privateContext]fetchObjectsForEntityName:@"Exercise" predicateWithFormat:@"name = %@",name].count <1){
        
        
        [[self privateContext]performBlock:^{
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:[self privateContext]];
            
            Exercise *e = [[Exercise alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:[self privateContext]];
            e.name = name;
            e.describe = [data objectForKey:@"describe"];
            e.distance = [data objectForKey:@"distance"];
            e.duration = [data objectForKey:@"duration"];
            e.repititions = [data objectForKey:@"repititions"];
            e.sets = [data objectForKey:@"sets"];
            e.shared = [data objectForKey:@"shared"];
            e.weight = [data objectForKey:@"weight"];
            
            [e setTraining:t];
            [t addExerciseObject:e];
            
            [[self privateContext] insertObject:e];
            [self save];
            
            block(e);
            
        }];
        
    }
    block(nil);
    
    
    
}

-(NSArray*)getExercisesForTraining:(Training*)t{
    return [[self managedObjectContext] fetchObjectsForEntityName:@"Exercise" sortByKey:@"name"ascending:YES predicateWithFormat:@"training=%@",t];
}

#pragma mark - Media




@end
