//
//  SetCardGameViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/26/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

//difference to the playing-card game is that, the set cards are shown from the start of the game. Where playing cards are generated the first time a card is clicked, the set cards need to be generated when displayed the first time. Thus we need to run updateUI when the view loads
//override it
-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateUI];
}


-(Deck *)createDeck {
    // remember to create a SetDeck using method in SetDeck, not a super abstract method.
    return [[SetCardDeck alloc]init];
}


-(UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"setcardSelected" : @"setcardBack1"];
}

-(NSAttributedString *)titleForCard:(Card *)card {
    NSString *tempSymbol = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    if([card isKindOfClass:[SetCard class]]){
        SetCard *setCard = (SetCard *)card;
        
        //@"diamond", @"squiggle", @"oval"
        if([setCard.symbol isEqualToString:@"oval"]) tempSymbol = @"●";
        if([setCard.symbol isEqualToString:@"squiggle"]) tempSymbol = @"▲";
        if([setCard.symbol isEqualToString:@"diamond"]) tempSymbol = @"■";
        tempSymbol = [tempSymbol stringByPaddingToLength:setCard.number withString:tempSymbol startingAtIndex:0];
        
        //@"red", @"green",@"purple"
        if([setCard.color isEqualToString:@"red"]) [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        if([setCard.color isEqualToString:@"green"]) [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        if([setCard.color isEqualToString:@"purple"]) [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
        //@"solid", @"striped", @"open"
        if([setCard.shading isEqualToString:@"solid"]) [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        if([setCard.shading isEqualToString:@"open"]) [attributes setObject:@+5 forKey:NSStrokeWidthAttributeName];
        if([setCard.shading isEqualToString:@"striped"]) [attributes addEntriesFromDictionary:
                                            @{NSStrokeWidthAttributeName: @-5,
                                            NSStrokeColorAttributeName:attributes[NSForegroundColorAttributeName],
                                            NSForegroundColorAttributeName: [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.5]}];
        
    }
    return [[NSAttributedString alloc] initWithString:tempSymbol attributes:attributes];
}


@end
