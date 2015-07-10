//
//  Exercise.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, Set, Training;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * exerciseid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) NSSet *medias;
@property (nonatomic, retain) NSSet *sets;
@property (nonatomic, retain) Training *training;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addMediasObject:(Media *)value;
- (void)removeMediasObject:(Media *)value;
- (void)addMedias:(NSSet *)values;
- (void)removeMedias:(NSSet *)values;

- (void)addSetsObject:(Set *)value;
- (void)removeSetsObject:(Set *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

@end
