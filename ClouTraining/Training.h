//
//  Training.h
//  ClouTraining
//
//  Created by fastline on 08.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, Protocol;

@interface Training : NSManagedObject

@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSDate * lastUsed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * own;
@property (nonatomic, retain) NSNumber * publicate;
@property (nonatomic, retain) NSNumber * trainingid;
@property (nonatomic, retain) NSSet *exercise;
@property (nonatomic, retain) NSSet *protocols;
@end

@interface Training (CoreDataGeneratedAccessors)

- (void)addExerciseObject:(Exercise *)value;
- (void)removeExerciseObject:(Exercise *)value;
- (void)addExercise:(NSSet *)values;
- (void)removeExercise:(NSSet *)values;

- (void)addProtocolsObject:(Protocol *)value;
- (void)removeProtocolsObject:(Protocol *)value;
- (void)addProtocols:(NSSet *)values;
- (void)removeProtocols:(NSSet *)values;

@end
