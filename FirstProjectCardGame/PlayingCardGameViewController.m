//
//  PlayingCardGameViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/7/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"


@interface PlayingCardGameViewController ()

@end


@implementation PlayingCardGameViewController


//override and implement the abstract method in superclass
-(Deck *) createDeck {
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc] init];
}


-(void)viewDidLoad {
    [super viewDidLoad];
    //landscape change to an old view which pervious is portrait. If no this resize, while the auto layout works, buttons and cards which end up at the right hand side in landscape mode do not seem to be touchable any more, thus the auto-resizing mask needs to be adjusted for all controllers
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    self.numberOfStartingCards = 35;
    self.maxCardSize = CGSizeMake(80.0, 120.0);
    

    [self updateUI];

}

- (UIView *)createViewForCard:(Card *)card
{
    PlayingCardView *view = [[PlayingCardView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    if (![card isKindOfClass:[PlayingCard class]]) return;
    if (![view isKindOfClass:[PlayingCardView class]]) return;
    PlayingCard *playingCard = (PlayingCard *)card;
    PlayingCardView *playingCardView = (PlayingCardView *)view;
    playingCardView.rank = playingCard.rank;
    playingCardView.suit = playingCard.suit;
    
    //if playing cardview change its status.
    if(playingCardView.faceUp != playingCard.chosen){
        [UIView transitionWithView:view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:nil
                        completion:nil];
    }
    // use the model status to set view.
    playingCardView.faceUp = playingCard.chosen;
}




@end
