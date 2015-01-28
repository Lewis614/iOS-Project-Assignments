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

@interface CardGameViewController : UIViewController
//public for using
@property (weak, nonatomic) IBOutlet UITextField *explainTextLabel;
@property (strong,nonatomic) CardMatchGame *game;
@property (strong, nonatomic) NSMutableArray *flipHistory;



-(NSAttributedString *)titleForCard:(Card *)card;
-(UIImage *)backgroundImageForCard:(Card *)card;
-(void) updateUI;
-(void) updateUIDescription;


//protected, for subclass to implement 
-(Deck *) createDeck;  //abstract

@end
 