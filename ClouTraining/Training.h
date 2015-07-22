//
//  Training.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 22.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, TrainingProtocol;

@interface Training : NSManagedObject

@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * own;
@property (nonatomic, retain) NSNumber * trainingid;
@property (nonatomic, retain) NSSet *exercises;
@property (nonatomic, retain) NSSet *protocols;
@end

@interface Training (CoreDataGeneratedAccessors)

- (void)addExercisesObject:(Exercise *)value;
- (void)removeExercisesObject:(Exercise *)value;
- (void)addExercises:(NSSet *)values;
- (void)removeExercises:(NSSet *)values;

- (void)addProtocolsObject:(TrainingProtocol *)value;
- (void)removeProtocolsObject:(TrainingProtocol *)value;
- (void)addProtocols:(NSSet *)values;
- (void)removeProtocols:(NSSet *)values;

@end
