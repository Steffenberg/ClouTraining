//
//  Protocol.h
//  ClouTraining
//
//  Created by fastline on 08.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, Training;

@interface Protocol : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) Training *training;
@end

@interface Protocol (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
