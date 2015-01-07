//
//  CardMatchGame.h
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/31/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//

#import "Deck.h"

#import <Foundation/Foundation.h>

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





@end
