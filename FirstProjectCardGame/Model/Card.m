//
//  Card.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/28/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//

#import "Card.h"

@interface Card()

@end


@implementation Card

-(NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    
    for(Card *card in otherCards){
    
        if([card.contents isEqualToString:self.contents]) score = 1;
    }
    return score;
}

-(NSInteger) numberOfInitialSettingOfMatchingCard {
    // if it is nil, set to default 2.
    if (!_numberOfInitialSettingOfMatchingCard) {
        _numberOfInitialSettingOfMatchingCard =2;
    }
    return _numberOfInitialSettingOfMatchingCard;
}

@end
