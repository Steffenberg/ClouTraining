//
//  Set.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, Exercise;

@interface Set : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * repititions;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) Exercise *exercise;
@end

@interface Set (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
