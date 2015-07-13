//
//  Exercise.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseProtocol, Media, Training;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSNumber * exerciseid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) NSNumber * maxWeight;
@property (nonatomic, retain) NSSet *medias;
@property (nonatomic, retain) NSSet *trainings;
@property (nonatomic, retain) NSSet *protocols;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addMediasObject:(Media *)value;
- (void)removeMediasObject:(Media *)value;
- (void)addMedias:(NSSet *)values;
- (void)removeMedias:(NSSet *)values;

- (void)addTrainingsObject:(Training *)value;
- (void)removeTrainingsObject:(Training *)value;
- (void)addTrainings:(NSSet *)values;
- (void)removeTrainings:(NSSet *)values;

- (void)addSetsObject:(NSManagedObject *)value;
- (void)removeSetsObject:(NSManagedObject *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

- (void)addProtocolsObject:(ExerciseProtocol *)value;
- (void)removeProtocolsObject:(ExerciseProtocol *)value;
- (void)addProtocols:(NSSet *)values;
- (void)removeProtocols:(NSSet *)values;

@end
