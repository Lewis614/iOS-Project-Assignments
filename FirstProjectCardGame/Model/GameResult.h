//
//  GameResult.h
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/29/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject
@property (readonly,nonatomic) NSDate *startTime;
@property (readonly,nonatomic) NSDate *endTime;
@property (nonatomic) NSInteger score;
//typedef double NSTimeInterval; it is a double type, no pointer need.
@property (readonly,nonatomic) NSTimeInterval duration;
@property (strong,nonatomic) NSString *gameType;

//it needs two helper methods which we will use to sort the game results by score and duration
//typedef NSInteger NSComparisonResult;
-(NSComparisonResult) compareScore:(GameResult *)result;

-(NSComparisonResult) compareDuration:(GameResult *)result;

-(NSComparisonResult) compareDate:(GameResult *)result;

//public utility method
+(NSArray*) allGameResults;
+(void)reset;
@end
