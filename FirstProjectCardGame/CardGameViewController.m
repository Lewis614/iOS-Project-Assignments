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


@property (strong, nonatomic) UIDynamicAnimator *pileAnimator;


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
        [UIView animateWithDuration:0.5
                         animations:^{
                             subView.frame = CGRectMake(0.0,
                                                        self.gridView.bounds.size.height,
                                                        self.grid.cellSize.width/2,
                                                        self.grid.cellSize.height/2);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{subView.alpha=0.0;} completion:^(BOOL finished) {
                                 [subView removeFromSuperview];
                             }];
                             
                         }];
    }
    
    self.game = nil;
    self.cardViews = nil;
    self.grid = nil;
    self.flipHistory = nil;
    self.gameResult = nil;
    self.pileAnimator = nil;

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
    
    self.pileAnimator = nil;
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
                cardView.frame = CGRectMake(self.gridView.bounds.size.width,
                                            self.gridView.bounds.size.height,
                                            self.grid.cellSize.width,
                                            self.grid.cellSize.height);
                
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
                    [self.cardViews removeObject:cardView];
                    [UIView animateWithDuration:1.0
                                     animations:^{
                                         cardView.frame = CGRectMake(0.0,
                                                                     self.gridView.bounds.size.height,
                                                                     self.grid.cellSize.width/2,
                                                                     self.grid.cellSize.height/2);
                                         
                                     } completion:^(BOOL finished) {
                                         //### if the view is matched, remove it from the top view.
                                         [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{cardView.alpha=0.0;} completion:^(BOOL finished) {
                                             [cardView removeFromSuperview];
                                         }];
                                     }];
                    
                }
                else {
                    cardView.alpha = card.matched ? 0.6 : 1.0;
                }
                [self updateView:cardView forCard:card];
            }
            
            
        }
        /*
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        cardView.frame = frame;
         */
    }
    
    
    //When updating the user interface move the grid calculations to a loop of its own after you reset the grid to a possible new card count
    self.grid.minimumNumberOfCells = [self.cardViews count];
    
    NSUInteger changedViews = 0;
    
    for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++) {
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);

        UIView *cardView = (UIView *)self.cardViews[viewIndex];
        if(![self frame:frame equalToFrame:cardView.frame]){
            [UIView animateWithDuration:0.5
                                  delay:1.5 * changedViews++ / [self.cardViews count]
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{ cardView.frame = frame;}
                             completion:NULL];
        }
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

//helper method to compare the frame isEqual
#define FRAMEROUNDINGERROR 0.01
- (BOOL)frame:(CGRect)frame1 equalToFrame:(CGRect)frame2
{
    if (fabs(frame1.size.width - frame2.size.width) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.size.height - frame2.size.height) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.x - frame2.origin.x) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.y - frame2.origin.y) > FRAMEROUNDINGERROR) return NO;
    return YES;
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
        Card *card = [self.game cardAtIndex:gesture.view.tag];
        if(!card.matched && !self.pileAnimator) {
            [self.game chooseCardAtIndex:gesture.view.tag];
            [self updateUI];
        }
        else if(self.pileAnimator) {
            self.pileAnimator = nil;
            [self updateUI];
        }
        
    }
}

//After a rotation resize the grid and update the user interface:
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    self.grid.size = self.gridView.bounds.size;
    self.pileAnimator = nil;
    [self updateUI];
}


//Panning should only be possible, when there is a pile (or at least the animation to generate a pile is active). When panning starts, add an attachment behavior to all cards – connected to the point of touch – and stop currently active snapping by removing the snap behavior for the cards. During panning just adjust the anchor point to the current point of touch. At the end remove the attachment behavior and reset the snapping behaviour


- (IBAction)panPile:(UIPanGestureRecognizer *)sender {
    if (self.pileAnimator) {
        CGPoint gesturePoint = [sender locationInView:self.gridView];
        if (sender.state == UIGestureRecognizerStateBegan) {
            for (UIView *cardView in self.cardViews) {
                UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:gesturePoint];
                [self.pileAnimator addBehavior:attachment];
            }
            for (UIDynamicBehavior *behaviour in self.pileAnimator.behaviors) {
                if ([behaviour isKindOfClass:[UISnapBehavior class]]) {
                    [self.pileAnimator removeBehavior:behaviour];
                }
            }
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            for (UIDynamicBehavior *behaviour in self.pileAnimator.behaviors) {
                if ([behaviour isKindOfClass:[UIAttachmentBehavior class]]) {
                    ((UIAttachmentBehavior *)behaviour).anchorPoint = gesturePoint;
                }
            }
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            for (UIDynamicBehavior *behaviour in self.pileAnimator.behaviors) {
                if ([behaviour isKindOfClass:[UIAttachmentBehavior class]]) {
                    [self.pileAnimator removeBehavior:behaviour];
                }
            }
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:gesturePoint];
                [self.pileAnimator addBehavior:snap];
            }
        }
    }
}

//After a pinch, and when there is no current active animation create a new animator, loop over all cards and add a snap behavior for each of them – snapping to the center of the pinch gesture. Because the snap behavior is quite fast, add an additional dynamic-item behavior, and set the resistance to slow snapping down:

#define RESISTANCE_TO_PILING 40.0
- (IBAction)gatherCardsIntoPile:(UIPinchGestureRecognizer *)sender {
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) {
        if (!self.pileAnimator) {
            CGPoint center = [sender locationInView:self.gridView];
            self.pileAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gridView];
            UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:self.cardViews];
            item.resistance = RESISTANCE_TO_PILING;
            [self.pileAnimator addBehavior:item];
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:center];
                [self.pileAnimator addBehavior:snap];
            }
        }
    }
}



@end
