//
//  CardMatchGame.h
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/31/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Deck.h"


@interface CardMatchGame : NSObject

//designated initializer, same function like init.
-(instancetype)initWithCount:(NSUInteger) count usingDeck:(Deck *)deck;

-(void) chooseCardAtIndex: (NSUInteger) index;

-(Card *) cardAtIndex : (NSUInteger) index;

//read only because I am the game logic, I decide the how many score, no public setter.
@property (nonatomic,readonly) NSInteger score;
@property (nonatomic) NSInteger maxMatchingCards;

@property (nonatomic,readonly) NSMutableArray *lastChosenCards;
@property (nonatomic,readonly) NSInteger lastScore;
@property (nonatomic, readonly) NSUInteger numberOfDealtCards;

//game setting need these public property to send message to model.
@property (nonatomic) NSInteger matchBonus;
@property (nonatomic) NSInteger mismatchPenalty;
@property (nonatomic) NSInteger flipCost;




@end
