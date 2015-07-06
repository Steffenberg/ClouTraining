//
//  Media.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 06.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSString * localUrl;
@property (nonatomic, retain) NSNumber * mediaid;
@property (nonatomic, retain) NSString * onlineUrl;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Exercise *exercise;

@end
