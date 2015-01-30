//
//  GameResult.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/29/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "GameResult.h"

@interface GameResult();

//private time, set it to readwrite.
@property (readwrite,nonatomic) NSDate *startTime;
@property (readwrite,nonatomic) NSDate *endTime;

@end





@implementation GameResult
//instancetype stand for the same type of the current file(GameResult)
-(instancetype) init {
    self = [super self];
    if(self) {
        _startTime = [NSDate date];
        _endTime = _startTime;
    }
    return self;
}


- (NSTimeInterval) duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

//Whenever a the score changes, we save the result to the user defaults

- (void) setScore:(NSInteger)score {
    _score = score;
    self.endTime = [NSDate date];
    [self synchronize]; // save to user default.
}


#define ALL_RESULTS_KEY @"UserDefault_AllResult"
#define START_KEY @"StartTime"
#define END_KEY @"EndTime"
#define SCORE_KEY @"Score"
#define GAME_KEY @"Game"


//The results are stored in a dictionary, which uses the start time/date as unique key
-(void) synchronize{
    NSMutableDictionary * userDefaultGameResult = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if(!userDefaultGameResult) {
        userDefaultGameResult= [[NSMutableDictionary alloc]init];
    }
    userDefaultGameResult[[self.startTime description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:userDefaultGameResult forKey:ALL_RESULTS_KEY];
    //The synchronize method, which is automatically invoked at periodic intervals, keeps the in-memory cache in sync with a user’s defaults database
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(void)reset {
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableDictionary alloc]init] forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//it is a dictionary as well.
-(id) asPropertyList{
    return @{START_KEY : self.startTime, END_KEY : self.endTime, SCORE_KEY : @(self.score), GAME_KEY : self.gameType};
}

+(NSArray*) allGameResults{
    NSMutableArray *allGameResults=[[NSMutableArray alloc]init];
    for(id propertyList in [[[NSUserDefaults standardUserDefaults]dictionaryForKey:ALL_RESULTS_KEY]allValues]){
        GameResult *result = [[GameResult alloc]initFromPropertyList:propertyList];
        [allGameResults addObject:result];
    }
    return allGameResults;
}

//use another initialization method to create each single result
-(id)initFromPropertyList:(id)propertyList{
    self = [self init];
    
    //add some new feature to the commen init function.
    if(self){
        if([propertyList isKindOfClass:[NSDictionary class]]){
            NSDictionary *resultDictionary = (NSDictionary *)propertyList;
            _startTime = resultDictionary[START_KEY];
            _endTime = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            _gameType =resultDictionary[GAME_KEY];
            // the start time or end time equals to 0;
            if(!_startTime || !_endTime) self =nil;
        }
    }
    return self;
}

//Sorting helper method(using in the @selector(XXXX))
-(NSComparisonResult) compareDuration:(GameResult *)result{
    return[@(self.duration) compare:[[NSNumber alloc]initWithDouble:result.duration]];
}

-(NSComparisonResult) compareScore:(GameResult *)result {
    return [@(self.score) compare:@(result.score)];
}

-(NSComparisonResult) compareDate:(GameResult *)result{
    return [self.endTime compare: result.endTime];
}









@end
