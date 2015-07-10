//
//  Entry.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 10.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Set, TrainingProtocol;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * repititions;
@property (nonatomic, retain) TrainingProtocol *protocol;
@property (nonatomic, retain) Set *set;

@end
