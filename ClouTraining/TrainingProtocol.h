//
//  TrainingProtocol.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 22.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseProtocol, Training;

@interface TrainingProtocol : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSSet *exerciseProtocols;
@property (nonatomic, retain) Training *training;
@end

@interface TrainingProtocol (CoreDataGeneratedAccessors)

- (void)addExerciseProtocolsObject:(ExerciseProtocol *)value;
- (void)removeExerciseProtocolsObject:(ExerciseProtocol *)value;
- (void)addExerciseProtocols:(NSSet *)values;
- (void)removeExerciseProtocols:(NSSet *)values;

@end
