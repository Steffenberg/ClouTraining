//
//  Training.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
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
@property (nonatomic, retain) NSSet *protocols;
@property (nonatomic, retain) NSSet *exercises;
@end

@interface Training (CoreDataGeneratedAccessors)

- (void)addProtocolsObject:(TrainingProtocol *)value;
- (void)removeProtocolsObject:(TrainingProtocol *)value;
- (void)addProtocols:(NSSet *)values;
- (void)removeProtocols:(NSSet *)values;

- (void)addExercisesObject:(Exercise *)value;
- (void)removeExercisesObject:(Exercise *)value;
- (void)addExercises:(NSSet *)values;
- (void)removeExercises:(NSSet *)values;

@end
