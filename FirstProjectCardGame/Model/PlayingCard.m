//
//  PlayingCard.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/30/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard



//override the match function from superclass.
-(int) match:(NSArray *)otherCards {
    int score = 0;
    
    int numOtherCards = [otherCards count];
    if(numOtherCards) {
        
        //if index = 0 array is empty, it will crush. array index out of bound
        //but for now we do know there is a element in this array. It can work as well
        //PlayingCard *otherCard = otherCards[0];
        
        //if index = 0 array is empty, return nil.(avoid index out of bound)
        //id card = [otherCards firstObject];
        
        for(Card *card in otherCards){
            if([card isKindOfClass:[PlayingCard class]]){
                PlayingCard *otherCard = (PlayingCard *) card;
                if([self.suit isEqualToString:otherCard.suit]){
                    score += 1;
                } else if(self.rank == otherCard.rank){
                    score += 4;
                }
            }
        }
    }
    // recursively solve the othercard match solution.
    if(numOtherCards>1) {
        score += [[otherCards firstObject] match:[otherCards subarrayWithRange:NSMakeRange(1, numOtherCards-1)]];
    }
    
    return score;
}

//override the get contents perperty
-(NSString *)contents{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [self.suit stringByAppendingString:rankStrings[self.rank]];
    
}

@synthesize suit = _suit;

+(NSArray *) validSuits{
    return @[@"♥︎",@"♦︎",@"♠︎",@"♣︎"];
}

-(void) setSuit:(NSString *)suit{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

-(NSString *)suit {
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger) maxRank {
    //"self" is used because it is in the declaration part, during invoking part, this should set as "Playcard maxRank"
    return [[self rankStrings] count]-1;
}

-(void) setRank:(NSUInteger)rank{
    if(rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
