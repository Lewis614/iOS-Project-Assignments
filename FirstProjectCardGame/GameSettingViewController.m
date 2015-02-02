//
//  GameSettingViewController.m
//  FirstProjectCardGame
//
//  Created by Liu Yisi on 1/29/15.
//  Copyright (c) 2015 Cornell University. All rights reserved.
//

#import "GameSettingViewController.h"
#import "GameSetting.h"

@interface GameSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchBonusScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *mismatchPenaltyScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipCostScoreLabel;
@property (weak, nonatomic) IBOutlet UISlider *matchBonusSlider;
@property (weak, nonatomic) IBOutlet UISlider *mismatchPenaltySlider;
@property (weak, nonatomic) IBOutlet UISlider *flipcostSlider;

//need a property to hold the settings model,talk to model on how the score value changes.
@property (strong,nonatomic) GameSetting *gameSetting;

@end



@implementation GameSettingViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.matchBonusSlider.value = self.gameSetting.matchBonus;
    self.mismatchPenaltySlider.value = self.gameSetting.mismatchPenalty;
    self.flipcostSlider.value = self.gameSetting.flipCost;
    
    [self setLabel:self.matchBonusScoreLabel forSlider:self.matchBonusSlider];
    [self setLabel:self.mismatchPenaltyScoreLabel forSlider:self.mismatchPenaltySlider];
    [self setLabel:self.flipCostScoreLabel forSlider:self.flipcostSlider];
}


-(GameSetting *)gameSetting {
    if(!_gameSetting) {_gameSetting = [[GameSetting alloc]init];}
    return _gameSetting;
}



- (IBAction)MBSilderChange:(UISlider *)sender {
    [self setLabel:self.matchBonusScoreLabel forSlider:sender];
    self.gameSetting.matchBonus = floor(sender.value);
    
}


- (IBAction)MPSliderchange:(UISlider *)sender {
    [self setLabel:self.mismatchPenaltyScoreLabel forSlider:sender];
    self.gameSetting.mismatchPenalty = floor(sender.value);
}

- (IBAction)FCSliderChange:(UISlider *)sender {
    [self setLabel:self.flipCostScoreLabel forSlider:sender];
    self.gameSetting.flipCost = floor(sender.value);
}

//helper method to set the discrete value
- (void)setLabel:(UILabel *)label forSlider:(UISlider *)slider
{
    NSInteger sliderValue;
    //4 she 5 ru, very typical implementation, please remember it well!
    sliderValue = lroundf(slider.value);
    [slider setValue:sliderValue animated:NO];
    label.text = [NSString stringWithFormat:@"%ld", sliderValue];
}

@end
