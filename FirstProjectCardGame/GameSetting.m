//
//  GameSetting.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/29/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "GameSetting.h"


#define GAME_SETTINGS_KEY @ "Game_Settings"
#define MATCHBONUS_KEY @"MatchBonus"
#define MISMATCHPENALTY_KEY @"MismatchPenalty"
#define FLIPCOST_KEY @"flipCost"


@implementation GameSetting


//properties getters
- (NSInteger)matchBonus
{
    return [self intValueForKey:MATCHBONUS_KEY withDefault:4];
}

- (NSInteger)mismatchPenalty
{
    return [self intValueForKey:MISMATCHPENALTY_KEY withDefault:2];
}

- (NSInteger)flipCost
{
    return [self intValueForKey:FLIPCOST_KEY withDefault:1];
}

//getter helper method
- (int)intValueForKey:(NSString *)key withDefault:(int)defaultValue
{
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults]
                              dictionaryForKey:GAME_SETTINGS_KEY];
    if (!settings) return defaultValue;
    if (![[settings allKeys] containsObject:key]) return defaultValue;
    return [settings[key] intValue];
}


//properties setters
- (void)setMatchBonus:(NSInteger)matchBonus
{
    [self setIntValue:matchBonus forKey:MATCHBONUS_KEY];
}

- (void)setMismatchPenalty:(NSInteger)mismatchPenalty
{
    [self setIntValue:mismatchPenalty forKey:MISMATCHPENALTY_KEY];
}

- (void)setFlipCost:(NSInteger)flipCost
{
    [self setIntValue:flipCost forKey:FLIPCOST_KEY];
}

//setter helper method to save their values to the user defaults
- (void)setIntValue:(NSInteger)value forKey:(NSString *)key
{
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults]
                                      dictionaryForKey:GAME_SETTINGS_KEY] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[key] = @(value);
    [[NSUserDefaults standardUserDefaults] setObject:settings
                                              forKey:GAME_SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}






@end
