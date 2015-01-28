//
//  CardGameViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 12/22/14.
//  Copyright (c) 2014 Cornell University. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "Card.h"
#import "HistoryDetailsViewController.h"

@interface CardGameViewController ()

@property (strong,nonatomic) Deck *deck;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;


@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation CardGameViewController



-(CardMatchGame *) game {
    if(!_game){
        _game = [[CardMatchGame alloc] initWithCount:[self.cardButtons count]
                                           usingDeck:[self createDeck]];
        [self touchSegmentControl:self.modeSelector];
    }
    return _game;
    
}


/*
 - (Deck *) deck{
 //lazy instantiation implementation with a full deck of playingCards
 //if(!_deck) _deck = [[PlayingCardDeck alloc] init];
 if(!_deck) _deck = [self createDeck];
 return _deck;
 }
 */


-(Deck *) createDeck{  //abstract
    
    //Lec3:Not good because it is not generic, epecific for playingcarddeck
    //return [[PlayingCardDeck alloc] init];
    //Lec6: Updated to be generic, make this CardViewController be abstract.
    return nil;
    
    /*In objective C you can not declare a class as abstract class, you have to document it. and any abstract method should be PUBLIC.
     */
}

-(NSMutableArray *) flipHistory {
    if(!_flipHistory){
        _flipHistory = [[NSMutableArray alloc]init];
    }
    return _flipHistory;
}




/*HW1 contents:
 - (void) setFlipCount:(int)flipCount
 {
 _flipCount = flipCount;
 self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
 NSLog(@"flipCount = %d", self.flipCount);
 }
 
 - (void) setLeftCardCount:(int) leftCardCount{
 _leftCardCount = leftCardCount;
 self.leftCardLabel.text =[NSString stringWithFormat:@"DeckCardLeft: %d",self.leftCardCount];
 NSLog (@"DeckCardLeft:%d", self.leftCardCount);
 }
 
 */


- (IBAction)touchRestartButton:(UIButton *)sender {
    //clear all the setting and use lazy initialzation in updateUI to recreate them.
    self.game = nil;
    self.flipHistory = nil;
    
    //reset the slider range.
    [self resetSliderRange:0];
    //Do not need [self game]before updateUI, since if meet game == nil it will lazy initialization again.
    [self updateUI];
    self.explainTextLabel.text =@"";
    [self.modeSelector setEnabled:YES];
}

- (IBAction)touchSegmentControl:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex == 0){
        self.game.maxMatchingCards = 2;
    }
    else if(sender.selectedSegmentIndex == 1) {
        self.game.maxMatchingCards = 3;
    }
    
}


- (IBAction)touchCardButton:(UIButton *)sender
{
    // tell us where is this sending button in this array.
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
    
    if(self.modeSelector.isEnabled){
        [self.modeSelector setEnabled:NO];
    }
    
}
- (IBAction)changeSlider:(UISlider *)sender {
    NSInteger sliderValue = lroundf(self.historySlider.value);
    //[self.historySlider setValue:sliderValue animated:NO];
    [self.historySlider setValue:sliderValue];
    if([self.flipHistory count]) {
        self.explainTextLabel.alpha =
                    (sliderValue == [self.flipHistory count]-1 ? 1.0 :0.4);
        self.explainTextLabel.text = [self.flipHistory objectAtIndex:sliderValue];
    }
    
    
}

-(void) updateUI {
    for(UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton ];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setAttributedTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                               forState:UIControlStateNormal];
        cardButton.enabled =!card.isMatched;
        // if the card is matched, it will disable the button.
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateUIDescription];
}
-(void) updateUIDescription{
    if(self.game) {
        NSString *description = @"";
        if([self.game.lastChosenCards count]){
            NSMutableArray *cardContents =[[NSMutableArray alloc]init];
            for(Card *card in self.game.lastChosenCards) {
                [cardContents addObject:card.contents];
            }
            description = [cardContents componentsJoinedByString:@" "];
        }
        if(self.game.lastScore > 0) description = [NSString stringWithFormat:@"Matched! %@ for %d points!", description, self.game.lastScore];
        else if(self.game.lastScore < 0) {
            description = [NSString stringWithFormat:@"%@ don't match! %d points penalty!", description, -self.game.lastScore];
        }
        
        self.explainTextLabel.text = description;
        //Check if the description is already stored in the history and store it if needed.
        self.explainTextLabel.alpha = 1;
        if(![description isEqualToString:@"" ]&& ![self.flipHistory.lastObject isEqualToString:description]) {
            [self.flipHistory addObject:description];
            [self resetSliderRange:[self.flipHistory count]-1];
        }
    }
    
}

-(void) resetSliderRange:(NSInteger)maxValue {

    self.historySlider.maximumValue = maxValue;
    //set it and move the slider to the new position
    //[self.historySlider setValue:maxValue animated:NO];
    [self.historySlider setValue:maxValue];
}

-(NSAttributedString *)titleForCard:(Card *)card {
    NSString *titleStr = card.isChosen ? card.contents : @"";
    NSAttributedString * title  = [[NSAttributedString alloc]initWithString:titleStr];
    return title;
}

-(UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Show History"]) {
        if([segue.destinationViewController isKindOfClass:[HistoryDetailsViewController class]]){
            //prepare the array to segue
            [segue.destinationViewController setHistory:self.flipHistory];
        }
    }
}
@end
