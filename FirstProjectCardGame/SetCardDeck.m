//
//  SetCardDeck.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/26/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck


// create a deck full of the set cards (all possible combinations)
-(instancetype) init{
    self = [super init];
    if(self) {
        for(NSString *color in [SetCard validColor]){
            for(NSString *symbol in [SetCard validSymbol]) {
                for (NSString *shading in [SetCard validShading]) {
                    for(NSInteger number =1; number<= [SetCard maxNumber];number++) {
                        SetCard *card = [[SetCard alloc]init];
                        card.color = color;
                        card.shading = shading;
                        card.symbol = symbol;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}



@end
