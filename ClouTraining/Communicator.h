//
//  Communicator.h
//  ClouTraining
//
//  Created by Steffen Gruschka on 14.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnlineComplete)(BOOL);
typedef void (^MediaComplete)(BOOL);

extern NSString const *ipprefix;

@interface Communicator : NSObject



+(Communicator*)sharedInstance;

-(void)sendExerciseToServer:(Exercise*)e;
-(BOOL)setShared:(BOOL)shared forExercise:(Exercise*)e;
-(void)deleteExercise:(Exercise*)e completition:(OnlineComplete)complete;
-(void)reuqestMediaInfoWithData:(NSDictionary*)data andMedia:(NSData*)media;
-(void)getMediaURLsForExercise:(Exercise*)e type:(NSInteger)type;
-(void)getSharedExercises;
@end
