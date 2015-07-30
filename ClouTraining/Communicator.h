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

@class Reachability;

@interface Communicator : NSObject

@property Reachability *reachability;

+(Communicator*)sharedInstance;

+(BOOL)dataOnlyWLAN;
+(void)setDataOnlyLAN:(BOOL)only;

-(void)performRegister:(NSString*)mail password:(NSString*)password nickname:(NSString*)nickname;
-(void)performLogin:(NSString*)nickname password:(NSString*)password;
-(void)sendExerciseToServer:(Exercise*)e;
-(BOOL)setShared:(BOOL)shared forExercise:(Exercise*)e;
-(void)deleteExercise:(Exercise*)e completition:(OnlineComplete)complete;
-(void)reuqestMediaInfoWithData:(NSDictionary*)data andMedia:(NSData*)media;
-(void)getMediaURLsForExercise:(Exercise*)e type:(NSInteger)type;
-(void)getSharedExercises;
@end
