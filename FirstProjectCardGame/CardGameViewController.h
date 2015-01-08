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

@interface CardGameViewController : UIViewController
//public for using




//protected, for subclass to implement 
-(Deck *) createDeck;  //abstract

@end
 