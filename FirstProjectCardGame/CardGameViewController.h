//
//  CardGameViewController.h
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/22/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//
//  Abstract class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchGame.h"
#import "GameResult.h"


@interface CardGameViewController : UIViewController
//public for using

@property (nonatomic) CGSize maxCardSize;

//Used when instantiating the array lazily, and for instantiating the game property
@property (nonatomic) NSUInteger numberOfStartingCards;


@property (strong,nonatomic) CardMatchGame *game;
@property (strong, nonatomic) NSMutableArray *flipHistory;
//The game type needs to be set by the child game-view controllers
@property(strong,nonatomic) NSString *gameType;

// Parent class needs a new property to hold the game result,
@property(strong,nonatomic) GameResult *gameResult;


-(void) updateUI;
-(void) updateUIDescription;


//protected, for subclass to implement 
-(Deck *) createDeck;  //abstract should be public

@end
 