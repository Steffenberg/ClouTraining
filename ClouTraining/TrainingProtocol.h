//
//  TrainingProtocol.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, ExerciseProtocol, Training;

@interface TrainingProtocol : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) Training *training;
@property (nonatomic, retain) NSSet *exerciseProtocols;
@end

@interface TrainingProtocol (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

- (void)addExerciseProtocolsObject:(ExerciseProtocol *)value;
- (void)removeExerciseProtocolsObject:(ExerciseProtocol *)value;
- (void)addExerciseProtocols:(NSSet *)values;
- (void)removeExerciseProtocols:(NSSet *)values;

@end
