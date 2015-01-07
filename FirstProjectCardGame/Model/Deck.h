//
//  Deck.h
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/30/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject


-(void) addCard:(Card *)card atTop: (BOOL)atTop;

-(void) addCard:(Card *)card;

-(Card *) drawRandomCard;


@end
