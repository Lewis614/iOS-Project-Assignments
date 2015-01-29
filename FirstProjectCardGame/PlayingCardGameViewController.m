//
//  PlayingCardGameViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/7/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
@interface PlayingCardGameViewController ()

@end


@implementation PlayingCardGameViewController


//override and implement the abstract method in superclass
-(Deck *) createDeck {
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc] init];
}

/* change the tool bar option.
-(void)viewDidLoad {
    [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    [self.tabBarController.tabBar setBackgroundColor:[UIColor greenColor]];
}
*/




@end
