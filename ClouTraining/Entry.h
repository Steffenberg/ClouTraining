//
//  Entry.h
//  ClouTraining
//
//  Created by fastline on 08.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, Protocol;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * repititions;
@property (nonatomic, retain) Exercise *exercise;
@property (nonatomic, retain) Protocol *protocol;

@end
