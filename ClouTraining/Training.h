//
//  Training.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 06.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise;

@interface Training : NSManagedObject

@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * publicate;
@property (nonatomic, retain) NSNumber * trainingid;
@property (nonatomic, retain) NSSet *exercise;
@property (nonatomic, retain) NSNumber *own;
@property (nonatomic, retain) NSDate *lastUsed;
@end

@interface Training (CoreDataGeneratedAccessors)

- (void)addExerciseObject:(Exercise *)value;
- (void)removeExerciseObject:(Exercise *)value;
- (void)addExercise:(NSSet *)values;
- (void)removeExercise:(NSSet *)values;

@end
