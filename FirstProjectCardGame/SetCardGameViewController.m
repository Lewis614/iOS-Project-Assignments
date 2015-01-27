//
//  SetCardGameViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/26/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

-(Deck *)createDeck {
    // remember to create a SetDeck using method in SetDeck, not a super abstract method.
    return [[SetCardDeck alloc]init];
}
@end
