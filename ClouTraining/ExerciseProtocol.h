//
//  ExerciseProtocol.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 22.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, SetEntry, TrainingProtocol;

@interface ExerciseProtocol : NSManagedObject

@property (nonatomic, retain) Exercise *exercise;
@property (nonatomic, retain) TrainingProtocol *protocol;
@property (nonatomic, retain) NSSet *setEntries;
@end

@interface ExerciseProtocol (CoreDataGeneratedAccessors)

- (void)addSetEntriesObject:(SetEntry *)value;
- (void)removeSetEntriesObject:(SetEntry *)value;
- (void)addSetEntries:(NSSet *)values;
- (void)removeSetEntries:(NSSet *)values;

@end
