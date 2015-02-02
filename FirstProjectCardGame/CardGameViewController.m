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
#import "GameSetting.h"
#import "Grid.h"

@interface CardGameViewController ()


//BUT Not required to make a superclass’s outlets and actions public (by putting them in its header file)
@property (weak, nonatomic) IBOutlet UITextField *explainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;

//----------------
@property (strong,nonatomic) Deck *deck;
@property (strong,nonatomic) GameSetting* gameSetting;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) Grid *grid;

@end

@implementation CardGameViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.game.matchBonus = self.gameSetting.matchBonus;
    self.game.mismatchPenalty = self.gameSetting.mismatchPenalty;
    self.game.flipCost = self.gameSetting.flipCost;
}

//lazy instantiation for cardViews
- (NSMutableArray *)cardViews
{
    if (!_cardViews){
        _cardViews = [NSMutableArray arrayWithCapacity:self.numberOfStartingCards];
    }
    return _cardViews;
}

//lazy instantiation for Grid
- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.cellAspectRatio = self.maxCardSize.width / self.maxCardSize.height;
        _grid.minimumNumberOfCells = self.numberOfStartingCards;
        _grid.maxCellWidth = self.maxCardSize.width;
        _grid.maxCellHeight = self.maxCardSize.height;
        _grid.size = self.gridView.frame.size;
    }
    return _grid;
}


-(CardMatchGame *) game {
    if(!_game){
        _game = [[CardMatchGame alloc] initWithCount:self.numberOfStartingCards usingDeck:[self createDeck]];
        [self touchSegmentControl:self.modeSelector];
        
        _game.matchBonus = self.gameSetting.matchBonus;
        _game.mismatchPenalty = self.gameSetting.mismatchPenalty;
        _game.flipCost = self.gameSetting.flipCost;
    }
    return _game;
    
}




-(Deck *) createDeck{  //abstract
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


- (IBAction)touchRestartButton:(UIButton *)sender {
    //clear all the setting and use lazy initialzation in updateUI to recreate them.

    //When dealing a new deck, make sure there is no old card view on screen, reset the card array, the grid and the add-cards button
    for (UIView *subView in self.cardViews) {
        [subView removeFromSuperview];
    }
    
    self.game = nil;
    self.cardViews = nil;
    self.grid = nil;
    self.flipHistory = nil;
    self.gameResult = nil;
    

    self.addCardsButton.enabled = YES;
    self.addCardsButton.alpha = 1.0;
    
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

#define ADD_CARD_NUM 3
- (IBAction)touchAddCardsButton:(UIButton *)sender {
    // add there cards there
    for (int i = 0; i < ADD_CARD_NUM; i++) {
        [self.game drawNewCard];
    }
    if (self.game.deckIsEmpty) {
        sender.enabled = NO;
        sender.alpha = 0.5;
    }
    [self updateUI];
}


#define CARDSPACINGINPERCENT 0.08

-(void) updateUI {
    for (NSUInteger cardIndex = 0; cardIndex < self.game.numberOfDealtCards; cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        NSUInteger viewIndex = [self.cardViews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                if (((UIView *)obj).tag == cardIndex) return YES;
            }
            return NO;
        }];
        UIView *cardView;
        if (viewIndex == NSNotFound) {
            if(!card.matched){
                cardView = [self createViewForCard:card];
                cardView.tag = cardIndex;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCard:)];
                [cardView addGestureRecognizer:tap];
                [self.cardViews addObject:cardView];
                viewIndex = [self.cardViews indexOfObject:cardView];
                [self.gridView addSubview:cardView];
            }
            
        } else {
            cardView = self.cardViews[viewIndex];
            if(!card.matched){
                [self updateView:cardView forCard:card];
            } else {
                //use removeMatchingCards parameter to decided whether it should be removed(should--play, not--set)
                if(self.removeMatchingCards){
                    //### if the view is matched, remove it from the top view.
                    [cardView removeFromSuperview];
                }
                else {
                    cardView.alpha = card.matched ? 0.6 : 1.0;
                }
                [self updateView:cardView forCard:card];
            }
            
            
        }
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        cardView.frame = frame;
    }
    
    
    //When updating the user interface move the grid calculations to a loop of its own after you reset the grid to a possible new card count
    self.grid.minimumNumberOfCells = [self.cardViews count];
    for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++) {
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        ((UIView *)self.cardViews[viewIndex]).frame = frame;
    }
    
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    //Change the score of the game results when the user interface gets updated
    self.gameResult.score = self.game.score;
    
    //the user can only set the mode when there is no score counted
    if(self.game.score !=0 && self.modeSelector.enabled == YES){
        [self.modeSelector setEnabled:NO];
    }
    
    [self updateUIDescription];
}


//helper methods below: (dummy method here, implement them in concrete subclass)
- (UIView *)createViewForCard:(Card *)card
{
    UIView *view = [[UIView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    view.backgroundColor = [UIColor blueColor];
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



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Show History"]) {
        if([segue.destinationViewController isKindOfClass:[HistoryDetailsViewController class]]){
            //prepare the array to segue
            [segue.destinationViewController setHistory:self.flipHistory];
        }
    }
}

//=======HW3 Extra Task2=========

//property of GameResult and GameSettings.lazy instanation
- (GameResult *)gameResult {
    if(!_gameResult) {
        _gameResult = [[GameResult alloc]init];
    }
    _gameResult.gameType = self.gameType;
    return _gameResult;
}


- (GameSetting *)gameSetting
{
    if (!_gameSetting) _gameSetting = [[GameSetting alloc] init];
    return _gameSetting;
}


//==========HW4===================

//Gesture added to flip the card:When touching send the chosen card index to the game model and update the user interface
- (void)touchCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.game chooseCardAtIndex:gesture.view.tag];
        [self updateUI];
    }
}

@end
