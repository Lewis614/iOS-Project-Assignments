//
//  CardMatchGame.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/31/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//

#import "CardMatchGame.h"


@interface CardMatchGame()

// reset the score can be set in private
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,strong) NSMutableArray *cards; // of Card
@property (nonatomic,readwrite) NSMutableArray *lastChosenCards;
@property (nonatomic,readwrite) NSInteger lastScore;



@end


@implementation CardMatchGame


-(NSMutableArray *) cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


-(instancetype) initWithCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    if(self){
        for(int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if(card){
                [self.cards addObject:card];
                //self.cards[i] = card;
            } else {
                // run out of card.
                self = nil;
                break;
            }
            
            
            
        }
    }
    return self;
}



//No type just substituting: #define MISMATCH_PENALTY 2
static const int MISMATCH_PENALTY = 2;
static const int MATH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


//Entire logic happens here.

-(void) chooseCardAtIndex:(NSUInteger)index{
    Card *card  = [self cardAtIndex:index];
    
    if(!card.isMatched) {
        if(card.isChosen) {
            card.chosen = NO;
            
            //very important:handling the blank situation.
            if(self.lastChosenCards) {
                //first to clean all the chosen cards and then recheck the current situation again.
                [self.lastChosenCards removeAllObjects];
                for(Card *card in self.cards) {
                    if(card.isChosen && !card.isMatched) [self.lastChosenCards addObject:card];
                }
                self.lastScore=0;
            }
            
            
        } else {
            //match against any card among another otherCards
            //NSMutableArray *otherCards = [NSMutableArray array]; -->dont need to release the memory manually, but not preferred.
            NSMutableArray *otherCards = [[NSMutableArray alloc]init];
            for(Card * otherCard in self.cards){
                if(otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
                
                // the purpose of this lastChosenCards variable is to show the contents of every chosencards in text field.
                
                //############Casting by myself there############
                self.lastChosenCards =[[otherCards arrayByAddingObject:card] mutableCopy] ;
                
                //must reset the public variable when you want to reuse it.
                self.lastScore = 0;
                // otherCards + card itself.
                if([otherCards count]+1 == self.maxMatchingCards){
                    int matchScore = [card match:otherCards]; //use array because match can do multiple cards
                    if(matchScore) {
                        self.lastScore= matchScore * MATH_BONUS;
                        card.matched = YES;
                        for(Card *otherCard in otherCards) {
                            otherCard.matched = YES;
                        }
                    } else {
                        //Mismatch,set it as a constant
                        self.lastScore = -MISMATCH_PENALTY;
                        for(Card *otherCard in otherCards){
                            otherCard.chosen = NO;
                        }
                        
                    }
                    //only two card matching game, once found one, we are done.
                    // hw can not do simply break.
                    
                    //if we dont break ,the score will be calculated by multiple times.
                    break;
                }
            }
            self.score += (self.lastScore - COST_TO_CHOOSE);
            card.chosen = YES;
            //if(self.lastScore<0) card.chosen = NO;
            //else card.chosen = YES;
            
        }
    }
}

-(Card *)cardAtIndex:(NSUInteger)index{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}


-(NSInteger) maxMatchingCards {
    // Make it generic to fit any number of card matching.
    Card *card = [self.cards firstObject];
    if(_maxMatchingCards<card.numberOfInitialSettingOfMatchingCard) _maxMatchingCards = card.numberOfInitialSettingOfMatchingCard;
    return _maxMatchingCards;
}





@end
