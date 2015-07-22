//
//  SetEntry.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 22.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseProtocol;

@interface SetEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * repititions;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * setNumber;
@property (nonatomic, retain) ExerciseProtocol *exerciseProtocol;

@end
