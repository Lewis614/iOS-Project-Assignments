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
#import "SetCardView.h"

#import "CardMatchGame.h"
#import "HistoryDetailsViewController.h"

@interface SetCardGameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *setCardexplainTextLabel;


@end

@implementation SetCardGameViewController

//difference to the playing-card game is that, the set cards are shown from the start of the game. Where playing cards are generated the first time a card is clicked, the set cards need to be generated when displayed the first time. Thus we need to run updateUI when the view loads
//override it
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    self.removeMatchingCards = YES;
    self.numberOfStartingCards = 12;
    self.maxCardSize = CGSizeMake(120.0, 120.0);
    
    [self updateUI];
}


-(Deck *)createDeck {
    
    self.gameType = @"Set Cards";
    // remember to create a SetDeck using method in SetDeck, not a super abstract method.
    return [[SetCardDeck alloc]init];
}


-(UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"setcardSelectLand" : @"setcardBackLand"];
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
                                                            NSForegroundColorAttributeName: [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.4]}];
        
    }
    NSAttributedString *title =[[NSAttributedString alloc] initWithString:tempSymbol attributes:attributes];
    
    
    return title;
    
}

//update UI is still using the super class method, but here just implement the difference on description detail.

-(void) updateUIDescription{
    if(self.game) {
        NSAttributedString * description =[self demoDescriptionWithAttributedString];
        
        if(![description isEqualToAttributedString:[[NSAttributedString alloc]initWithString:@""]] && ![self.flipHistory.lastObject isEqualToAttributedString:description]){
            [self.flipHistory addObject:description];
        }
    }
    
    
}

-(NSAttributedString *) demoDescriptionWithAttributedString{
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc]init];
    self.setCardexplainTextLabel.text = @"";
    if([self.game.lastChosenCards count]){
        for(Card *card in self.game.lastChosenCards) {
            
            [description appendAttributedString: [self titleForCard:card]];
            [description appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        
        if(self.game.lastScore > 0){
            NSString *matchPart = [NSString stringWithFormat:@"Matched! Get %ld points!", self.game.lastScore];
            NSInteger loc =description.length;
            [description appendAttributedString:[[NSAttributedString alloc]initWithString:matchPart]];
            [description replaceCharactersInRange:NSMakeRange(loc, matchPart.length) withString:matchPart];
            
            self.setCardexplainTextLabel.Text =matchPart;
        }
        
        else if(self.game.lastScore < 0){
            NSString *dismatchPart = [NSString stringWithFormat:@"Don't match! %ld points penalty!", -self.game.lastScore];
            
            NSInteger loc =description.length;
            [description appendAttributedString:[[NSAttributedString alloc]initWithString:dismatchPart]];
            [description replaceCharactersInRange:NSMakeRange(loc, dismatchPart.length) withString:dismatchPart];
            
            self.setCardexplainTextLabel.text =dismatchPart;
        }
    }
    return description;
}


//==HW4====

- (UIView *)createViewForCard:(Card *)card
{
    SetCardView *view = [[SetCardView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    if (![card isKindOfClass:[SetCard class]]) return;
    if (![view isKindOfClass:[SetCardView class]]) return;
    
    SetCard *setCard = (SetCard *)card;
    SetCardView *setCardView = (SetCardView *)view;
    setCardView.color = setCard.color;
    setCardView.symbol = setCard.symbol;
    setCardView.shading = setCard.shading;
    setCardView.number = setCard.number;
    setCardView.chosen = setCard.chosen;
}












@end
