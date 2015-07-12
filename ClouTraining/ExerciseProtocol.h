//
//  ExerciseProtocol.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 12.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, Exercise, TrainingProtocol;

@interface ExerciseProtocol : NSManagedObject

@property (nonatomic, retain) NSSet *setEntries;
@property (nonatomic, retain) Exercise *exercise;
@property (nonatomic, retain) TrainingProtocol *protocol;
@end

@interface ExerciseProtocol (CoreDataGeneratedAccessors)

- (void)addSetEntriesObject:(Entry *)value;
- (void)removeSetEntriesObject:(Entry *)value;
- (void)addSetEntries:(NSSet *)values;
- (void)removeSetEntries:(NSSet *)values;

@end
